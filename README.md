RootPlot - ver 1.0
Author: Cody DePew (cld5311@psu.edu, depewcod@gmail.com)
Penn State University
Summer 2020

Bhat, A., C. DePew, and G. Monshausen. 2020. High-resolution analysis of root gravitropic bending using RootPlot.


~~~~~~~~ INTRODUCTION ~~~~~~~~

RootPlot is an R script designed for robust and assumption-free data analysis and visualization of high spatiotemporal resolution kinematic root growth data. RootPlot takes raw data obtained from other image analysis programs and creates line graphs and heatplots to visualize root growth over time. These raw data consist of X-Y coordinate values along the length of a growing root imaged at multiple time points. Raw data are generated according to the methods outlined in Shih et al., 2014, Curr Biol 24:1887-92.


RootPlot utilizes Locally-Weighted Scatterplot Smoothing (LOWESS) to perform local regression; smoothing of root velocity or elemental growth rate data is thus free of assumptions about the underlying shape of the growth profile.

RootPlot is not a program. It is a script written for R (http://www.r-project.org/) intended for use with the R studio IDE (http://www.rstudio.com/).


~~~~~~~~ HOW TO USE ROOTPLOT ~~~~~~~~

RootPlot is easy to use, even if you have little to no experience with R or R studio.

1) Download and install the latest versions of R and R studio from the links above.

2) In the RootPlot home folder, open the file "ROOTPLOT.Rproj" in R studio to access the RootPlot environment.

3) In the upper left quadrant of R studio, ensure that both "rootplot-v-1-0.R" (XXX depending on your current version of RootPlot) and "script-install-packages.R" are both open.

4) With an active internet connection, run the full script "script-install-packages.R" 
NOTE: THIS STEP MUST ONLY BE PERFORMED THE FIRST TIME YOU USE ROOTPLOT IF YOU DO NOT ALREADY HAVE THE REQUIRED R PACKAGES INSTALLED.

To run an R script in R studio:
   a) Open the script in the upper left quadrant of R studio
   b) Place cursor in the script and select the entire body of the
       script by pressing CTRL(or Command)+A
   c) Click "run" 

5) Supply raw data and parameters to RootPlot according to the "requirements for input" section below.

6) Open and run "rootplot-v-1-0.R" (see instructions in step 4)

7) Multiple graphs appear in the lower right quadrant of R studio. Use the arrow buttons to scroll and view graphs using the R studio graphical user interface. Note that “.png” images of these graphs will automatically populate the “output” folder.

8) Multiple ".csv" files with the prefix "output-" will populate the RootPlot home folder.

9) Ensure that all output files and charts are saved and labeled appropriately in a new folder before running RootPlot again. Output .csv and .png files will be overwritten when the RootPlot script is run again if output prefix is not changed in “user-defined-parameters.csv.”


~~~~~~~~ REQUIREMENTS FOR INPUT ~~~~~~~~

1.) RAW DATA - X-Y COORDINATES

XY coord. obtained from phytomorph according to Shih et al., 2014 and Bhat et al, 

RootPlot utilizes XY data from any source in the following format:

      | Ref Point | Ref point |   P2    |   P2    | ... |   Pn    |   Pn    |
      |  X coord  |  Y coord  | X coord | Y coord | ... | X coord | Y coord |
-----------------------------------------------------------------------------
  t1  |   Xr,1    |    Yr,1   |   X2,1  |   Y2,1  | ... |   Xn,1  |   Yn,1  |
  t2  |   Xr,2    |    Yr,2   |   X2,2  |   Y2,2  | ... |   Xn,2  |   Yn,2  |
  t3  |   Xr,3    |    Yr,3   |   X2,3  |   Y2,3  | ... |   Xn,3  |   Yn,3  |
  t4  |   Xr,4    |    Yr,4   |   X2,4  |   Y2,4  | ... |   Xn,4  |   Yn,4  |
  ... |   ...     |    ...    |   ...   |   ...   | ... |   ...   |   ...   |
  tn  |   Xr,n    |    Yr,n   |   X2,n  |   Y2,n  | ... |   Xn,n  |   Yn,n  |
-----------------------------------------------------------------------------

Note: Table should include X-Y coordinates only. Labels (e.g. t1, Ref. point X coord, etc...) are included here for demonstration only.

For  each timepoint t, Xr and Yr are coordinates of the first (or reference) point along the midline (e.g. the quiescent center/root tip) and each additional P (X-Y) pair represents the coordinates of points along the mid/edgeline progressively more distant from the reference point/

2) USER-DEFINED PARAMETERS

Access plotting parameters by opening the file "user-defined-parameters.csv" located in the RootPlot home folder. After making any necessary changes to the parameters (described in the user-defined-parameters.csv file itself), ensure that the file is saved before running RootPlot. RootPlot accesses the parameters directly from this file. NOTE: ENSURE THAT YOU ARE SAVING THE FILE AS ".CSV" MICROSOFT EXCEL MAY PROMPT YOU TO SAVE WITH ANOTHER FILE EXTENSION.

data_in: Name of file containing raw data (must be in "input" folder. Must be .csv file but do not include ".csv" extension in parameters)
out_prefix: Prefix for output files (no spaces)
ref_midline_interval: Distance (in pixels) between original (reference) tracked midline points
i_width: Width (pixels) of PNG output files
i_height: Height (pixels) of PNG output files
twoD_x_tick_int: Interval of x-axis (time/frame) tick marks for growth rate, root angle, and bending rate 2D plots.
growth_y_tick_int: Interval of y-axis tick marks for growth rate 2D plot.
angle_y_tick_int: Interval of y-axis tick marks for root angle 2D plot.
angle_1: First midline point for angle calculation (the QC/tip is point #1)
angle_2: Second midline point for angle calculation (for example, a value of three will calculate the angle of a line between the root tip (#1) and the third reference point)
twoD_velo_plot_frame: Frame number of single velocity profile to display as an example while performing LOWESS smoothing
f_smooth_space: For velocity: F value/smoother span, determines amount of smoothing in LOWESS function. Represents the fraction of total points that will be considered during regression.
f_smooth_time: For velocity: F value/smoother span (as above) but for horizontal (time) smoothing
f_smooth_space_REGR: For REGR: same as above
f_smooth_time_REGR: For REGR: same as above
velo_min_color: Minimum value of color scale for velocity heatplot
velo_max_color: Maximum value of color scale for velocity heatplot
velo_x_tick: Tick mark interval, velocity heatplot, x axis
velo_y_tick: Tick mark interval, velocity heatplot, y axis
REGR_min_color: Minimum value of color scale for REGR heatplot (units: percent per frame)
REGR_max_color: Maximum value of color scale for REGR heatplot
REGR_x_tick: Tick mark interval, REGR heatplot, x axis
REGR_y_tick: Tick mark interval, REGR heatplot, y axis

3.) ROOTPLOT OUTPUTS (See further information in the main text of paper.)

Root growth rate: Root growth rates are calculated as changes in root ‘mid’line (or ‘edgeline’ for analysis of differential growth on opposite root flanks) length per frame. For midline-based root growth rates to correctly reflect total growth rate, tracked points must encompass the entire root elongation zone (Figure 3a,b).
	
	Prefix-midlines.csv: Length of root midline in successive frames (Figure 4b). Each column corresponds to the midline in a particular frame (time point); each row lists the cumulative length of the root midline (in pixels of the original image) with increasing distance from the reference point P0; the midline length is calculated as the sum of distances between neighboring tracked points Pi by applying the Pythagorean equation to their XY coordinates (Figure 4a). The last cell in each column thus reflects the entire length Ln of the measured midline in a frame.

	Prefix-midline growth rate.csv: Root growth rates (Figure 4c) calculated as differences in total midline length between frames.
	
	Prefix-midline growth rate.png: Graphs of root growth rates.

Root angle: Root angles are calculated as angles of a straight line connecting two user-defined points P1 and P2 (specified in ‘user-defined-parameters.csv’). These points are selected from the list of tracked points making up the root midline (Fig. 3c). 

	Prefix-angles.csv: Angles and changes in angle (bending rate) of line connecting two user-defined points along the root midline. Angle α for each frame was calculated using the arctangent function.
	
	 Prefix-angle.png and -dAngle-dt.png: Graphs of root angles and bending rates (i.e. change in angle over time; Figure 4d). 

Root velocity profile: The velocity value for any point Pi along the root midline reports how quickly the reference point P0 at the root tip ‘moves’ away from point Pi and thus reflects the total growth of all cells along the midline between points P0 and Pi (Figures 3b, 4b). 
	
	Prefix-velocity-raw.csv: Velocity data for each tracked point Pi (rows) in each frame (time; columns). 
	
	Prefix-velocity-raw-unadjusted.png: 3D heatmap of velocity profiles for each frame and each point along the root length. X-axis represents time (in frames), Y-axis represents the position Pi along the root axis, and autoscaled color represents velocity (pixels frame-1).
	
	Prefix-2D-velocity-smoothing.png: Graph of raw velocity profile and regression curve along entire root at user-defined frame (time point) t (specified in ‘user-defined-parameters.csv’).
	
	Prefix-velocity-smoothed-and-midlineshiftcorrected.csv: Smoothed velocity data; local regression was performed using user-defined Locally-Weighted Scatterplot Smoothing (LOWESS) (specified in ‘user-defined-parameters.csv’). The position of each point along the root axis was corrected by accounting for root growth over time (see Note 8). 
	
	Prefix-velocity-auto-scale.png: 3D heatmap of smoothed velocity profiles for each frame and each (corrected) position Pi along the root length. Autoscaled color represents velocity (pixels frame-1).
	
	Prefix-velocity-manual-scale.png: 3D heatmap of smoothed velocity profiles for each frame and each (corrected) position Pi along the root length. Color represents velocity (pixels frame-1) per user-defined scale (minimum, maximum values in LUT; specified in ‘user-defined-parameters.csv’).

Root REGR (=strain) profile: REGR values along the root are calculated as the derivatives of the smoothed velocity curve. Values reflect local relative expansion as fraction. 
	
	Prefix-REGR-raw.csv: Relative elemental growth rate for each position Pi (rows) at each frame (time; columns). 
	
	Prefix-REGR-raw.png: 3D heatmap of raw (unsmoothed) REGR profiles for each frame and each position along the root length. Auto-scaled color represents REGR (fractions frame-1).
	
	Prefix-REGR-smoothed.csv: Smoothed REGR data; local regression was performed using user-defined Locally-Weighted Scatterplot Smoothing (LOWESS) (specified in ‘user-defined-parameters.csv’).
	
	Prefix-REGR-auto-scale.png: 3D heatmap of smoothed REGR profiles for each frame and each position along the root length. Auto-scaled color represents REGR.
	
	Prefix-REGR-manual-scale.png: 3D heatmap of smoothed REGR profiles for each frame and each position along the root length. Color represents REGR per user-defined scale (minimum, maximum values for LUT; (specified in ‘user-defined-parameters.csv’).
