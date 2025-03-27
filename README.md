This repo contains a supplementary project for benchmarking [RandLAPACK](https://github.com/BallisticLA/RandLAPACK)'s driver-level "Block QR with Randomization and Pivoting" (BQRRP) algorithm.
The intent of this repo is to help users reproduce the results that were acquired as part of writing the BQRRP manuscript.
The intended user interaction with the files in this repo is to consist of the following steps:

1. Executing ["run_randlapack_benchmarks.sh"](https://github.com/TeachRaccooon/BQRRP/blob/main/run_randlapack_benchmarks.sh) shell script - as its name suggests, tjis script is responsible for conducting all BQRRP benchmarks and placing the results in appropriate folders.
This script relies on the environment variables that are set upon the execution of ["install.sh"](https://github.com/BallisticLA/RandLAPACK/blob/main/install.sh) script and WILL NOT WORK PROPERLY WITHOUT THOSE VARIABLES BEING SET APPROPRIATELY.
The script will create the new folder structure for the results (if such structure is not present) in "RandNLA-project/build/benchmark-build/benchmark-output/" (RandNLA-project directory will be defined after running "install.sh").
The shell script will, upon user's permission, attempt to first conduct the GPU benchmarking procedure (if RandLAPACK was installed with GPU configuration) and then do the same for CPU.
Note that all the parameters passed into the benchmarking routines are hardcoded to the values used when conducting experiments for the BQRRP manuscript.
The total time for the execution of all CPU benchmarks as part of this script is expected to take several hundreds of hours (at leas on Intel Sapphire Rapids and AMD Zen4c platforms), please be mindful of that when launching the CPU benchmarks.

2. After ["run_randlapack_benchmarks.sh"](https://github.com/TeachRaccooon/BQRRP/blob/main/run_all_plotting_scripts.m) is complete, the user may utilize "run_all_plotting_scripts.m" MATLAB program in order to plot the obtained results.
The detailed configuration of "run_all_plotting_scripts.m" will plot the results that are contained in this repo (gathered in the process of writing the BQRRP manuscript).
In order for the newly-acquired results to be used by this program, the user must update the file path variables, as well as the benchmarking date variable at the top of the file to the appropriate parameters.
Note that the parameters specific for each plotting functions are hardcoded such that they match those used in the benchmark runs that were conducted as part of writing the BQRRP manuscript.

If you have any questions, comments and concerns, feel free to contact me via mmelnic1@vols.utk.edu.
