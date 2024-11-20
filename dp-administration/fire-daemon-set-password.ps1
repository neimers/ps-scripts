
$computername=$env:COMPUTERNAME
#Gather the list of services that have "Firedaemon" in the Displayname and use "Parcserv" as the running account and write them to a file named for the running computer.
$services=get-wmiobject Win32_service|Where-Object {$_.DisplayName -like "*FDO*" -and $_.Startname -like "*ACCOUNT_NAME@DOMAIN.COM*"}
$services.name > D:\Capstone\Installs\$computername.txt

# Read the list of service names from a text file
$services = Get-Content "D:\Capstone\Installs\$computername.txt"

# Define the new username and password for the service account
$username = "NEW_ACCOUNT@DOMAIN.COM"
$password = "NEW PASSWORD"
$servicetype = 16

# Loop through each service name and change the service account credentials
foreach ($service in $services) {
    # Get the service object by name
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    write-host $service.name
    # Check if the service exists
    if ($svc) {
        # Write a message to indicate the current service
        Write-Host "Changing service account for $service"

        # Stop the service if it is running
        if ($svc.Status -eq "Running") {
            Stop-Service -Name $service -Force
        }

        # Change the service account credentials using WMI
        $wmi = Get-WmiObject -Class Win32_Service -Filter "Name='$service'"
        $result = $wmi.Change($null, $null, $servicetype, $null, $null, $null, $username, $password, $null, $null, $null)

        # Check if the change was successful
        if ($result.ReturnValue -eq 0) {
            # Write a message to indicate the success
            Write-Host "Service account changed successfully for $service"
        }
        else {
            # Write a message to indicate the failure and the error code
            Write-Host "Failed to change service account for $service. Error code: $($result.ReturnValue)"
        }

        # Start the service if it was running before
        if ($svc.Status -eq "Running") {
            Start-Service -Name $service
        }
    }
    else {
        # Write a message to indicate the service does not exist
        Write-Host "Service $service does not exist"
    }
}