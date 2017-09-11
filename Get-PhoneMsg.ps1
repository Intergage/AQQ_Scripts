function Get-PhoneMsg {
    param ([string]$date)

    $folder = 'E:\PhoneCalls'
    cd $folder


    foreach ($x in (Get-ChildItem $folder -File).name) {
        if ($x.StartsWith($date)) {
            write-host  -foreground "red" "`n********************************************"
            write-host  -foreground "red" "**              $($x)                **"
            write-host  -foreground "red" "********************************************`n"

            cat $x
        }

    }
}