# ============= SET THESE VALUES =================
$find = "test" # will wildcard search this text
$replace = "replaced" # will replace search text with this text
$search_directory = "D:\temp" # this is the directory that will be searched (non recursive)
# ================================================

cd $search_directory
$find_text = "*" + $find + "*"

Get-ChildItem -Filter $find_text | Rename-Item -NewName {$_.name -replace $find, $replace }

# NOTE - can make it recursively search folders by using this instead:
# Get-ChildItem -Filter $find_text -Recurse | Rename-Item -NewName {$_.name -replace $find, $replace }
