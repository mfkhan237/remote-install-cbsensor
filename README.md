#Introduction

This is a PowerShell script specifically made to install the Carbon Black Sensor on remote machines silently, in a bulk fashion. This script can be used if there are issues with pushing the sensor installation through GPO and/or SCCM. This script, along with the PSEXEC utility made by Mark Russinovich and can be found at:
https://technet.microsoft.com/en-us/sysinternals/bb896649

Thanks to Mark Russinovich for making the Sysinternals suite and PSEXEC.EXE which makes this script and the ability to silently install the sensor without much trouble, possible.

#Minimum Requirements

- Windows Environment, (minimum Windows 7 and PowerShell 2.0 or higher )
- Workstation Administrator privileges to run this script
- Basics of launching a script or program using PowerShell or command line
- Your enterprise must be using CarbonBlackSensor, or wishes to use it (and possibly in Proof Of
Concept mode), and the necessary installer folder will be provided by your vendor (Carbon Black).

#Setup Instructions

1) Create a C:\Temp directory if it  doesn't already exist

2) Place the following files and folders into your C:\Temp directory:

- PSEXEC.EXE utility, can be downloaded from here and place in your C:\Temp folder for this Script: https://technet.microsoft.com/en-us/sysinternals/bb896649
- After Downloading, place PSEXEC.exe in your C:\Temp folder.
- Create a new .txt file and name it "hostnames.txt". Then place in your C:\Temp folder, and add the hostnames (or IP addresses) of the remote machines on each new line.
- Verify that there is 1 hostname or IP address per line and leave no trailing spaces or empty lines at the end.
- CarbonBlackSensor Installer folder. **(Ask your vendor to provide you with the installer folder)** (See **NOTE**) This folder MUST have at the very minimum, Settings.INI file and the Carbon Black Executable.
- BulkInstall-CarbonBlackSensor.ps1 (This script).

**Note**: Carbon Black Sensor folder is proprietary. See Requirements above.

#Running the Script

1) Go to your C:\Temp folder and find the hostnames.txt file. If it doesn't exist, create one by right-clicking in the folder and New > Text Document.

2) Save the document as "hostnames.txt" (file type should be .txt)

3) On each new line of the hostnames.txt document, input the names of the hosts that you want to install the CB sensor on. It’s best to do this first as a pilot within your own team so you can test and verify that the script and the install worked correctly before deploying the installer on an enterprise level.

4) Save and Close the hostnames.txt file.

5) Open PowerShell.exe in elevated privileges (Workstation Admin). Hold down Shift and Right-Click PowerShell.exe, "Run As Different User" and enter your Workstation Admin credentials.

6) Once the PowerShell console window is opened with elevated privilege, navigate to:

- C:\Temp (Type cd C:\Temp and press Enter)
	
7) Type "DIR" and press Enter to see the list of files in your C:\Temp directory.

8) Launch the script by typing .\BulkInstall-CarbonBlackSensor.ps1 and then Pressing Enter.

9) Watch the script run on your machine's PowerShell console.

#Troubleshooting/Logging

A log is created after the script completed running. The log file will be placed in the same directory as the script. Check the log file for any issues and errors. You may get machines which could not be pinged or online at the moment the script was executing. The script will skip those hosts and display them at the end of the script run. It will also save the results in the log. Each execution will create a new log file.

#Feedback

If you have any recommendations or comments on how to improve this script, please feel free to comment or contact me. Thanks.
