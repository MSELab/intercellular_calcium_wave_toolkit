# Overview
This the code in this repository is meant to make spatial analysis of calcium wave dynamics in the developing wing disc easier. Users should always validate that the analysis is doing what they think it should be doing. I have uploaded a demo of the toolkit's functionality. I have also executed the demo and uploaded a pdf to serve as a test for much of the toolbox's functionality.

# Requirements
- MATLAB 2017b or newer is required
- The following toolboxes are required to use this toolbox
  - Image processing toolbox
  - Signal processing toolbox
  - Statistics and machine learning toolbox
- The following toolboxes are required for certain functionality
  - Parallel computing toolbox
  - Wavelet toolbox
  - Global optimization toolbox
- You need either your own confocal time-lapse data to analyze, or to obtain the test data. The test data is not publically available as the manuscript is still undergoing peer review.

# Steps to setting up the toolbox
- Clone the repository to get the code
- Obtain the "processed" data and place it in the dataProcessing folder. I currently must supply you with this until I am authorized to host it publicly
- Run the file demo_insight_2018.mlx, clicking "yes" when asked to change the current folder

# Toolbox overview
## Scripts
The toolbox is used by the generation of scripts. The demo shows how this is done. Ideally, each figure is generated by one script and that script is saved with the figure so the figure can always be regenerated. There is also the getSettings function that allows users to change the way analysis is done, and prepareWorkspace that initializes the toolbox. The first lines in a script using this toolbox should be:
```
settings = prepareWorkspace()
```
## Modules
Toolbox functions. This is the meat of where the processing workflows are.
## Dependencies
Third-party dependencies used by this package. This does not include necessary toolboxes.
## Data 
Folder for raw data. This is optional once it has been preprocessed and stored in the dataProcessing folder
## dataProcessing
Folder for preprocessed data. Each step of the analysis is exported here to prevent repeated manual annotation and computations. Updating manual annotations and redoing computations (such as when additional features are added to the statistical analysis) requires manual removal of the relelvant files/folders at this time. This software will run without this folder and generate it from scratch if the relevant Data is in the Data folder.
## Inputs
This is the required metadata. Each experiment must be documented here. There is currently no automated way to sense new data in the data folder. We keep track of experiments in labelTabel.xlsx, the laser power used in laserpower.csv, data that is unusable is added to labelReject.xlsx, and flipAPDV.xlsx keeps track of the orientation of samples. Lines must currently be added to flipAPDV in order to process new data.

# Contact
- Please cite our manuscript if you found the code useful. The most current public manuscript is a bioRxiv preprint located here: https://doi.org/10.1101/104745
- The corresponding author is Jeremiah J. Zartman, whose contact information is in the preprint
- Feel free to contact me regarding the toolkit at pavelbrodskiy@gmail.com