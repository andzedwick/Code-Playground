# Powershell Script

$FilePath = split-path -parent $psISE.CurrentFile.Fullpath
$FileName = "Large_Dataset_Generated.csv"
$FullPath = $FilePath + "\" + $FileName

$fileSizeMB = 15000
$idNum = 0

$baseDate = (Get-Date "2019/1/1 12:59:59")
$fullYear = 366*24*60*60

"`n`nStart Time:`t"
(Get-Date).DateTime
"`n`n"

New-Item -Path $FilePath -Name $FileName -Force
"ID,Date,Customer,Type,Value" | Out-File -FilePath $FullPath -Encoding utf8

while((Get-Item -Path $FullPath).Length -lt $fileSizeMB * 1000000){
    $lines = ""
    1..5000 | % {
        $dt = $baseDate.AddSeconds(-(Get-Random $FullYear)).ToShortDateString()
        $ct = (Get-Random 100)
        if ((Get-Random 5) -lt 4) {
            $ty = "Sale"
        } else {
            $ty = "Return"
        }
        $vl = (Get-Random 100000)
        $lines += [String]($idNum++) + "," + [String]$dt + "," + [String]$ct + "," + $ty + "," + [String]$vl + [char]10 + [char]13
    }
    $lines | Out-File -FilePath $FullPath -Encoding utf8 -Append
}

"`n`nEnd Time:`t"
(Get-Date).DateTime