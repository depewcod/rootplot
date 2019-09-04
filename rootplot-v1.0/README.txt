RootPlot - ver 1.0
Author: Cody DePew (cld5311@psu.edu, depewcod@gmail.com)
Penn State University
DATE

CITATION: Authors. Year. Title. Etc...


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

DETAILED LIST OF USER-DEFINED PARAMETERS WILL GO HERE (FROM PAPER)

3.) ROOTPLOT OUTPUTS 

LIST OF OUTPUTS WILL GO HERE (FROM PAPER)