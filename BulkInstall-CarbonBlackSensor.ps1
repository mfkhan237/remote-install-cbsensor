function BulkInstall-CarbonBlackSensor {
<#
.Synopsis
    This script is designed to install the Carbon Black Sensor on Multiple
    clients given as input through a list of those client names (Host Names)
    in a .TXT file.

    The script will ask the user for the path of the hostnames in a .TXT
    document. 

    Then the script will ask user for the location of the Carbon Black Sensor
    Installer Package folder.

    Then the script will ping the host, and proceed with further instructions
    until the Carbon Black Sensor is installed on the remote client.
    
.DESCRIPTION
    BulkInstall-CarbonBlackSensor installs the Carbon Black Sensor on remote
    host names provided in a .txt file.

    User running this script must be an admin on remote machine
    ("Workstation Admin" if you are in an Enterprise Environment) to
    succesfully complete the install, and the remote machine must be
    online (internal network) to have successfully installed the
    Carbon Black Sensor.

    The following files are required in order for this script to work:

    1) CarbonBlackSensor Installation folder with settings.ini file and the
    CarbonBlackClientSetup.exe Executable.

    2) A .TXT file with hostnames on each new line, so no 2 hostnames on a
    single line. Also, no extra spaces after the hostnames and no empty lines
    to avoid any unnecessary errors.

    3) The script also uses PSEXEC.EXE, part of Sysinternal Tools, which
    can be downloaded here:
    https://technet.microsoft.com/en-us/sysinternals/psexec.aspx

    4) It is convenient to place all files, This powershell script, the
    hostnames.txt file, the CarbonBlackSensor installation folder and PSEXEC.EXE
    into the same directory, such as c:\Temp and then launch the script from
    there in with elevated priveledges in your own machine.

.EXAMPLE
    BulkInstall-CarbonBlackSensor -PathOfComputerList .\hostnames.txt -CarbonBlackSensorInstallerPath C:\Temp\CarbonBlackSensor

    This example command will run the script using the hostnamest.txt file and
    the CarbonBlackSensor installer folder based on the specific paths
    provided on the Command line.

    Put Quotes around your file path if your file path has spaces in it.

.EXAMPLE
    BulkInstall-CarbonBlackSensor

    If you just run this script like this, it will simply run and then
    prompt you for the necessary information.

.NOTES
    User running this script MUST be an admin on the remote host because this script
    copies files over the c:\Temp directory and then launches an executable from
    that directory.

    PowerShell execution policy on current user will need to be changed to
    Unrestricted or ByPass to run this script. The Execution policy can be reset
    back to Restricted after script is done running.

    Author: Fahad Khan
    Date Updated: 3/30/2016
    Contact me for questions/updates through my github account.
#>

[CmdletBinding()]
Param (
    [Parameter( Mandatory=$true, 
                ValueFromPipeline=$true, 
                Position=0,
                HelpMessage='Enter path of a .TXT file that contains hostnames
                             on each line, without quotes')]
    [ValidateNotNullOrEmpty()]
    $PathOfComputerList='.\hostnames.txt',

    [Parameter( Mandatory=$true,
                Position=1,
                HelpMessage='Enter path of the Carbon Black Sensor Installer
                             Folder, without quotes')]
    [ValidateNotNullOrEmpty()]
    $CarbonBlackSensorInstallerPath='C:\Temp\CarbonBlackSensor'
) # end param

Begin {

    While( $(Test-Path $PathOfComputerList) -eq $False) {
        $PathOfComputerList = $(Read-Host -Prompt 'Enter path of a .TXT that contains hostnames on each line, without quotes')
    }

    While( $(Test-Path $CarbonBlackSensorInstallerPath) -eq $False) {
        $CarbonBlackSensorInstallerPath = $(Read-Host -Prompt 'Enter path of the Carbon Black Sensor Installer, without quotes')
    }

      # hosts not online
    $notOnline = @()

      # hosts online
    $Online = @()

      # holds client names that had a successful installation
    $successFullyInstalled = @()

      # holds client names that already have the service running
    $alreadyRunningCarbonBlack = @()

      # This is the particular service we want to look for on the machine
    $ServiceName = 'CarbonBlack'

      # Extract the computer list from the hostnames path and then
      #  assign it to $ComputerList variable
    $ComputerList = Get-Content $PathOfComputerList

} # end 'Begin Block

Process{

foreach ($Client in $ComputerList) {

     Write-Output "Pinging $Client" # if the client is not online, script will skip this client and go on to the next client.

           if (Test-Connection -Computername $Client -BufferSize 16 -Count 1 -Quiet) {

                Write-Output "$Client is online, Proceed to next step"

                $Online += $Client

                $RunningServiceCheck = Get-Service -ComputerName $Client -Name $ServiceName -ErrorAction SilentlyContinue

                if ($($RunningServiceCheck.Status) -ne "Running") {

                     Write-Output "'$ServiceName' service is Not Running on $Client, proceeding to Installation"
                     Write-Output "Copying $CarbonBlackSensorInstallerPath folder..."
                     Write-Output "...To $Client's c:\Temp directory"

                     if ( $(Test-Path "\\$Client\c$\Temp\CarbonBlackSensor") -eq $false ) {

                             # Copy the CarbonBlackSensor Installer folder and all its contents to the Client's C:Temp folder
                             #  If it doesn't already exist
                           Copy-Item -Path $CarbonBlackSensorInstallerPath -Destination \\$Client\c$\temp -recurse -ErrorAction SilentlyContinue
                     }

                     if ($(Test-Path -path "\\$Client\c$\Temp\CarbonBlackClientSetup.exe") -eq $true ) {

                             # Running the installer if the CB installer folder is already located on the C:\Temp
                             #  maybe unnecessary here, but useful for any reason the install fails the first time
                           & psexec.exe -accepteula "\\$Client" "C:\temp\CarbonBlackClientSetup.exe" /S
                           $PSExecLastExitCode = $LASTEXITCODE
                           Write-Output "Last Exit Code of PSEXEC on Client $Client, $PSExecLastExitCode"

                           if ( $PSExecLastExitCode -eq 0 ) {
                                Write-Output "After Installation, Service $((Get-Service -ComputerName "$Client" -Name "$ServiceName" -ErrorAction SilentlyContinue).Name) is now running on $Client"
                                $successFullyInstalled += $Client
                           } # end internal if

                     } elseif( $(Test-Path -path "\\$Client\c$\Temp\CarbonBlackSensor\CarbonBlackClientSetup.exe") -eq $true ) {
                           
                             # run the PSEXEC.EXE executable and then the command to run the CarbonBlack Sensor using
                             #  the silent install switch for CB Sensor
                           & psexec.exe -accepteula "\\$Client" "C:\Temp\CarbonBlackSensor\CarbonBlackClientSetup.exe" /S
                           
                           $PSExecLastExitCode = $LASTEXITCODE
                           
                           Write-Output "Last Exit Code of PSEXEC on Client $Client, $PSExecLastExitCode"

                           if ( $PSExecLastExitCode -eq 0 ) {
                                
                                Write-Output "After Installation, Service $((Get-Service -ComputerName "$Client" -Name "$ServiceName" -ErrorAction SilentlyContinue).Name) is now running on $Client"
                                $successFullyInstalled += $Client

                           } # end internal if

                     } # end if/elseif

                  # Check to see if the Service "Carbon Black Sensor" is running on the client system or not
                } elseif ( $(Get-Service -ComputerName "$Client" -Name "$ServiceName" -ErrorAction SilentlyContinue).Status -eq "Running" ) {
                     
                     Write-Output "$ServiceName service is already running, skipping Client: $Client"
                     $alreadyRunningCarbonBlack += $Client
                     Continue

           } # end if/elseif

     } else {

           Write-Output "$Client is NOT Online, skipping to next client in list"
           $notOnline += $Client
           Continue

} # end if Test-Connection to see if Client is online or not
} # end foreach

    Write-Output "------------------------------------------------------------------------"
    Write-Output "Reached End of Client names (hostnames) List"
    Write-Output "------------------------------------------------------------------------"
    Write-Output "Clients that were Online"
    Write-Output "------------------------------------------------------------------------"
    $Online
    Write-Output "------------------------------------------------------------------------"
    Write-Output "Clients that were not online"
    Write-Output "------------------------------------------------------------------------"
    $notOnline
    Write-Output "------------------------------------------------------------------------"
    Write-Output "Clients that had a successful installation Run of Carbon Black Sensor"
    Write-Output "------------------------------------------------------------------------"
    $successFullyInstalled
    Write-Output "------------------------------------------------------------------------"
    Write-Output "Clients that already have Carbon Black Service Running"
    Write-Output "------------------------------------------------------------------------"
    $alreadyRunningCarbonBlack
    
} # end Process Block
} # end function

BulkInstall-CarbonBlackSensor | tee-object -filepath ".\BulkInstall_Log-$(Get-Date -format "yyyy-MMM-d--HH-MM").txt" 
