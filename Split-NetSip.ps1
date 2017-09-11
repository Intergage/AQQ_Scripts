$fileName = Read-Host -Prompt "File name "

$data = Get-Content Z:\Athina\Netsip\$($fileName).csv | ConvertFrom-Csv

$HAE = @()
$AQQ = @()

foreach ($item in $data) {
    if ($item.Source -eq '61732685866') {
        $HAE += $item
    }
    if ($item.Source -eq '61732684699') {
        $AQQ += $item
    }
}

$HAEPrice = @()
foreach ($item in $HAE) {
    $HAEPrice += [float]$item.Price
}

$AQQPrice = @()
foreach ($item in $AQQ) {
    $AQQPrice += [float]$item.Price
}

$AQQTotal = ($AQQPrice | Measure-Object -Sum).Sum
$HAETotal = ($HAEPrice | Measure-Object -Sum).Sum

Write-Host "Total amount for HAE:`t `$$([math]::Round($HAETotal, 2))" -ForegroundColor Green
Write-Host "Total amount for AQQ:`t `$$([math]::Round($AQQTotal, 2))" -ForegroundColor Red

"$(Get-Date)`t$($fileName)`t`t`$$([math]::Round($AQQTotal, 2))" >> NS_AQQ_Total.txt
"$(Get-Date)`t$($fileName)`t`t`$$([math]::Round($AQQTotal, 2))" >> NS_HAE_Total.txt