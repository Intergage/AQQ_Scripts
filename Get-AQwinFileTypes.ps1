cd Q:\aqwin

$data = gci | select FullName, Extension

$exts = @()

foreach($ext in $data){
    if($ext -notin $exts){
        $exts += $ext.Extension
    }
}

$exts | group                              
