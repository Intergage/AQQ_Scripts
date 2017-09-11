# Network Eval v2
# Network Eval v3 Idea: Make a [PsCustomObject] and add all info to this. Then print to file.

# Banner Function - Keeping things as neat as I can
function banner{
    param ([Parameter(Mandatory=$true)][string]$string)

    $length = $string.Length + 6
    $boarder = "#" * [int]$length

    Write-Host -Foreground "red" $boarder
    Write-Host -Foreground "red" "#" -NoNewline; Write-Host "  $($string)  " -NoNewline; Write-Host -Foreground "red" "#"
    Write-Host -Foreground "red" $boarder
}

banner "Gathering Hardware and Software Information"

# Place holders
$Spacer = "#" * 25
$info = systeminfo

# Output file
cd $PSScriptRoot
mkdir $env:COMPUTERNAME | Out-Null
$outfile = "$env:COMPUTERNAME\$env:COMPUTERNAME.txt"

# Main Function
function InfoGather{
    # System Information
    "OS Information`r`n$($Spacer)" | Out-File $outfile -Append
    $info | Select-String -Pattern "^OS", "Original Install Date", "Boot", "System Type", "Domain", "Logon Server" | Out-File $outfile -Append
    
    # Hardware Information
    "`r`nHardware Information`r`n$($Spacer)" | Out-File $outfile -Append
    # Creates an array from the System.Object 
    $HWInfo = $info | Select-String -Pattern "System Model", "System Manufacturer", "Physical Memory", "BIOS" 
    
    # $CPU is a Managerment.BaseObject. Need to add to above array. (Awful Formatting...)
    $CPU = Get-WmiObject -ComputerName . -Class Win32_Processor | select Name, SocketDesignation
    $HWInfo += "Processor:`t`t   $($CPU.Name)`r`nSocket:`t`t`t   $($CPU.SocketDesignation)"
    
    # Writes all info to file
    $HWInfo | Out-File $outfile -Append
    
    # Hard Drive Information
    "Hard Drive Information`r`n$($Spacer)" | Out-File $outfile -Append
    Get-WmiObject -Class Win32_LogicalDisk | Where-Object{$_.Size -gt 0} | ft DeviceID, VolumeName, FileSystem, @{expression={[math]::Round($_.Size / 1GB)}; label='Size'}, @{expression={[math]::Round($_.FreeSpace / 1GB)}; Label='FreeSpace'}, @{expression={[math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2)}; label='Used'} | Out-File $outfile -Append

    # Network Information
    "Network Information`r`n$($Spacer)" | Out-File $outfile -Append
    Get-NetAdapter | Where-Object{$_.Status -eq "Up"}  | ft Name, InterfaceDescription, Status, LinkSpeed, FullDuplex, @{expression={$_.ActiveMaximumTransmissionUnit}; Label='MTU'} | Out-File $outfile -Append
    
    # User Information
    "User Information`r`n$($Spacer)" | Out-File $outfile -Append
    Get-WmiObject -ComputerName . -Class Win32_UserAccount | ft Name, Status, Disabled, LocalAccount, PasswordChangeable, PasswordExpires, PasswordRequired, InstallDate | Out-File $outfile -Append

    # Software Information
    "Software Information`r`n$($Spacer * 2)" | Out-File $outfile -Append
    "Please check $($env:COMPUTERNAME)_Software.html for more details" | Out-File $outfile -Append
    $Spacer * 2 | Out-File $outfile -Append

    # Setting HTML formatting
    $header = "<style>"
    $header = $header + "BODY{background-color:#CCC;}"
    $header = $header + "TABLE{border-width: 2px;border-style: solid;border-color: black;border-collapse: collapse;}"
    $header = $header + "TH{background-color: gray; border-width: 2px;padding: 0px;border-style: solid;border-color: black;}"
    $header = $header + "TD{width: 33%; text-align: center; border-width: 2px;padding: 0px;border-style: solid;border-color: black;}"
    $header = $header + "</style>"

    #Software Information
    Get-WmiObject -ComputerName . -Class Win32_Product | Sort-Object Name | Select-Object Name, Version, Caption | ConvertTo-Html -Head $header -Body "<h1>Software Information</h1>" | Out-File $PSScriptRoot\$env:COMPUTERNAME\$($env:COMPUTERNAME)_Software.html
    
    # Enabled firewall rules
    Get-NetFirewallRule | Where-Object{$_.Enabled -eq 'True'} | Select-Object DisplayName, Description, Profile, Direction, Action | Sort-Object Name | ConvertTo-Html -Head $header -Body "<h1>Firewall Rules: Enabled Only</h1>" | Out-File $PSScriptRoot\$env:COMPUTERNAME\$($env:COMPUTERNAME)_Firewall-Enabled.html
    
    }


# Main function run
InfoGather