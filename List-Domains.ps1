$data = Get-Content .\domains.csv | ConvertFrom-Csv

$domains = @()

foreach($domain in $data){
    $domains += $domain.'Domain Name'
}   

$domains > domainlist.txt