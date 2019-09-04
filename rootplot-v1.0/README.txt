RootPlot - ver XXXXXX
Author: Cody DePew (cld5311@psu.edu, depewcod@gmail.com)
Penn State U
DATE

CITATION: Authors. Year. Title. Etc...

~~~~~~~~ INTRODUCTION ~~~~~~~~

RootPlot is an R script designed for robust and assumption-free data analysis and visualization of high spatiotemporal resolution kinematic root growth data. RootPlot takes raw data obtained from other image analysis programs and creates heatplots to visualize root growth profiles over time. These raw data consist of X-Y coordinate values along the midline of a growing root at multiple time points. These data are collected according to the methods outlined in Shih et al., 2014. The Receptor-like Kinase FERONIA Is Required for Mechanical Signal Transduction in Arabidopsis Seedlings. Current Biol. 24:1887-92.

RootPlot utilizes Locally-Weighted Scatterplot Smoothing (LOWESS) to perform local regression and produce clear representations of root growth without the need to fit artificial logarithmic curves to the data.

RootPlot is not a program. It is a script written for R (http://www.r-project.org/) intended for use with the R studio IDE (http://www.rstudio.com/).

~~~~~~~~ HOW TO USE ROOTPLOT ~~~~~~~~

RootPlot is easy to use, even if you have little to no experience with R or R studio.

1.) Download and install the latest versions of R and R studio from the links above.

2.) In the RootPlot home folder, open the file "ROOTPLOT.Rproj" in R studio to access the RootPlot environment.

3.) In the upper left quadrant of R studio, ensure that both "script-v-XXX.R" (XXX depending on your current version of RootPlot) and "script-install-packages.R" are both open.

4.) With an active internet connection, run the full script "script-install-packages.R" NOTE: THIS STEP MUST ONLY BE PERFORMED THE FIRST TIME YOU USE ROOTPLOT IF YOU DO NOT ALREADY HAVE THE REQUIRED R PACKAGES INSTALLED.

To run an R script in R studio:
   a.) open the script in the upper left quadrant of R studio
   b.) place cursor in the script and select the entire body of the
       script by pressing CTRL(or Command)+A
   c.) click "run" 

5.) Supply raw data and parameters to RootPlot according to the "requirements for input" section below.

6.) open and run "script-vXXX" (XXX depending on RootPlot version)

7.) multiple graphs appear in the lower right quadrant of R studio. using the arrow buttons to scroll and the export button to save, select and save the desired graphs using the R studio GUI.

8.) multiple ".csv" files with the prefix "output-" will populate the RootPlot home folder. move and save these files before running RootPlot a second time or then will be overwritten and lost.

9.) ensure that all output files and charts are saved and labeled appropriately before running RootPlot again. output CSV files will be overwritten when the RootPlot script is run again.


~~~~~~~~ REQUIREMENTS FOR INPUT ~~~~~~~~

1.) RAW DATA - X-Y COORDINATES
	XY coord. obtained from phytomorph according to Shih et al., 2014
	RootPlot utilizes XY data from any source in the following format:

|1st timepoint| 2nd timepoint| 3rd timepoint| etc...
------------------------------------------------------
|  X1  |  Y1  |   X1  |  Y1  |   X1  |  Y1  | ...
|  X2  |  Y2  |   X2  |  Y2  |   X2  |  Y2  | ...
|  X3  |  Y3  |   X3  |  Y3  |   X3  |  Y3  | ...
|  X4  |  Y4  |   X4  |  Y4  |   X4  |  Y4  | ...
|  X5  |  Y5  |   X5  |  Y5  |   X5  |  Y5  | ...
| ...  | ...  |  ...  | ...  |  ...  | ...  | ...
For each timepoint, X1 and Y1 are coordinates for the first point along the midline (e.g. the quiescent center/root tip) each additional X-Y pair descending each timepoint column represents the coordinates of a second point above the quiescent center, the point above that, etc.

2.) USER-DEFINED PARAMETERS
	access plotting parameters by opening the file "user-defined-parameters.csv" located in the RootPlot home folder. After making any necessary changes to the parameters (described in the user-defined-parameters.csv file itself), ensure that the file is saved before running RootPlot. RootPlot accesses the parameters directly from this file. NOTE: ENSURE THAT YOU ARE SAVING THE FILE AS ".CSV" MICROSOFT EXCEL MAY PROMPT YOU TO SAVE WITH ANOTHER FILE EXTENSION.

~~~~~~~~ Appendix A: ~~~~ VERSION HISTORY ~~~~~~~~

ver0.1.1alpha - early 2019
	initial reorganization of rough code from 2016

ver0.1.2alpha - May 2019
        first version of RootPlot capable of producing REGR without crashing

ver0.1.3beta - May 2019
        functional draft of rootplot software.

ver0.2beta - May 29, 2019
        ver1.0 updated to include perpendicular smoothing of velocity data.
        this allows a cleaner, final REGR plot to be produced with decreased
        noise due to artifacts/noise.

ver0.2beta - May 31, 2019
	updated to correct problem with shifting scales as midline increases
	in length over time

ver0.3 - June 9, 2019
	major improvements to outputs and file handling
	graphs saved as .pdf files automatically	
	all graphs and .csv files named with user-defined prefix
	all graphs and .csv files saved in easy-to-find output folder

ver0.4.1 - June 13, 2019
	fixed time reversal of velocity and REGR plots
	NOTE: some output csv. files may still be reversed
	changed output of graphs from PDF files to
		PNG with user-defined resolution

ver0.4.2 - June 13, 2019
	fix discrepancies between rootplot midline growth rate
		calculation and those done manually in Excel
	fix errors so that actual midline distance is calculated and
		not simply the linear distance between a point and the QC

ver0.5 - June 17, 2019
	calculation of root tip angle
	including user-defined parameters file entry

ver0.6 - June 28, 2019
	minor fixes
	flipping reversed graphs
	user-defined options for tick mark scales

(UNDER CONSTRUCTION) ver1.6.1 - DATE
	updates to readme file

FEATURES COMING SOON:


