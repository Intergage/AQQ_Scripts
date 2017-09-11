$source = "C:\Users\liam\AppData\Roaming\thunderbird"
$dest = "\\backup\Backups\Emails\Liam\Backup.zip"
$new_fn = $dest + '.' + $(get-date -f yyyy-MM-dd) + '.old'

if(Test-Path $dest){
    Move-Item $dest $new_fn
}

Compress-Archive $source $dest


Write-Host "Backup Complete" -BackgroundColor Red -ForegroundColor Green