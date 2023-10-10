# Load a list of mappings, "find" string and correspnding "replace" string, then hunt through target file and replace all instances of the 'find' list.
# Note - the list of mappings needs to be ordered from longest string to shortest string, otherwise you could have incorrect replacements if
#        you are replacing say "LOC.SRC.TAG1" but also "LOC.SRC.TAG1_CALC", as the first will also match the second.
# this one came courtesy of Andy Wirtz
Param (
    [String]$List = "PITagReplace.csv",
    [String]$Files = ".\ctc_custom\UPDATE\ctc_daily_status_config.sql"
)
$ReplacementList = Import-Csv $List;
Get-ChildItem $Files |
ForEach-Object {
    $Content = Get-Content -Path $_.FullName;
    foreach ($ReplacementItem in $ReplacementList)
    {
#        $Content = $Content.Replace($ReplacementItem.OldValue, $ReplacementItem.NewValue)
        $Content = $Content -ireplace [regex]::Escape($ReplacementItem.OldValue), $ReplacementItem.NewValue
    }
    $_.FullName
    Set-Content -Path $_.FullName -Value $Content
}