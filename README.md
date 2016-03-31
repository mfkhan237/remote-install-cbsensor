Introduction

This is a Powershell script specifically made to install the Carbon Black Sensor on remote machines
silently, in a bulk fasion. This script can be used if there are issues with pushing the sensor
installation through GPO and/or SCCM. This script, along with the PSEXEC utility made by
Mark Russinovich and can be found at:
https://technet.microsoft.com/en-us/sysinternals/bb896649 

Thanks to Mark Russinovich for making the Sysinternals suite and PSEXEC.EXE which makes this script
and the ability to silently install the sensor without much trouble, possible.

Minimum Requirements

-> Must be in a Windows Environment, machines must have at the minimum Windows 7 and PowerShell 2.0
(Most machines with Windows 7 are at default PowerShell Version 2.0)

-> Must have Workstation Adminstrator priveledges to run this script

-> Basics of launching a script or program using PowerShell or command line.

-> Your Enterprise must be using CarbonBlackSensor, or wishes to use it (and maybe in POC mode),
and the necessary installer folder will be provided by your vendor (CarbonBlack).

Setup Instructions

1) Create a C:\Temp directory if it already doesn't exist

2) Place the following files and folders into your C:\Temp directory:

	A) PSEXEC.EXE utility, can be downloaded from here and place in your C:\Temp folder for this
	script: https://technet.microsoft.com/en-us/sysinternals/bb896649

	After Downloading, you can place PSEXEC.exe in your C:\Temp folder, along with other files.
	
	B) hostnames.txt file, place in your C:\Temp folder, and add the hostnames (or IP addresses,
	since PSEXEC works with IPs as well) of the remote machines that you would wish to install the
	sensor on.
	
	C) CarbonBlackSensor Installer folder. Ask your vendor to provide you with this (assuming you
	are using Carbon Black sensor.). This folder MUST have at the very minimum, Settings.INI file
	and the CarbonBlack Executable.
	
	D) BulkInstall-CarbonBlackSensor.ps1 (This script itself). From the C:\Temp directory, you can
	launch this script by opening PowerShell.exe in elevated priveledges (Workstation Admin).

Running the Script

1) Go to your C:\Temp folder and find the hostnames.txt file. If it doesn't exist, simply create one
by right-clicking in the folder and New > Text Document.

2) Save the document as "hostnames.txt".

3) On each new line of the hostnames.txt document, input the names of the hosts that you want to 
install the CB sensor on. Its best to do this first on machines within your own team so you can test
and verify that the script and the install worked for you before pushing the installer on user's
machines. You can also input IP addresses of remote hosts if hostnames are not availaible. Just make
sure that you input 1 hostname or IP per line and leave no trailing spaces or empty lines at the end.

4) Save and Close the hostnames.txt file.

5) Open Powershell.exe in elevated priveledges (Workstation Admin). Right-Click Powershell.exe (this
can be on your taskbar or you can search for it in your start menu), "Run As Different User" and
enter your Workstation Admin credentials.

6) Once the PowerShell console window is opened with elevated priveledge, navigate to:
	C:\Temp  (Type cd C:\Temp and press Enter)
	
7) Type "DIR" and press Enter to see the list of files in your C:\Temp directory.

8) Launch the script by typing .\BulkInstall-CarbonBlackSensor.ps1 and then Pressing Enter. You can
try hitting the TAB key before you finish typing the file name and PowerShell will do a
"TAB-Completion" for you.

9) Watch the script run on your machine's Powershell console.

Troubleshooting/Logging

A log is created after the script has completed its run. This logfile will be placed in the same
directory as the script is located. Simply check the log file for any issues and errors. You may get
machines that were not pingable or online at the moment the script was launched, so the script will
skip those files and keep track of them and list them at the very end of the script launch.

Feedback

Even though I have been scripting for a while, this is the FIRST script that I am putting out into
the world through Github and I would love to get some feedback on this if you found it useful to you
or your organization.
