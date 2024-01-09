# Move profile data that is timestamped between two dates to a new folder (to allow backfilling or whatever)
$InputDirectory = "E:\CapstoneData\ARCHIVE\PC-N2-800xA"
$BackupDirectory = "E:\temp\ProfBackup"
$SourceName = "PC-N2-800xA"

$DtStartFilter = [DateTime]::ParseExact("2023-10-01", "yyyy-MM-dd", $null)
$DtEndFilter = [DateTime]::ParseExact("2024-01-01", "yyyy-MM-dd", $null)

$LogOnly = $false

$FileFilter = "PD_" + $SourceName + "_*_*.dat"

$DatFiles = Get-ChildItem $InputDirectory -Filter $FileFilter

$x = 0

Write-Host "Done getting files, found: " $DatFiles.Count.ToString()

foreach ($File in $DatFiles) {   #loop over files in folder

    $DateString = $File.Name.Replace("PD_" + $SourceName + "_", "").Replace(".dat", "")

    $DSParam1 = [Int16]::Parse($DateString.Substring(0, $DateString.IndexOf("_")))

    $DateString = $DateString.Replace($DSparam1.ToString("0") + "_", "")

    $dt = [DateTime]::ParseExact($DateString, "yyyyMMdd", $null)

    if($dt -ge $DtStartFilter -and $dt -lt $DtEndFilter){

        Write-Host "File Name:" $File.Name

        if($LogOnly -eq $false){
            Write-Host $file.FullName
            
            $NewPath = $BackupDirectory + "\" + $file.Name

            Move-Item -Path $file.FullName -Destination $NewPath
        }

        $x += 1
    }

}

if($LogOnly -eq $false){
    Write-Host "Moved:" $x.ToString("0") "files"
}
else{
    Write-Host "Found:" $x.ToString("0") "files"
}