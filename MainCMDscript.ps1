function Print-TermuxArt {
    Write-Host @"
 /*
 *     ___  ___  ___  ___  ___  ____ ___  ___   ___  ___  _ _  ____ 
 *    | . \| . \| . || . \| . \<__ /| . || . \ | . \| . || | ||_  / 
 *    | | ||   /| | ||  _/| | | <_ \|   || | | | | ||   |\   / / /  
 *    |___/|_\_\`___'|_|  |___/<___/|_|_||___/ |___/|_|_| |_| /___| 
 *     ___  ___  _ _  ___  _    ___  ___  __ __  ___  _ _  ___      
 *    | . \| __>| | || __>| |  | . || . \|  \  \| __>| \ ||_ _|     
 *    | | || _> | ' || _> | |_ | | ||  _/|     || _> |   | | |      
 *    |___/|___>|__/ |___>|___|`___'|_|  |_|_|_||___>|_\_| |_|      
 *                                                                  
 */
"@ -ForegroundColor Green
}
# Function to run the first script
function Closing-Tags-Check {
    $filePath = Read-Host -Prompt 'C:\Users\Chaos\Downloads\cfgspawnabletypes_1 (1).xml'

    if (-not (Test-Path $filePath)) {
        Write-Host "File Path Invalid/Not Found: $filePath"
        return
    }

    [xml]$xml = Get-Content -Path $filePath

    $openTags = @{}

    $xml.SelectNodes("//*") | ForEach-Object {
        $openTags[$_.Name]++

        if ($_.HasChildNodes) {
            $_.ChildNodes | ForEach-Object {
                if ($_.NodeType -eq "Element") {
                    $openTags[$_.Name]++
                }
            }
        }
    }

    $openTags.GetEnumerator() | ForEach-Object {
        if ($_.Value -gt 1) {
            Write-Host "Closing tag for $($_.Key): </$($_.Key)>"
        }
    }
}
# Function to run the second script
function Parse-JsonWithErrorHandling {
    param (
        [Parameter(Mandatory=$true)]
        [string]$JsonString
    )

    # Split the JSON string into lines
    $lines = $JsonString -split "`n"

    # Initialize an empty array to store the parsed objects
    $parsedObjects = @()

    # Iterate over each line
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]

        try {
            # Attempt to parse the line as JSON
            $parsedObject = $line | ConvertFrom-Json
            # If successful, add the parsed object to the array
            $parsedObjects += $parsedObject
        } catch {
            # If an error occurs, print the line number and error message
            Write-Host "Error parsing line $($i + 1): $($_.Exception.Message)"
        }
    }

    # Return the array of parsed objects
    return $parsedObjects
}

# Function to run the third script
function Run-Script3 {
    Clear-Host
    Write-Host "Running the third script..."
    Start-Sleep -Seconds 2
    Clear-Host

    # DayZ JSON & XML Parser

    function Validate-Json {
        param ($file_path)
        try {
            $json = Get-Content -Path $file_path -Encoding UTF8 | ConvertFrom-Json
            return $json
        } catch {
            Write-Host "Error parsing JSON file: $file_path"
            Write-Host $_.Exception.Message
            return $null
        }
    }

    function Validate-Xml {
        param ($file_path)
        try {
            [xml]$xml = Get-Content -Path $file_path -Encoding UTF8
            return $xml
        } catch {
            Write-Host "Error parsing XML file: $file_path"
            Write-Host $_.Exception.Message
            return $null
        }
    }

    function Check-FolderForInvalidFiles {
        param ($folder_path)
        $log_file_path = Join-Path -Path (Get-Item -Path "~\Downloads").FullName -ChildPath "validation_log.txt"
        $log_file = New-Item -Path $log_file_path -ItemType File -Force

        Get-ChildItem -Path $folder_path -Recurse | ForEach-Object {
            $file_path = $_.FullName
            $parsed_data = $null

            if ($_.Extension -eq ".json") {
                $parsed_data = Validate-Json -file_path $file_path
            } elseif ($_.Extension -eq ".xml") {
                $parsed_data = Validate-Xml -file_path $file_path
            }

            if ($parsed_data) {
                $output_file_path = Join-Path -Path (Get-Item -Path "~\Downloads").FullName -ChildPath "$($_.BaseName).parsed$($_.Extension)"
                $parsed_data | ConvertTo-Json | Out-File -FilePath $output_file_path
            } else {
                $log_message = "File: $file_path, Error: Invalid format`n"
                Add-Content -Path $log_file_path -Value $log_message
            }
        }
    }

    # Set the target folder path
    $target_folder = "Path-to-server-folder"

    # Run the script
    Check-FolderForInvalidFiles -folder_path $target_folder

    # Print the log file contents after debugging
    Get-Content -Path $log_file_path
    Write-Host "Third script output"
    Start-Sleep -Seconds 2
    Clear-Host
}

# Function to run the fourth script
function Generate-XML {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$class_names
    )

    $xml_content = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<types>
  "@

    foreach ($class_name in $class_names) {
        $class_name = $class_name.Trim()
        $xml_content += "
`t<type name=""$class_name"">
`t\t<nominal>NOMINAL-CHANGE-ME</nominal>
`t\t<lifetime>LIFETIME-CHANGE-ME</lifetime>
`t\t<restock>RESTOCK-CHANGE-ME</restock>
`t\t<min>MIN-CHANGE-ME</min>
`t\t<quantmin>-1</quantmin>
`t\t<quantmax>-1</quantmax>
`t\t<cost>100</cost>
`t\t<flags count_in_cargo=""0"" count_in_hoarder=""0"" count_in_map=""1"" count_in_player=""0"" crafted=""0"" deloot=""0"" />
`t\t<category name=""CAT-CHANGE-ME"" />
`t\t<usage name=""USAGE-CHANGE-ME"" />
`t</type>
"
    }

    $xml_content += "
</types>
"

    return $xml_content
}

# Input a list of classnames you want to add to types.
$input_class_names = @"
Classname_01
Classname_01
Classname_04
Classname_03
Classname_05
handler/weapon_melee_item
"@

# Remove duplicate class names
$class_names = $input_class_names.Trim().Split("`n") | Select-Object -Unique

# Generate XML
$xml_content = Generate-XML -class_names $class_names

# Define Downloads directory
$downloads_folder = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads\Export")
if (!(Test-Path -Path $downloads_folder)) {
    New-Item -ItemType Directory -Force -Path $downloads_folder
}

# Save XML file
$output_file_path = [System.IO.Path]::Combine($downloads_folder, "types_missing.xml")
$xml_content | Set-Content -Path $output_file_path -Encoding UTF8

Write-Output "XML content generated and saved to: $output_file_path"
    Write-Host "Fourth script output"
    Start-Sleep -Seconds 2
    Clear-Host
}

# Function to run the fifth script
function Replace-Content-With {
    Clear-Host
    Write-Host "Running the fifth script..."
    Start-Sleep -Seconds 2
    Clear-Host

    # Define the directory to search in
    $searchDirectory = "C:\Users\Documents\GitHub\server_logs"

    # Define the word to search for
    $searchWord = "YourOLDMOD"

    # Define the new word to replace the found word with
    $replaceWord = "YourNEWMOD"

    # Recursively find all files in the directory and its subdirectories
    Get-ChildItem -Path $searchDirectory -Recurse -Include *.xml,*.c | ForEach-Object {
        # Read the file line by line
        $content = Get-Content $_.FullName

        # Replace the found word with the new word
        $newContent = $content -replace [regex]::Escape($searchWord), $replaceWord

        # Write the new content back to the file
        Set-Content -Path $_.FullName -Value $newContent
    }

    Write-Host "Replacement completed."

    Start-Sleep -Seconds 2
    Clear-Host
}

# Function to extract class names from config.cpp and generate types.xml
function Extract-ClassNames {
    Clear-Host
    Write-Host "Extracting class names from config.cpp..."
    Start-Sleep -Seconds 2
    Clear-Host

    $inputFilePath = "config.cpp"
    $outputFilePath = Read-Host "Enter the output file path for ClassNames.txt"

    # Read the content of the input file
    $content = Get-Content -Path $inputFilePath -Raw

    # Find the start index of "class CfgVehicles"
    $startIndex = $content.IndexOf("class CfgVehicles")

    # Set the end index to the end of the file
    $endIndex = $content.Length

    # Extract the content between "class CfgVehicles" and the end of the file
    $cfgVehiclesContent = $content.Substring($startIndex, $endIndex - $startIndex)

    # Find all occurrences of "class" within "class CfgVehicles"
    $classOccurrences = $cfgVehiclesContent -split "class " | Where-Object { $_ -ne "" }

    # Extract the class names without ';' or ':'
    $classNames = @()
    foreach ($occurrence in $classOccurrences) {
        $className = $occurrence.Split()[0].TrimEnd(';').TrimEnd(':')
        $classNames += $className
    }

    # Write the extracted class names to the output file
    $classNames -join "`n" | Set-Content -Path $outputFilePath

    Write-Host "Classnames extracted and saved to $outputFilePath"
    Start-Sleep -Seconds 2
    Clear-Host
}

# Function to convert class names to types in XML format
function Convert-ClassNamesToTypes {
    Clear-Host
    Write-Host "Converting class names to types in XML format..."
    Start-Sleep -Seconds 2
    Clear-Host

    $inputFilePath = Read-Host "Enter the input file path for ClassNames.txt"
    $outputFilePath = Read-Host "Enter the output file path for types.xml"

    # Start the XML structure
    Add-Content -Path $outputFilePath -Value '<types>'

    # Read the input file line by line
    Get-Content $inputFilePath | ForEach-Object {
        $line = $_.Trim()

        if ($line.StartsWith("##")) {
            # Skip lines starting with ##
            return
        }

        if ($line.StartsWith("crsk")) {
            $lifetime = 86400
        } else {
            $lifetime = 1800
        }

        # Write the XML structure for each line
        Add-Content -Path $outputFilePath -Value " <type name=`"$line`">"
        Add-Content -Path $outputFilePath -Value "    <nominal>0</nominal>"
        Add-Content -Path $outputFilePath -Value "    <lifetime>$lifetime</lifetime>"
        Add-Content -Path $outputFilePath -Value "    <restock>0</restock>"
        Add-Content -Path $outputFilePath -Value "    <min>0</min>"
        Add-Content -Path $outputFilePath -Value '    <flags count_in_cargo="0" count_in_hoarder="0" count_in_map="1" count_in_player="0" crafted="0" deloot="0" />'
        Add-Content -Path $outputFilePath -Value " </type>"
    }

    # End the XML structure
    Add-Content -Path $outputFilePath -Value '</types>'

    Write-Host "XML file generated at $outputFilePath"
    Start-Sleep -Seconds 2
    Clear-Host
}

# Function to show the input panel
function Show-InputPanel {
    Write-Host "Enter your command:"
   $input = Read-Host
    Write-Host "You entered: $input"
}

# Main function
function Main {
    # Clear the screen
    Clear-Host

    # Print the Termux art
    Print-TermuxArt

    # Create buttons for each script
    Write-Host "1. Closing-Tags-Check" -ForegroundColor Green
    Write-Host "2. Parse JSON with error handling" -ForegroundColor Green
    Write-Host "3. DayZ JSON & XML Parser" -ForegroundColor Green
    Write-Host "4. Generate XML" -ForegroundColor Green
    Write-Host "5. Replace-Content-With" -ForegroundColor Green
    Write-Host "6. Extract class names from config.cpp" -ForegroundColor Green
    Write-Host "7. Convert class names to types in XML format" -ForegroundColor Green
    Write-Host "8. Show input panel" -ForegroundColor Green

    # Wait for user input
    $selection = Read-Host "Enter the number of the script you want to run or '8' for the input panel"

    # Run the selected script or show the input panel
    switch ($selection) {
        1 { Run-Script1 }
        2 { Run-Script2 }
        3 { Run-Script3 }
        4 { Run-Script4 }
        5 { Run-Script5 }
        6 { Extract-ClassNames }
        7 { Convert-ClassNamesToTypes }
        8 { Show-InputPanel }
        default { Write-Host "Invalid selection. Please try again." }
    }

    # Print the Termux art again
    Print-TermuxArt

    # Wait for user input
    Read-Host "Press Enter to exit..."

    # Exit the script
    Exit
}

# Call the main function
Main