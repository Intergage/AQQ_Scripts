# Round function
function roundNumber($int){
    $newInt = [math]::Round($int, 2)
    $newInt
}

# Getting basic info from user
$tonerYield = Read-Host -Prompt "Toner Page Yield _> "
$tonersellPrice = Read-Host -Prompt "Sell price of toner _> "
[datetime]$supDate = Read-Host -Prompt "Old Printer Supply Date (mm/dd/yyyy) _> "
$totalprintPages = Read-Host -Prompt "Total Printed Pages _> "

# Getting date span for life of printer
$curDate = Get-Date
$usedDays = New-TimeSpan -Start $supDate -End $curDate

# Removing Weekends from .Days
$usedworkingDays = ($usedDays.Days / 7) * 2
$usedworkingDays = $usedDays.Days - $usedworkingDays

# Average pages printed per day over lifetime of printer
$avgpagesDay = $totalprintPages / $usedworkingDays

# How many toners will be needed to handle the above average for a year
$tonersYear = $tonerYield / $avgpagesDay
$tonersYear = 365 / $tonersYear

# Yearly cost of toners to support the above average
$tonersCost = $tonersYear * $tonersellPrice

# Rounding all numbers
$tonersYear = roundNumber($tonersYear)
$avgpagesDay = roundNumber($avgpagesDay)
$usedworkingDays = roundNumber($usedworkingDays)
$tonersCost = roundNumber($tonersCost)

# Output
Write-Host @"

Printer used for busniess days:                 $usedworkingDays
Printed average pages/day:                      $avgpagesDay 
Toners/year:                                    $tonersYear

"@ -ForegroundColor Red

Write-Host "This will cost you $ `b$tonersCost/year in toners." -ForegroundColor Red