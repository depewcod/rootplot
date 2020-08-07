# Rootplot ver 1.0
# By: Cody DePew - depewcod@gmail.com
# Summer 2020

# LOAD PARAMETERS AND DATA ------------------------------------------------

# load parameters from user-defined-parameters.csv
params <- read.csv(file="user-defined-parameters.csv", header=TRUE, sep=",")
# pull values from params file
data_in <- as.character(params[1,1])
out_prefix <- as.character(params[2,1])
ref_midline_interval <- as.numeric(as.character(params[3,1]))
i_width <- as.numeric(as.character(params[4,1]))
i_height <- as.numeric(as.character(params[5,1]))
twoD_x_tick_int <- as.numeric(as.character(params[6,1]))
twoD_y_tick_int <- as.numeric(as.character(params[7,1]))
angle_y_tick_int <- as.numeric(as.character(params[8,1]))
angle_1 <- as.numeric(as.character(params[9,1]))
angle_2 <- as.numeric(as.character(params[10,1]))
twoD_velo_plot_frame <- as.numeric(as.character(params[11,1]))
f_smooth <- as.numeric(as.character(params[12,1]))
f_smooth_horiz <- as.numeric(as.character(params[13,1]))
f_smooth_space_REGR <- as.numeric(as.character(params[14,1]))
f_smooth_time_REGR <- as.numeric(as.character(params[15,1]))

velo_min_color <- as.numeric(as.character(params[16,1]))
velo_max_color <- as.numeric(as.character(params[17,1]))
velo_x_tick <- as.numeric(as.character(params[18,1]))
velo_y_tick <- as.numeric(as.character(params[19,1]))
REGR_min_color <- as.numeric(as.character(params[20,1]))
REGR_max_color <- as.numeric(as.character(params[21,1]))
REGR_x_tick <- as.numeric(as.character(params[22,1]))
REGR_y_tick <- as.numeric(as.character(params[23,1]))
# finish
rm(params)
# leave these set to 1
# variables will be used in a future version of Rootplot
time_int <- 1
dist_int <- 1
iter_x <- 3

#import raw data
dat_xy <- read.csv(paste0("./input/",data_in, ".csv"), header = FALSE)

#load third party packages
#packages must already be installed
library(ggplot2) #plotting
library(reshape2) #data manipulation
library(RColorBrewer) #color scale functions


# CONSTRUCT MIDLINE OF QCDIST VALUES --------------------------------------

#define function - distance between two XY values
#input 4-value vector: X1 Y1 X2 Y2
pythag_dist <- function(vect) { # to calculate pythagorean theorom
  sqrt(((vect[1]-vect[3])^2) + ((vect[2]-vect[4])^2))}

#input: 4 columns for pythag calculation
#scan rows downward, applying pythag_dist func
#reform into one column
rowloopqcdist_func <- function(df) {
  #map - moving down, regurn one row at a time
  map <- 1:(dim(df)[1])
  #create empty data frame
  byrow <- NULL
  #loop
  for(x in map) {
    row <- as.numeric(df[x, ]) #return row as numeric vector
    value <- pythag_dist(row) #apply qcdist to get one value per row
    byrow <- c(byrow, value) #add value to list
  }
  byrow
}

#calculate distance from qc - primary function
xy.qcdist <- function(df2) {
  #map - through window of 4 columns that shifts right by two columns each iteration
  map <- (2:(ncol(df2) / 2)) *2
  qcdist_calc <- NULL
  for(col in map) {
    #construct data frame
    df_temp <- data.frame(df2[ ,(col - 3):(col)])
    #scan by row, calculate qcdist
    single_qcdist_col <- rowloopqcdist_func(df_temp)
    #remerge
    qcdist_calc <- cbind(qcdist_calc, single_qcdist_col)
  }
  output <- data.frame(qcdist_calc)
  #transpose data
  output_trans <- t(output)
  output_trans_df <- data.frame(output_trans)
  output_trans_df
}
dat_pythag <-  xy.qcdist(dat_xy)

# CONSTRUCT MIDLINE FROM SEGMENTS
# first loop through column by column
# construct running sums to get midline
map_pythag <- 1:ncol(dat_pythag)
midline_output <- NULL
for (xx in map_pythag){
  single_pythag_col <- dat_pythag[ ,xx]
  #loop down the row to calculate midline
  map_single_mid <- 2:length(single_pythag_col)
  single_midline <- single_pythag_col[1]
  for (xxx in map_single_mid){
    single_value_temp <- single_pythag_col[xxx] + single_midline[length(single_midline)]
    single_midline <- c(single_midline, single_value_temp)
  } #end of secondary for loop
  midline_output <- cbind(midline_output, single_midline)
} #end of for loop (col by col)
dat_qcdist <- midline_output

#export dat_qcdist
write.table(
  dat_qcdist,
  file = paste0("./output/",out_prefix,"-midlines.csv"),
  sep=",",
  row.names=FALSE
)

# MIDLINE GROWTH RATE -----------------------------------------------------

#extract length of full midlines from end of dat_qcdist
full_midline_lengths <- dat_qcdist[nrow(dat_qcdist), ]

# calculate change in distance per unit time
midline_interval <- NULL
#map does not include first value
midline_map <- 2:length(full_midline_lengths)
#loop through 
for (mid in midline_map){
  temp_int <- full_midline_lengths[mid] - full_midline_lengths[mid - 1]
  midline_interval <- c(midline_interval, temp_int)
}
#make data frame
df_midline_interval <- data.frame(midline_interval)
#midline_interval transposition
midline_interval_trans <- t(df_midline_interval)

#export
#name
dfmint_name <- "growth_rate"
colnames(df_midline_interval) <- dfmint_name
#export
write.table(
  df_midline_interval,
  paste0("./output/", out_prefix, "-midline-growth-rate.csv"),
  sep=",",
  row.names=FALSE
)

#prepare for plotting
dim(df_midline_interval)
1:dim(df_midline_interval)[1]
mid_int_trans_labeled <- cbind(1:dim(df_midline_interval)[1], df_midline_interval)
mitl_df <- data.frame(mid_int_trans_labeled)
names(mitl_df) <- c("frame", "growthrate")

#plot midline growth rate
ggplot(mitl_df, aes(x = frame)) +
  #label
  ggtitle("Growth Rate - Based on Midline length") +
  labs(x = "Time (frame)", y = "Growth Rate (pixels/frame)") +
  #mean and SD
  geom_line(data = mitl_df, aes(y = growthrate),
            colour = 'black', size = 1) +
  scale_x_continuous(breaks=seq(0,max(mitl_df[1]),twoD_x_tick_int))+
  scale_y_continuous(breaks=seq(0,max(mitl_df[2]),twoD_y_tick_int))
#save plot
png(
  paste0(
    "./output/",
    out_prefix,
    "-midline-growth-rate.png"
  ),
  width=i_width,
  height=i_height
) 
#source: modified from help
ggplot(mitl_df, aes(x = frame)) +
  #label
  ggtitle("Growth Rate - Based on Midline length") +
  labs(x = "Time (frame)", y = "Growth Rate (pixels/frame)") +
  #mean and SD
  geom_line(data = mitl_df, aes(y = growthrate),
            colour = 'black', size = 1) + 
  scale_x_continuous(breaks=seq(0,max(mitl_df[1]),twoD_x_tick_int))+
  scale_y_continuous(breaks=seq(0,max(mitl_df[2]),twoD_y_tick_int))
dev.off()


# ANGLE CALCULATION -------------------------------------------------------

#convert midpoint points to second col numbers
angle_1b <- angle_1*2
angle_2b <- angle_2*2

#loop through each row of correct data
angle_map <- 1:dim(dat_xy)[1]
angle_output <- NULL
for (angle_x in angle_map){
  x1_angle <- dat_xy[angle_x,(angle_1b-1)]
  y1_angle <- dat_xy[angle_x, angle_1b]
  x2_angle <- dat_xy[angle_x, (angle_2b-1)]
  y2_angle <- dat_xy[angle_x, angle_2b]
  #PUT IN SAFEGUARD HERE FOR IF IT CALCULATES A ZERO DENOMINATOR
  
  single_angle_rad <- atan(abs(y2_angle-y1_angle)/abs(x1_angle-x2_angle))
  single_angle_deg <- (single_angle_rad*(180/pi))
  angle_output <- c(angle_output, single_angle_deg)
} #end of angle_x for loop
angle_length <- 1:length(angle_output)
angle_matrix <- cbind(angle_length, angle_output)
colnames(angle_matrix) <- c("frame", "angle")
angle_df <- data.frame(angle_matrix)

min(angle_df[2])

#plot angles
ggplot(angle_df, aes(x = frame)) +
  #label
  ggtitle(paste0("Root Angle - Points ", as.character(angle_1), " to ", as.character(angle_2))) +
  labs(x = "Time (frame)", y = "Angle (degrees)") +
  #mean and SD
  geom_line(data = angle_df, aes(y = angle),
            
            colour = 'black', size = 1) +
  scale_x_continuous(breaks=seq(0,max(angle_df[1]),twoD_x_tick_int))+
  scale_y_continuous(breaks=seq(as.integer(min(angle_df[2]))-1,max(angle_df[2]),angle_y_tick_int))
#save plot
png(
  paste0(
    "./output/",
    out_prefix,
    "-angle.png"
  ),
  width=i_width,
  height=i_height
) 
ggplot(angle_df, aes(x = frame)) +
  #label
  ggtitle(paste0("Root Angle - Points ", as.character(angle_1), " to ", as.character(angle_2))) +
  labs(x = "Time (frame)", y = "Angle (degrees)") +
  #mean and SD
  geom_line(data = angle_df, aes(y = angle),
            colour = 'black', size = 1) +
  scale_x_continuous(breaks=seq(0,max(angle_df[1]),twoD_x_tick_int))+
  scale_y_continuous(breaks=seq(0,max(angle_df[2]),angle_y_tick_int))
dev.off()

final_angle_map <- 2:length(angle_output)
angle_change <- 0
for (angle_change_x in final_angle_map){
  single_change <- (angle_output[angle_change_x]-angle_output[angle_change_x-1])
  angle_change <- c(angle_change, single_change)
} # end of for loop

final_angles <- cbind(1:length(angle_output),angle_output,angle_change)
final_angles_df <- data.frame(final_angles)
colnames(final_angles_df) <- c("frame", "angle", "dAngledt")

#plot angle change
ggplot(final_angles_df, aes(x = frame)) +
  #label
  ggtitle(paste0("dAngle/dt - Points ", as.character(angle_1), " to ", as.character(angle_2))) +
  labs(x = "Time (frame)", y = "dAngle/dt (degrees/frame)") +
  #mean and SD
  geom_line(data = final_angles_df, aes(y = dAngledt),
            colour = 'black', size = 1)
 
#save plot
png(
  paste0(
    "./output/",
    out_prefix,
    "-dAngle-dt.png"
  ),
  width=i_width,
  height=i_height
) 
#plot angle change
ggplot(final_angles_df, aes(x = frame)) +
  #label
  ggtitle(paste0("dAngle/dt - Points ", as.character(angle_1), " to ", as.character(angle_2))) +
  labs(x = "Time (frame)", y = "dAngle/dt (degrees/frame)") +
  #mean and SD
  geom_line(data = final_angles_df, aes(y = dAngledt),
            colour = 'black', size = 1)
 dev.off()

#export
write.table(
  final_angles_df,
  paste0("./output/", out_prefix, "-angles.csv"),
  sep=",",
  row.names=FALSE
)

# VELOCITY ----------------------------------------------------------------

#calculate velocity
#define primary function
qcdist.velo <- function(df) {
  #define secondary functions
  #define velocity function
  velo_func <- function(vect) {
    (vect[2] - vect[1]) / time_int
  }
  #define function to make sliding 2-frame window over a single row, applying velo function
  velo_row_func <- function(rowinput) {
    map_rowscan <- 1:(length(rowinput) - 1)
    velo <- NULL
    for (scanloc in map_rowscan) {
      new_velo <- velo_func(c(rowinput[scanloc], rowinput[(scanloc +1)]))
      velo <- c(velo, new_velo)
    }
    velo
  }
  #main function - apply above to each row 
  map_allrows <- 1:(dim(df)[1])
  velo_df <- NULL
  for(x in map_allrows) {
    row <- as.numeric(df[x, ])
    row_velo <- velo_row_func(row)
    velo_df <- rbind.data.frame(velo_df, row_velo)
  }
  velo_df
}
#run function on qcdist data
dat_velo_raw <- qcdist.velo(dat_qcdist)
#export dat_velo_raw
write.table(
  dat_velo_raw,
  file = paste0("./output/", out_prefix, "-velocity-raw.csv"),
  sep=",",
  row.names=FALSE
)

# REVERSE THE ORDER OF COLUMNS
# correction - all of the heatplot functions otherwise plot time backwards.
col.rev <- function(df_for) {
  rev_map <- ncol(df_for):1
  df_rev <- NULL
  for(rev_id in rev_map){
    temp_col <- df_for[ ,rev_id]
    df_rev <- cbind(df_rev, temp_col) #bind them here
  } # end of for loop
  df_rev
} #end of colrev function definition
#apply the function to dat_velo_raw here
dat_velo_raw_rev <- col.rev(dat_velo_raw)


# PLOT RAW VELOCITY -------------------------------------------------------

# plot example velocity (one time point) in 2D
plot.single.time <- function(df, single = 65) {
  #prep data
  df_trans <- t(df)
  data.raw <- df_trans
  data.matrix <- matrix(data.raw, nrow = dim(data.raw)[1], ncol = (dim(data.raw)[2]))
  #plot one line
  ggplot() +
    #label
    ggtitle(paste0("raw velocity data at frame ", as.character(twoD_velo_plot_frame), " (original tracked points)")) +
    labs(x = "distance from P0 (# tracked midline points)", y = "velocity (pixels/frame)") +
    #lines
    geom_line(
      aes(
        x = 
          c(1:dim(data.matrix)[2]),
        y = 
          data.matrix[single, ]
      )
    )
}
#save a file of the graph
#plot.single.time(dat_velo_raw, single = twoD_velo_plot_frame)
#png(
#  paste0(
#    "./output/",
#    out_prefix,
#    "-2D-velocity-frame-",
#    as.character(twoD_velo_plot_frame),
#    ".png"
#         ),
#  width=i_width,
#  height=i_height
#  ) 
#plot.single.time(dat_velo_raw, single = twoD_velo_plot_frame)
#dev.off()


#heatplot with autoscale for color
#define function
heatplot.autoscale.velo.raw <- function(df) {
  #prep data
  df_trans <- t(df)
  data.raw <- df_trans
  data.matrix <- matrix(data.raw, nrow = dim(data.raw)[1], ncol = (dim(data.raw)[2]))
  #melt
  data.melted <- melt(data.matrix)
  #heat plot
  hm.palette <- colorRampPalette(rev(brewer.pal(11, 'Spectral')), space='Lab')  
  ggplot(data.melted, aes(x = Var1, y = Var2, fill = value)) + 
    #label
    ggtitle("Raw Velocity Data (midpoint shift not adjusted) automatic scale") +
    labs(x = "frame", y = "distance (midline point number)") +
    #eom
    geom_tile() +
    scale_fill_gradientn(colours = hm.palette(100))
}
#save a file of the graph
heatplot.autoscale.velo.raw(dat_velo_raw)
png(
  paste0(
    "./output/",
    out_prefix,
    "-velocity-raw-unadjusted.png"
  ),
  width=i_width,
  height=i_height
) 
heatplot.autoscale.velo.raw(dat_velo_raw)
dev.off()

# VELOCITY SMOOTHING --------------------------------

#preview effect of local regression parameters
preview.smooth <- function(df, which.line = 65, f = 0.1) {
  #make data frame
  dat_ex <-
    data.frame(
      c(1:length(df[, which.line])),
      df[ , which.line]
    )
  colnames(dat_ex) <- c("pt", "velo")
  #smoothing
  dat_regress <- 
    lowess(
      x = dat_ex$pt,
      y = dat_ex$velo,
      f = f,
      iter = iter_x,
      delta = 0.01 * diff(range(dat_ex$velo)
      )
    )
  #make data.frame
  regression <- data.frame(dat_regress)
  #quick plot - smooth and raw
  ggplot() +
    #label
    ggtitle(
      paste(
        "Frame ",
        which.line,
        ", f = ",
        f
      )
    ) +
    labs(x = "distance from P0 (# tracked midline points)", y = "velocity (pixels/frame)") +
    #unsmoothed
    geom_line(
      aes(
        x = dat_ex$pt,
        y = dat_ex$velo
      ),
      color = "black",
      size = 1
    ) +
    #smoothed
    geom_line(
      aes(
        x = regression$x,
        y = regression$y
      ),
      color = "red",
      size = 2,
      alpha = 0.4
    ) 
}
preview.smooth(dat_velo_raw, which.line = twoD_velo_plot_frame, f = f_smooth)
png(
  paste0(
    "./output/",
    out_prefix,
    "-2D-velocity-smoothing.png"
  ),
  width=i_width,
  height=i_height
) 
preview.smooth(dat_velo_raw, which.line = twoD_velo_plot_frame, f = f_smooth)
dev.off()

#smooth all velocity data
smooth.all <- function(df, f = 0.1) {
  #create x scale based on dist
  dist_rows_temp <- 1:nrow(df)
  dist <- dist_rows_temp * dist_int
  #map for each column
  map <- 1:ncol(df)
  #make blank data.frame
  dat_smooth_raw <- NULL
  #loop
  for(col in map) {
    #smoothing
    dat_regress <- 
      lowess(
        x = dist,
        y = df[ , col],
        f = f,
        iter = iter_x,
        delta = 0.01 * diff(range(df[ , col]))
      )
    #turn into data.frame
    dat_regress_df <- data.frame(dat_regress)
    #remove regression line
    dat_regress_one <- dat_regress_df[ , 2]
    #bind columns
    dat_smooth_raw <- cbind(dat_smooth_raw, dat_regress_one)
  }
  data.frame(dat_smooth_raw)
}
dat_velo_smooth_raw <- smooth.all(dat_velo_raw_rev, f = f_smooth)


# CORRECT FOR MIDPOINT SHIFT ----------------------------------

#reverse, shift midpoints, reverse back
dat_velo_smooth_raw_rev <- col.rev(dat_velo_smooth_raw)

#cycle through each column of dat_velo_smooth_raw and write a new table with shift corrected values
shiftmap <- 1:ncol(dat_velo_smooth_raw_rev)
dat_velo_shift <- NULL
for(shiftcol in shiftmap) {
  # generate a function for the one column you picked
  tempfun <- approxfun(
    as.numeric(dat_qcdist[, shiftcol]),
    as.numeric(dat_velo_smooth_raw_rev[, shiftcol]),
    method = "linear",
    yleft = min(as.numeric(dat_velo_smooth_raw_rev[, shiftcol])),
    yright = max(as.numeric(dat_velo_smooth_raw_rev[, shiftcol])),
    rule = 2,
    ties = "ordered"
  )
  #use function to generate adjusted values
  shift_singlecol <- tempfun(dat_qcdist[, 1])
  #bind adjsted values to create shifted table
  dat_velo_shift <- cbind(shift_singlecol, dat_velo_shift)
}

#reverse dat_velo_shift back to original orientation
dat_velo_shift_rev <- col.rev(dat_velo_shift)


# PERPENDICULAR LOWESS SMOOTHING
#first resmooth the vertical velocity
dat_velo_shift_smooth <- smooth.all(dat_velo_shift_rev, f = f_smooth)
#transpose
dat_velo_smooth_trans <- t(dat_velo_shift_smooth)
#smooth
dat_velo_smooth_trans_smooth <- smooth.all(dat_velo_smooth_trans, f = f_smooth_horiz)
#transpose back
dat_velo_final <- t(dat_velo_smooth_trans_smooth)
#export
write.table(
  dat_velo_final,
  file = paste0("./output/",out_prefix,"-velocity-smoothed-and-midlineshiftcorrected.csv"),
  sep=",",
  row.names=FALSE
)

# PLOT VELOCITY
#define function
heatplot.autoscale.velo.smooth <- function(df) {
  #prep data
  df_trans <- t(df)
  data.raw <- df_trans
  data.matrix <- matrix(data.raw, nrow = dim(data.raw)[1], ncol = (dim(data.raw)[2]))
  #melt
  data.melted <- melt(data.matrix)
  #heat plot
  hm.palette <- colorRampPalette(rev(brewer.pal(11, 'Spectral')), space='Lab')  
  ggplot(data.melted, aes(x = Var1, y = Var2, fill = value)) + 
    #label
    ggtitle("Smoothed Velocity Data - Adjusted for midline point shifting") +
    labs(x = "time (frame)", y = "distance from P0 (# tracked midline points)") +
    #geom
    geom_tile() +
    scale_fill_gradientn(colours = hm.palette(100))
}
heatplot.autoscale.velo.smooth(dat_velo_final)
png(
  paste0(
    "./output/",
    out_prefix,
    "-velocity-auto-scale.png"
  ),
  width=i_width,
  height=i_height
) 
heatplot.autoscale.velo.smooth(dat_velo_final)
dev.off()


#edit data that falls outside of limits to avoid gray values in heatplot
rowfunction <- function(row1, min_lim = 0, max_lim = 1, reference_data) {
  rmap <- 1:ncol(reference_data)
  routput <- NULL
  for (x in rmap) {
    temp_val <- row1[x]
    if (temp_val > max_lim){temp_val <- max_lim}
    else{temp_val <- temp_val}
    routput <- c(routput, temp_val)
  }
  rm(temp_val)
  routput2 <- NULL
  for (x in rmap) {
    temp_val <- routput[x]
    if (temp_val < min_lim){temp_val <- min_lim}
    else{temp_val <- temp_val}
    routput2 <- c(routput2, temp_val)
  }
  routput2
}

min.max.adjust <- function(dat, minlim = 0, maxlim = 1){
  cmap <- 1:nrow(dat)
  coutput <- NULL
  for (y in cmap){
    temp_row <- dat[y, ]
    new_temp_row <- rowfunction(temp_row, min_lim = minlim, max_lim = maxlim, dat)
    coutput <- rbind(coutput, new_temp_row)
  }
  coutput
}

dat_velo_smooth_matrix <- data.matrix(dat_velo_final)
dat_velo_smooth_matrix2 <- min.max.adjust(dat_velo_smooth_matrix, minlim = velo_min_color, maxlim = velo_max_color)

# smoothed velocity - heatplot with custom color scaling (based on parameters.csv)
heatplot.velo.lim <- function(df) {
  #prep data
  df_trans <- t(df)
  data.raw <- df_trans
  data.matrix <- matrix(data.raw, nrow = dim(data.raw)[1], ncol = (dim(data.raw)[2]))
  #melt
  data.melted <- melt(data.matrix)
  #heat plot
  hm.palette <- colorRampPalette(rev(brewer.pal(11, 'Spectral')), space='Lab')  
  ggplot(data.melted, aes(x = Var1, y = Var2, fill = value)) + 
    #label
    ggtitle("Velocity Data - user-defined scale") +
    labs(x = "time (frame)", y = "distance from P0 (# tracked midline points)") +
    #geom
    geom_tile() +
    scale_fill_gradientn(colours = hm.palette(100),limits=c(velo_min_color,velo_max_color))+
    scale_x_continuous(breaks=seq(0,dim(dat_velo_smooth_matrix2)[2],velo_x_tick))+
    scale_y_continuous(breaks=seq(0,dim(dat_velo_smooth_matrix2)[1],velo_y_tick))
}
heatplot.velo.lim(dat_velo_smooth_matrix2)
png(
  paste0(
    "./output/",
    out_prefix,
    "-velocity-manual-scale.png"
  ),
  width=i_width,
  height=i_height
) 
heatplot.velo.lim(dat_velo_smooth_matrix2)
dev.off()

# REGR -----------------------------------------------------------

#calculate relel
#define functions
velo.relel <- function(df) {
  dxdt_func <- function(vect) {
    (vect[2] - vect[1]) / time_int
  }
  dxdt_col_func <- function(colinput) {
    map_colscan <- 1:(length(colinput) - 1)
    output1 <- NULL
    for (scanloc in map_colscan) {
      new_velo <- dxdt_func(c(colinput[scanloc], colinput[(scanloc +1)]))
      output1 <- c(output1, new_velo)
    }
    output1
  }
  map_relelcols <- 1:ncol(df)
  col_df <- NULL
  for(x in map_relelcols) {
    col <- as.numeric(df[ , x])
    col_relel <- dxdt_col_func(col)
    col_df <- cbind(col_df, col_relel)
  }
  col_df_realdf <- data.frame(col_df)
  col_df_realdf
}

#calculate REGR
dat_relel_raw <- velo.relel(dat_velo_final)
dat_relel_raw_10 <- dat_relel_raw/ref_midline_interval
#plot RELEL
#define function
heatplot.autoscale.regr.raw <- function(df) {
  #prep data
  df_trans <- t(df)
  data.raw <- df_trans
  data.matrix <- matrix(data.raw, nrow = dim(data.raw)[1], ncol = (dim(data.raw)[2]))
  #melt
  data.melted <- melt(data.matrix)
  #heat plot
  hm.palette <- colorRampPalette(rev(brewer.pal(11, 'Spectral')), space='Lab')  
  ggplot(data.melted, aes(x = Var1, y = Var2, fill = value)) + 
    #label
    ggtitle("REGR Raw Data - automatic scale") +
    labs(x = "time (frame)", y = "distance from P0 (# tracked midline points)") +
    #geom
    geom_tile() +
    scale_fill_gradientn(colours = hm.palette(100))
}
heatplot.autoscale.regr.raw(dat_relel_raw_10)
png(
  paste0(
    "./output/",
    out_prefix,
    "-REGR-raw.png"
  ),
  width=i_width,
  height=i_height
) 
heatplot.autoscale.regr.raw(dat_relel_raw_10)
dev.off()

#save/export data
write.table(
  dat_relel_raw_10,
  file=paste0("./output/", out_prefix, "-REGR-raw.csv"),
  sep=",",
  row.names=FALSE
  )

#edit data that falls outside of limits to avoid gray values in heatplot
#define secondary function
max.single.row <- function(row_single, max_row_lim, reference_data) {
  row_map_max <- 1:ncol(reference_data)
  single_row_output <- NULL
  for (x in row_map_max) {
    single_val_row <- row_single[x]
    if (single_val_row > max_row_lim){single_val_row <- max_row_lim}
    else{single_val_row <- single_val_row}
    single_row_output <- c(single_row_output, single_val_row)
  }
  single_row_output
}
#define secondary function  
min.single.row <- function(row_single_min, min_row_lim, reference_data){
  row_map_min <- 1:ncol(reference_data)
  complete_single_row_output <- NULL
  for (y in row_map_min) {
    single_val_row_2 <- row_single_min[y]
    if (single_val_row_2 < min_row_lim){single_val_row_2 <- min_row_lim}
    else{single_val_row_2 <- single_val_row_2}
    complete_single_row_output <- c(complete_single_row_output, single_val_row_2)
  }
  complete_single_row_output
}
#define primary function
min.max.adjust <- function(original_data, minlim, maxlim){
  cmap <- 1:nrow(original_data)
  final_data <- NULL
  for (z in cmap){
    temp_row <- original_data[z, ]
    #change the line below to new functions
    adjusted_temp_row_max <- max.single.row(temp_row, max_row_lim = maxlim, original_data)
    adjusted_temp_row_max_min <- min.single.row(adjusted_temp_row_max, min_row_lim = minlim, original_data)
    final_data <- rbind(final_data, adjusted_temp_row_max_min)
  }
  final_data
}

dat_relel_raw_matrix <- data.matrix(dat_relel_raw_10)
dat_adjustminmax_relel <- min.max.adjust(dat_relel_raw_matrix, REGR_min_color, REGR_max_color)

# REGR SMOOTHING ----------------------------------------------------------

#smooth all REGR data
dat_regr_smooth <- smooth.all(dat_relel_raw_10, f = f_smooth_space_REGR)
dat_regr_smooth_trans <- t(dat_regr_smooth)
dat_regr_smooth_trans_smooth <- smooth.all(dat_regr_smooth_trans, f = f_smooth_time_REGR)
dat_regr_smooth_final <- t(dat_regr_smooth_trans_smooth)

#plot smoothed regr
#define function
heatplot.autoscale.regr.smooth <- function(df) {
  #prep data
  df_trans <- t(df)
  data.raw <- df_trans
  data.matrix <- matrix(data.raw, nrow = dim(data.raw)[1], ncol = (dim(data.raw)[2]))
  #melt
  data.melted <- melt(data.matrix)
  #heat plot
  hm.palette <- colorRampPalette(rev(brewer.pal(11, 'Spectral')), space='Lab')  
  ggplot(data.melted, aes(x = Var1, y = Var2, fill = value)) + 
    #label
    ggtitle("Smoothed REGR Data - autoscale") +
    labs(x = "time (frame)", y = "distance from P0 (# tracked midline points)") +
    #geom
    geom_tile() +
    scale_fill_gradientn(colours = hm.palette(100))
}
#plot
heatplot.autoscale.regr.smooth(dat_regr_smooth_final)
png(
  paste0(
    "./output/",
    out_prefix,
    "-REGR-auto-scale.png"
  ),
  width=i_width,
  height=i_height
) 
heatplot.autoscale.regr.smooth(dat_regr_smooth_final)
dev.off()

#save/export data
write.table(
  dat_regr_smooth_final,
  file=paste0("./output/", out_prefix, "-REGR-smoothed.csv"),
  sep=",",
  row.names=FALSE
  )

# plot smoothed REGR - heatplot with custom color scaling (based on parameters.csv)
heatplot.regr.smooth.lim <- function(df) {
  #prep data
  df_trans <- t(df)
  data.raw <- df_trans
  data.matrix <- matrix(data.raw, nrow = dim(data.raw)[1], ncol = (dim(data.raw)[2]))
  #melt
  data.melted <- melt(data.matrix)
  #heat plot
  hm.palette <- colorRampPalette(rev(brewer.pal(11, 'Spectral')), space='Lab')  
  ggplot(data.melted, aes(x = Var1, y = Var2, fill = value)) + 
    #label
    ggtitle("Smoothed REGR Data - user-defined scale") +
    labs(x = "time (frames)", y = "distance from P0 (# tracked midline points)") +
    #geom
    geom_tile() +
    scale_fill_gradientn(colours = hm.palette(100),limits=c(REGR_min_color,REGR_max_color)) +
    scale_x_continuous(breaks=seq(0,dim(dat_regr_smooth_final)[2],REGR_x_tick))+
    scale_y_continuous(breaks=seq(0,dim(dat_regr_smooth_final)[1],REGR_y_tick))
}

#edit gray values to fit scale
dat_regr_smooth_final_matrix <- data.matrix(dat_regr_smooth_final)
dat_regr_smooth_limadj <- min.max.adjust(dat_regr_smooth_final_matrix, minlim = REGR_min_color, maxlim = REGR_max_color)
#plot
heatplot.regr.smooth.lim(dat_regr_smooth_limadj)
png(
  paste0(
    "./output/",
    out_prefix,
    "-REGR-manual-scale.png"
  ),
  width=i_width,
  height=i_height
) 
heatplot.regr.smooth.lim(dat_regr_smooth_limadj)
dev.off()

#cleanup
rm(dat_regr_smooth_limadj)
rm(dat_regr_smooth_trans)
rm(dat_regr_smooth_trans_smooth)
rm(dat_regr_smooth_final_matrix)


# E N D
