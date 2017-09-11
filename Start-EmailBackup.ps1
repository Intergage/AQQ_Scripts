# Find and stop outlook process
$proc = Get-Process | where {$_.Name -match 'OUTLOOK'} | select Id
Stop-Process $proc.Id
Write-Host "Outlook Closed." -ForegroundColor Red

# find all OST files in user 
$ost = Get-ChildItem ~/ -recurse -include *.pst | select FullName, LastWriteTime
Write-Host "Found OST Files" -ForegroundColor Red

# Backup Destination
$dest = "\\backup\Backups\Emails\Matt"

foreach($name in $ost){
    xcopy $name.FullName $dest /E /Y
}

Write-Host "Finished!" -ForegroundColor Green