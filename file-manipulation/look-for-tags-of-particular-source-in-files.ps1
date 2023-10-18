# THIS SCRIPT SEARCHES FOR THE REGEX (WHICH IS LOOKING FOR TAGS OF A PARTICULAR SOURCE) IN ALL FILE RECURSIVELY
# IT LOGS THE MATCHES TO FILE, AND LOGS THE UNIQUE MATCHES TO A DIFFERENT FILE

# Get Directory This Script is In (Assume Will Be Root For Everything Else)
$invocation = (Get-Variable MyInvocation).Value
$directorypath = Split-Path $invocation.MyCommand.Path

# Output File to Write Matches Into
$ResultsCSV = "E:\TEMP\Results.csv"
$TagListCSV = "E:\TEMP\Results_taglist.csv" 

# Directory to Search Within
$Directory = "\\HAWParcServer\Capstone\dataparc\Hawesville\Users\Capstone\neimers"

# Regex Expression to Match Against
$RX = "[>\""]([Hh][Aa][Ww]\.[Pp][Ii]\..*?)[<\""]"

$d = [System.Collections.Generic.Dictionary[String,String]]::new()

Write-Host "Getting files..."

$TextFiles = Get-ChildItem $Directory -Include *.xaml,*.dis_* -Recurse

Write-Host "Done getting files, found: " $TextFiles.Count.ToString()

$file2 =  new-object System.IO.StreamWriter($ResultsCSV) #output Stream
$file2.WriteLine('Matches,File Path') # write header

foreach ($FileSearched in $TextFiles) {   #loop over files in folder

    Write-Host "Searching: " $FileSearched

    $file = New-Object System.IO.StreamReader ($FileSearched)  # Input Stream

    while ($text = $file.ReadLine()) {      # read line by line
        foreach ($match in ([regex]$RX).Matches($text)) {
            $s = $match.Groups[1].Value.ToUpperInvariant()

            $s = $s.Replace("/PLOT", "")

            $file2.WriteLine("{0},{1}",$s, $FileSearched.FullName )
            
            if(-not $d.ContainsKey($s))
            {
                $d.Add($s, $FileSearched.FullName)
            }
            else
            {
                $d[$s] = $d[$s] + "," + $FileSearched.FullName
            }
        }
    }
    $file.close();  
}  
$file2.close();

$file_taglist =  new-object System.IO.StreamWriter($TagListCSV) #output Stream
$file_taglist.WriteLine('Tag,File Paths') # write header

Write-Host "Done writing matches file."

Write-Host "Writing out unique matches."

foreach ($key in $d.Keys)
{
    $file_taglist.WriteLine("{0},{1}",$key, $d[$key])
}

$file_taglist.Close();

Write-Host "Execution complete."