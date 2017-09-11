function Start-PhoneMsg {
    # Arguments if they want to be used
    param (
        [Parameter(Mandatory = $true)][string]$Shop,
        [Parameter(Mandatory = $true)][string]$Client,
        [Parameter(Mandatory = $true)][string]$Issue
    )

    cd $PSScriptRoot

    # Few random placeholders 
    $date = Get-Date 
    $spacer = '==========='
    $filename = (Get-Date -format "yyyy-MM-dd")


    #Get the actually message
    $TempFile = [System.IO.Path]::GetTempFileName()
    $sw = [Diagnostics.Stopwatch]::StartNew()
    nano $TempFile
    $sw.Stop()

    # Log input
    $spacer + $date + $spacer | Add-Content "E:\PhoneCalls\$($filename)"
    "$($Client) called from $($Shop) regarding $($Issue)`n" | Add-Content "E:\PhoneCalls\$($filename)"
    Get-Content $TempFile | Add-Content "E:\PhoneCalls\$($filename)"
    "`nTime: $($sw.Elapsed)`n========== END ===========`n" | Add-Content "E:\PhoneCalls\$($filename)"

    # Deleting $TempFile
    Remove-Item $TempFile

}