# TFG-Cubesat-POD-with-GNSS

## GNSS-Based Navigation Method for Precise Orbit Determination in CubeSats

### Overview
This repository contains the code and resources developed as part of the final degree project work titled "GNSS-Based Navigation Method for Precise Orbit Determination in CubeSats". The project aims to investigate the feasibility of using GNSS methods for POD by analyzing the effect of perturbations in LEO region, asses the visbility of GPS satellites for different orbits and determine the precision of this methods.

### Project Structure
The main folders in this repository are organized as follows:
- Cubesat Model: Contains Simulink models for cubesat orbit propagation, both with and without perturbations.
- Data: Stores datasets, simulation outputs, and experimental data used in the project.
- Model Configuration: Includes configuration files for setting up the simulation environment and parameters.
- Model Visualization: Contains scripts for visualizing simulation results.
- Post-processing: Includes scripts and functions for analyzing simulation data and generating reports on GPS visibility.
- Results: Stores generated results, plots, and reports from project experiments.

### Getting Started
To get started with using the resources in this repository, follow these steps:
1. Clone this repository to your local machine.
2. Download the data folder from this [link](https://www.dropbox.com/scl/fo/3ypcls3egmj5x04p1lepk/AFZdddypuZBz0udkaQiAP8A?rlkey=8oo185ss8x7thx82co5pj3gd0&st=yzbf81yr&dl=0)
3. Create a folder name Results
4. Navigate to the desired folder based on your interest (e.g., Cubesat Model, Post-processing).
   - If you want to propagate an orbit, open Model Configuration folder and run one of the configuration scripts (With or without perturbation)
   - If you want to post-process Spirent and GNSS-SDR data, use PostprocessMain.m within Post-processing folder.
   - If you want to compute the precision error between spirent and GNSS-SDR use POD.m
