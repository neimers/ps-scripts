# THIS SCRIPT SEARCHES ALL FILES IN A FOLDER (INCLUDING SUB FOLDERS) LOOKING FOR CONTENTS THAT MATCH THE REGULAR EXPRESSION
# ANY MATCHES ARE REPLACED WITH THE INDICATED STRING!
# ANY MATCHES ARE ALSO WRITTEN TO A CSV FILE!

# Root Directory to Search Within
$Directory = "C:\temp\test"

# Output File to Write Matches Into
$ResultsCSV = "C:\TEMP\output\Results.csv" 

# Regex Expression to Match Against
$RX = "string x"

# String to replace it with
$Replace = "string 2"

$TextFiles = Get-ChildItem $Directory -Include *.txt*,*.csv*,*.rtf*,*.eml*,*.msg*,*.dat*,*.ini*,*.mht* -Recurse

 $file2 =  new-object System.IO.StreamWriter($ResultsCSV) #output Stream
 $file2.WriteLine('Matches,File Path') # write header

foreach ($FileSearched in $TextFiles) {   #loop over files in folder
    
    #Write-Host $FileSearched

    $content = Get-Content $FileSearched
    #$newContent = $content.Replace($RX, $Replace)

    if($content -match $RX){
        $file2.WriteLine("{0},{1}",$match.Value, $FileSearched.fullname) 
        Set-Content -Path $FileSearched -Value $content.Replace($RX, $Replace)
    }
}

# close CSV
$file2.close()