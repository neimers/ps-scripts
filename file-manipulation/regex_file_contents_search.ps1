# THIS SCRIPT SEARCHES ALL FILES IN A FOLDER (INCLUDING SUB FOLDERS) LOOKING FOR CONTENTS THAT MATCH THE REGULAR EXPRESSION
# ANY MATCHES ARE WRITTEN TO A CSV FILE!

# Get Directory This Script is In (Assume Will Be Root For Everything Else)
$invocation = (Get-Variable MyInvocation).Value
$directorypath = Split-Path $invocation.MyCommand.Path

# Output File to Write Matches Into
$ResultsCSV = "C:\TEMP\output\Results.csv" 

# Directory to Search Within
$Directory = $directorypath + "\demo-files"

# Regex Expression to Match Against
$RX = "(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}"

$TextFiles = Get-ChildItem $Directory -Include *.txt*,*.csv*,*.rtf*,*.eml*,*.msg*,*.dat*,*.ini*,*.mht* -Recurse

 $file2 =  new-object System.IO.StreamWriter($ResultsCSV) #output Stream
 $file2.WriteLine('Matches,File Path') # write header

foreach ($FileSearched in $TextFiles) {   #loop over files in folder

    Write-Host "Searching: " $FileSearched

    $file = New-Object System.IO.StreamReader ($FileSearched)  # Input Stream

    while ($text = $file.ReadLine()) {      # read line by line
        foreach ($match in ([regex]$RX).Matches($text)) {   
               $file2.WriteLine("{0},{1}",$match.Value, $FileSearched.fullname )  
        }
    }
     $file.close();  
}  
$file2.close()