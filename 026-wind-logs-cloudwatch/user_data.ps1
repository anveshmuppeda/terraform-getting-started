<powershell>
# PowerShell script to configure CloudWatch on Windows EC2 instance

# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

# Create log file for script execution
$LogFile = "C:\Windows\Temp\cloudwatch_setup.log"
Start-Transcript -Path $LogFile -Append

Write-Output "Starting CloudWatch configuration..."

try {
    # Create the CloudWatch configuration directory if it doesn't exist
    $ConfigDir = "C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch"
    if (!(Test-Path -Path $ConfigDir)) {
        New-Item -ItemType Directory -Path $ConfigDir -Force
        Write-Output "Created directory: $ConfigDir"
    }

    # Create the CloudWatch configuration file
    $ConfigFile = "$ConfigDir\AWS.EC2.Windows.CloudWatch.json"
    $CloudWatchConfig = @'
${cloudwatch_config}
'@

    # Write the configuration to file
    $CloudWatchConfig | Out-File -FilePath $ConfigFile -Encoding UTF8 -Force
    Write-Output "CloudWatch configuration file created: $ConfigFile"

    # Create custom logs directory
    $CustomLogsDir = "C:\CustomLogs"
    if (!(Test-Path -Path $CustomLogsDir)) {
        New-Item -ItemType Directory -Path $CustomLogsDir -Force
        Write-Output "Created custom logs directory: $CustomLogsDir"
    }

    # Install IIS (optional - for IIS log monitoring)
    Write-Output "Installing IIS features..."
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-HttpErrors, IIS-HttpLogging, IIS-RequestFiltering, IIS-StaticContent, IIS-DefaultDocument, IIS-DirectoryBrowsing -All

    # Enable IIS logging
    Import-Module WebAdministration
    Set-WebConfigurationProperty -Filter "system.webServer/httpLogging" -Name "dontLog" -Value $false -PSPath "IIS:\"
    Write-Output "IIS logging enabled"

    # Wait for SSM Agent to be ready
    Write-Output "Waiting for SSM Agent to be ready..."
    do {
        Start-Sleep -Seconds 10
        $ssmService = Get-Service -Name "AmazonSSMAgent" -ErrorAction SilentlyContinue
    } while ($ssmService.Status -ne "Running")

    # Restart SSM Agent to pick up the new configuration
    Write-Output "Restarting SSM Agent..."
    Restart-Service -Name "AmazonSSMAgent" -Force
    Write-Output "SSM Agent restarted successfully"

    # Wait for service to start
    Start-Sleep -Seconds 30

    # Verify SSM Agent is running
    $ssmStatus = Get-Service -Name "AmazonSSMAgent"
    Write-Output "SSM Agent Status: $($ssmStatus.Status)"

    # Create a sample log entry for testing
    $SampleLogFile = "$CustomLogsDir\sample.log"
    $TimeStamp = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
    "$TimeStamp - CloudWatch configuration completed successfully" | Out-File -FilePath $SampleLogFile -Append
    Write-Output "Sample log entry created in $SampleLogFile"

    # Enable Windows Event Logs that we're monitoring
    Write-Output "Enabling Windows Event Logs..."
    
    # Enable Security Event Log auditing (basic)
    auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
    auditpol /set /category:"Account Logon" /success:enable /failure:enable
    
    # Enable WinINet ETW logging
    try {
        wevtutil sl "Microsoft-Windows-WinINet/Analytic" /e:true
        Write-Output "Enabled Microsoft-Windows-WinINet/Analytic logging"
    } catch {
        Write-Output "Could not enable Microsoft-Windows-WinINet/Analytic logging: $($_.Exception.Message)"
    }

    Write-Output "CloudWatch configuration completed successfully!"

} catch {
    Write-Error "Error during CloudWatch configuration: $($_.Exception.Message)"
    Write-Error $_.ScriptStackTrace
}

Stop-Transcript

# Signal that user data script has completed
$completionFile = "C:\Windows\Temp\userdata_complete.txt"
"UserData script completed at $(Get-Date)" | Out-File -FilePath $completionFile

</powershell>