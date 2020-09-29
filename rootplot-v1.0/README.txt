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

XY coord. obtained via Image Processing Toolkit v10 according to Shih et al., 2014 and Bhat et al, 2020.

RootPlot utilizes XY data from any source in the following format:

      |    P0     |    P0     |   P1    |   P1    | ... |   Pn    |   Pn    |
      |  X coord  |  Y coord  | X coord | Y coord | ... | X coord | Y coord |
-----------------------------------------------------------------------------
  t1  |   X0,1    |    Y0,1   |   X1,1  |   Y1,1  | ... |   Xn,1  |   Yn,1  |
  t2  |   X0,2    |    Y0,2   |   X1,2  |   Y1,2  | ... |   Xn,2  |   Yn,2  |
  t3  |   X0,3    |    Y0,3   |   X1,3  |   Y1,3  | ... |   Xn,3  |   Yn,3  |
  t4  |   X0,4    |    Y0,4   |   X1,4  |   Y1,4  | ... |   Xn,4  |   Yn,4  |
  ... |   ...     |    ...    |   ...   |   ...   | ... |   ...   |   ...   |
  tn  |   X0,n    |    Y0,n   |   X1,n  |   Y1,n  | ... |   Xn,n  |   Yn,n  |
-----------------------------------------------------------------------------

Note: Table should include numerical X-Y coordinates only. Labels are included here for demonstration only.

For  each timepoint t, X0 and Y0 are coordinates of the first (or reference) point P0 along the midline (e.g. the quiescent center/root tip) and each additional P (X-Y) pair represents the coordinates of points along the mid/edgeline progressively more distant from the reference point/

2) USER-DEFINED PARAMETERS

RootPlot_v1 obtains settings for data analysis from the file “user-defined-parameters.csv” in the RootPlot home folder. For ease of use, this file can be opened and edited in spreadsheet software such as Microsoft Excel, but must retain the “.csv” file extension. These parameters are: 

(i) data_in (X-Y coordinate input): Name of file containing raw X-Y coordinate data obtained using Image Processing Toolkit v10 (or other software). This file must be in the RootPlot “input” folder and must be a “.csv” file. However, do not include the “.csv” extension in this field. This file name should not include spaces. 

(ii) out_prefix (Output prefix): User-defined prefix for all RootPlot output files, which are located in the “output” folder after running the RootPlot script. Prefix should not include spaces. 

(iii) ref_midline_interval (Interval between tracked points): Distance (in pixels) between tracked midline points at t=1. This distance corresponds to the distance between tracked points along the root length used to generate X-Y coordinates with Image Processing Toolkit v10 and is necessary to correctly calculate REGR values. 

(iv) i_width (Output image width): Width (in pixels) of all “.png” output files. 

(v) i_height (Output image height): Height (in pixels) of all “.png” output files.  

(vi) twoD_x_tick_int (X-axis tick mark interval): Interval of X-axis (time, as frames) tick marks for midline-growth-rate.png, angle.png and dAngle-dt.png 2D plots. 

(vii) growth_y_tick_int (Growth rate tick mark interval): Interval of Y-axis tick marks in midline-growth-rate.png 2D plot. 

(viii) angle_y_tick_int (Root angle tick mark interval): Interval of Y-axis tick marks in angle.png 2D plot. 

(ix) angle_1 (First angle point): First midline point used in angle calculation. By default, this point should be set to “1,” representing the root tip/quiescent center coordinate obtained from Image Processing Toolkit v10. 

(x) angle_2 (Second angle point): Second midline point used in angle calculation. For example, a value of “20” will calculate the angle of a line between the root tip (when angle_1 = 1) and the twentieth tracked point along the midline. If ref_midline_interval = 10, i.e. tracking points were positioned every 10 pixels along midline, this line segment will be approx. 190 pixels in length [ref_midline_interval * (angle_2 - angle_1)]. 

(xi) twoD_velo_plot_frame (Timepoint for velocity smoothing example): Frame number of a single velocity profile. RootPlot displays both a 2D raw velocity profile for this frame, and a second identical velocity profile with LOWESS smoothing overlaid in red. This output can be used to preview the effect of different LOWESS smoothing values on spatial smoothing. 

(xii) f_smooth_space (Spatial LOWESS delta value): Delta value (determines the amount of smoothing) for spatial smoothing of velocity profile by the LOWESS function. This value represents the fraction of total points that will be considered during regression, and therefore must be between 0 and 1. Thus, a smaller value will result in less smoothing. LOWESS is an iterative function. RootPlot_v1 performs three iterations of the LOWESS function using this delta value each time data is spatially smoothed. 

(xiii) f_smooth_time (Temporal LOWESS delta value): Delta value for temporal smoothing of the velocity profile by the LOWESS function. 

(xiv) f_smooth_space_REGR: Delta value for spatial smoothing of REGR profile by the LOWESS function. 

(xv) f_smooth_time_REGR: Delta value for temporal smoothing of the REGR profile by the LOWESS function. 

(xvi) velo_min_color (Velocity heatmap minimum color scale): Minimum velocity value represented as the color blue in velocity heatmap spectrum. Any velocity below this value will also be reported as blue in velocity-manual-scale.png heatmap. Manual scaling ensures that results from different experiments can be presented in standardized heatmaps. 

(xvii) velo_max_color (Velocity heatmap maximum color scale): Maximum velocity value represented as the color red in velocity heatmap spectrum. Any velocity above this value will also be reported as red in velocity-manual-scale.png heatmap. 

(xviii) velo_x_tick (Velocity heatmap time tick marks): Interval of X-axis (time, as frames) tick marks in velocity-manual-scale.png heatmap. 

(xix) velo_y_tick (Velocity heatmap spatial tick marks): Interval of Y-axis tick marks (distance from root tip, as number of tracked points) in velocity-manual-scale.png heatmap. 

(xx) REGR_min_color (REGR heatmap minimum color scale): Minimum REGR (blue) for REGR heatmap spectrum. Any REGR below this value will also be reported as blue in REGR-manual-scale.png heatmap. 

(xxi) REGR_max_color (REGR maximum color scale): Maximum REGR (red) for REGR heatmap spectrum. Any REGR above this value will also be reported as red in REGR-manual-scale.png heatmap. 

(xxii) REGR_x_tick (REGR heatmap time tick marks): Interval of X-axis (time, as frames) tick marks in REGR-manual-scale.png heatmap. 

(xxiii) REGR_y_tick (REGR heatmap spatial tick marks): Interval of Y-axis tick marks (distance from root tip, as number of tracked points) in REGR-manual-scale.png heatmap. 



3.) ROOTPLOT OUTPUTS (See further information in the main text of paper.)

Root growth rate: Root growth rates are calculated as changes in root ‘mid’line (or ‘edgeline’ for analysis of differential growth on opposite root flanks) length per frame. For midline-based root growth rates to correctly reflect total growth rate, tracked points must encompass the entire root elongation zone.
	
	Prefix-midlines.csv: Length of root midline in successive frames. Each column corresponds to the midline in a particular frame (time point); each row lists the cumulative length of the root midline (in pixels of the original image) with increasing distance from the reference point P0; the midline length is calculated as the sum of distances between neighboring tracked points Pi by applying the Pythagorean equation to their XY coordinates. The last cell in each column thus reflects the entire length Ln of the measured midline in a frame.

	Prefix-midline growth rate.csv: Root growth rates calculated as differences in total midline length between frames.
	
	Prefix-midline growth rate.png: Graphs of root growth rates.

Root angle: Root angles are calculated as angles of a straight line connecting two user-defined points P1 and P2 (specified in ‘user-defined-parameters.csv’). These points are selected from the list of tracked points making up the root midline. 

	Prefix-angles.csv: Angles and changes in angle (bending rate) of line connecting two user-defined points along the root midline. Angle α for each frame was calculated using the arctangent function.
	
	 Prefix-angle.png and -dAngle-dt.png: Graphs of root angles and bending rates (i.e. change in angle over time). 

Root velocity profile: The velocity value for any point Pi along the root midline reports how quickly the reference point P0 at the root tip ‘moves’ away from point Pi and thus reflects the total growth of all cells along the midline between points P0 and Pi. 
	
	Prefix-velocity-raw.csv: Velocity data for each tracked point Pi (rows) in each frame (time; columns). 
	
	Prefix-velocity-raw-unadjusted.png: 3D heatmap of velocity profiles for each frame and each point along the root length. X-axis represents time (in frames), Y-axis represents the position Pi along the root axis, and autoscaled color represents velocity (pixels*frame-1).
	
	Prefix-2D-velocity-smoothing.png: Graph of raw velocity profile and regression curve along entire root at user-defined frame (time point) t (specified in ‘user-defined-parameters.csv’).
	
	Prefix-velocity-smoothed-and-midlineshiftcorrected.csv: Smoothed velocity data; local regression was performed using user-defined Locally-Weighted Scatterplot Smoothing (LOWESS) (specified in ‘user-defined-parameters.csv’). The position of each point along the root axis was corrected by accounting for root growth over time. 
	
	Prefix-velocity-auto-scale.png: 3D heatmap of smoothed velocity profiles for each frame and each (corrected) position Pi along the root length. Autoscaled color represents velocity (pixels frame-1).
	
	Prefix-velocity-manual-scale.png: 3D heatmap of smoothed velocity profiles for each frame and each (corrected) position Pi along the root length. Color represents velocity (pixels frame-1) per user-defined scale (minimum, maximum values in LUT; specified in ‘user-defined-parameters.csv’).

Root REGR (=strain) profile: REGR values along the root are calculated as the derivatives of the smoothed velocity curve. Values reflect local relative expansion as fraction. 
	
	Prefix-REGR-raw.csv: Relative elemental growth rate for each position Pi (rows) at each frame (time; columns). 
	
	Prefix-REGR-raw.png: 3D heatmap of raw (unsmoothed) REGR profiles for each frame and each position along the root length. Auto-scaled color represents REGR (fractions frame-1).
	
	Prefix-REGR-smoothed.csv: Smoothed REGR data; local regression was performed using user-defined Locally-Weighted Scatterplot Smoothing (LOWESS) (specified in ‘user-defined-parameters.csv’).
	
	Prefix-REGR-auto-scale.png: 3D heatmap of smoothed REGR profiles for each frame and each position along the root length. Auto-scaled color represents REGR.
	
	Prefix-REGR-manual-scale.png: 3D heatmap of smoothed REGR profiles for each frame and each position along the root length. Color represents REGR per user-defined scale (minimum, maximum values for LUT; (specified in ‘user-defined-parameters.csv’).
