#Rootplot EZ analysis tools
#Run immediately after running main Rootplot script for further analysis
#Ensure that heatplot REGR color scale is set appropriately first in rootplot, those settings will be reused here

# IMPORT DATA AND PARAMETERS ----------------------------------------------


#Parameters
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
velo_min_color <- as.numeric(as.character(params[14,1]))
velo_max_color <- as.numeric(as.character(params[15,1]))
velo_x_tick <- as.numeric(as.character(params[16,1]))
velo_y_tick <- as.numeric(as.character(params[17,1]))
REGR_min_color <- as.numeric(as.character(params[18,1]))
REGR_max_color <- as.numeric(as.character(params[19,1]))
REGR_x_tick <- as.numeric(as.character(params[20,1]))
REGR_y_tick <- as.numeric(as.character(params[21,1]))
abs_contour <- as.numeric(as.character(params[22,1]))
percentmax_contour <- as.numeric(as.character(params[23,1]))
#Libraries
library(ggplot2) #plotting
library(reshape2) #data manipulation
library(RColorBrewer) #color scale functions
#Data
dat_REGR_smooth <- read.csv(paste0("./output/",out_prefix, "-REGR-smoothed.csv"), header = TRUE)

#Required functions from Rootplot main script
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

#edit gray values to fit scale
matrix_dat_REGR_smooth_limadj <- min.max.adjust(dat_REGR_smooth, minlim = REGR_min_color, maxlim = REGR_max_color)
dat_REGR_smooth_limadj <- data.frame(matrix_dat_REGR_smooth_limadj)
limadj_temp <- matrix(data = unlist(dat_REGR_smooth_limadj),nrow = dim(dat_REGR_smooth_limadj)[1],ncol = dim(dat_REGR_smooth_limadj)[2])
limadj <- as.data.frame(limadj_temp)
#moving forward with:
  #dat_REGR_smooth
  #limadj

# ABSOLUTE METHOD ----------------------------------------------

#plot to display
#create function
heatplot.regr.EZ.abs <- function(df, contour) {
  #prep data (limadj)
  df_trans <- t(df)
  data.raw <- df_trans
  data.matrix <- matrix(data.raw, nrow = dim(data.raw)[1], ncol = (dim(data.raw)[2]))
  data.melted <- melt(data.matrix)
  #heat plot
  hm.palette <- colorRampPalette(rev(brewer.pal(11, 'Spectral')), space='Lab')  
  ggplot(data.melted, aes(x = Var1, y = Var2, fill = value)) + 
    #label
    ggtitle(paste("EZ - Absolute Definition: ",contour)) +
    labs(x = "time (frames)", y = "distance from QC (adjusted midline reference points)") +
    #geom
    geom_tile() +
    scale_fill_gradientn(colours = hm.palette(100),limits=c(REGR_min_color,REGR_max_color))+
    scale_x_continuous(breaks=seq(0,dim(dat_REGR_smooth_limadj)[2],REGR_x_tick))+
    scale_y_continuous(breaks=seq(0,dim(dat_REGR_smooth_limadj)[1],REGR_y_tick))+
    scale_colour_gradient(low = "black", high = "white")+
    geom_contour(mapping = aes(x = Var1, y = Var2, z = value), data = data.melted, binwidth = contour, colour = 'black')
}

#execute function
heatplot.regr.EZ.abs(df=limadj, contour=abs_contour)
#save a file of the plot
png(
  paste0(
    "./output/",
    out_prefix,
    "-REGR-absolute-contours.png"
  ),
  width=i_width,
  height=i_height
) 
heatplot.regr.EZ.abs(df=limadj, contour=abs_contour)
dev.off()

#calculate widths

#make my own filter function for a single row
temp_dat <- c(5,6,7,45,20,56,6,7,10)
#function: filter single row, delete smaller values
filter.single.row.length <- function(list, cutoff){
  x <- NULL
  map <- c(1:length(list))
  output <- NULL
  for(x in map){
    if(list[x] >= cutoff){output <- c(output, list[x])}
    else {}
  }
  length(output)
}

#primary function: loop through rows? columns? applying filter/length function
length(dat_REGR_smooth[,1])
dim(dat_REGR_smooth)[2]
filter.abs <- function(data, abs){
  y <- NULL
  rowmap <- c(1:dim(data)[2])
  rowoutput <- NULL
  for(y in rowmap){
    rowoutput <- c(rowoutput, filter.single.row.length(data[,y], abs))
  }
  rowoutput
}
abswidths_temp <- filter.abs(dat_REGR_smooth, abs_contour)
abswidths <- data.frame(abswidths_temp)
frame <- c(1:length(abswidths_temp))
abs_plot <- cbind(frame, (abswidths*ref_midline_interval))
#plot abswidths
ggplot(abs_plot, aes(x = frame)) +
  #label
  ggtitle(paste("EZ Width - Absolute Definition: ",abs_contour)) +
  labs(x = "Time (frame)", y = "EZ width (pixels)") +
  #mean and SD
  geom_line(data = abs_plot, aes(y = abswidths_temp),
            colour = 'black', size = 1)
#save plot
png(
  paste0(
    "./output/",
    out_prefix,
    "-EZ-width-absolute.png"
  ),
  width=i_width,
  height=i_height
) 
ggplot(abs_plot, aes(x = frame)) +
  #label
  ggtitle(paste("EZ Width - Absolute Definition: ",abs_contour)) +
  labs(x = "Time (frame)", y = "EZ width (pixels)") +
  #mean and SD
  geom_line(data = abs_plot, aes(y = abswidths_temp),
            colour = 'black', size = 1)
dev.off()
#save the data file
#save/export data
write.table(
  abs_plot,
  file=paste0("./output/", out_prefix, "-EZ-width-absolute.csv"),
  sep=",",
  row.names=FALSE
)


# GROWTH MAXIMUM MOVEMENT PLOT --------------------------------------------

#define function
EZ.max.loc <- function(vector){
  xx <- NULL
  max_map <- 1:dim(vector)[2]
  maxoutput <- NULL
  for(xx in max_map){
    tempmax <- which(vector[,xx]==max(vector[,xx]))
    maxoutput <- c(maxoutput, tempmax)
  }
  maxoutput
}
#execute function
max_rough <- EZ.max.loc(dat_REGR_smooth)
frame <- 1:length(max_rough)
max_plot_mat <- cbind(frame, max_rough)
max_plot <- data.frame(max_plot_mat)
#temporary plot
heatplot.regr.max <- function(df, max_df) {
  #prep data (limadj)
  df_trans <- t(df)
  data.raw <- df_trans
  data.matrix <- matrix(data.raw, nrow = dim(data.raw)[1], ncol = (dim(data.raw)[2]))
  data.melted <- melt(data.matrix)
  #heat plot
  hm.palette <- colorRampPalette(rev(brewer.pal(11, 'Spectral')), space='Lab')  
  ggplot(data.melted, aes(x = Var1, y = Var2, fill = value)) + 
    #label
    ggtitle("EZ - Maximum") +
    labs(x = "time (frames)", y = "distance from QC (adjusted midline reference points)") +
    #geom
    geom_tile() +
    scale_fill_gradientn(colours = hm.palette(100),limits=c(REGR_min_color,REGR_max_color))+
    scale_x_continuous(breaks=seq(0,dim(dat_REGR_smooth_limadj)[2],REGR_x_tick))+
    scale_y_continuous(breaks=seq(0,dim(dat_REGR_smooth_limadj)[1],REGR_y_tick))+
    geom_point(inherit.aes=FALSE, data=max_df, mapping=aes(x=frame, y=max_rough))
    }
#exeute plot
heatplot.regr.max(limadj, max_plot)

#save max plot
png(
  paste0(
    "./output/",
    out_prefix,
    "-EZ-max.png"
  ),
  width=i_width,
  height=i_height
) 
heatplot.regr.max(limadj, max_plot)
dev.off()

#save max data file
write.table(
  max_plot,
  file=paste0("./output/", out_prefix, "-EZ-max.csv"),
  sep=",",
  row.names=FALSE
)
# PERCENTAGE METHOD -------------------------------------------

percentmax.filter <- function(data, percent){
  z <- NULL
  percentmap <- c(1:dim(data)[2])
  percentoutput <- NULL
  for(z in percentmap){
    colmaximum <- max(data[,z])
    filter <- (colmaximum-(colmaximum*percent))
    percentoutput <- c(percentoutput, filter.single.row.length(data[,z], filter))
  }
  percentoutput
}
percentmax_vals_temp <- percentmax.filter(dat_REGR_smooth, percentmax_contour)
percentmax_vals <- percentmax_vals_temp*ref_midline_interval
frame <- 1:length(percentmax_vals)
percentmax_plot_mat <- cbind(frame, percentmax_vals)
percentmax_plot <- data.frame(percentmax_plot_mat)

#display plot
ggplot(percentmax_plot, aes(x = frame)) +
  #label
  ggtitle(paste("EZ Width - Percent of Maximum: ",(percentmax_contour*100),'%')) +
  labs(x = "Time (frame)", y = "EZ width (pixels)") +
  #mean and SD
  geom_line(data = percentmax_plot, aes(y = percentmax_vals),
            colour = 'black', size = 1)

#save plot
png(
  paste0(
    "./output/",
    out_prefix,
    "-EZ-width-absolute.png"
  ),
  width=i_width,
  height=i_height
) 
ggplot(percentmax_plot, aes(x = frame)) +
  #label
  ggtitle(paste("EZ Width - Percent of Maximum: ",(percentmax_contour*100),'%')) +
  labs(x = "Time (frame)", y = "EZ width (pixels)") +
  #mean and SD
  geom_line(data = percentmax_plot, aes(y = percentmax_vals),
            colour = 'black', size = 1)
dev.off()
#save data
write.table(
  percentmax_plot,
  file=paste0("./output/", out_prefix, "-EZ-width-percentmax.csv"),
  sep=",",
  row.names=FALSE
)