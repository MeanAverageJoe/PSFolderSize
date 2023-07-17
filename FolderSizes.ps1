# Function to calculate folder size
function Get-FolderSize {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({Test-Path -Path $_ -PathType 'Container'})]
        [string]$Path
    )

    $folder = Get-Item -Path $Path
    $size = $folder | Get-ChildItem -Recurse -Force |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum

    $size
}

# Function to iterate over folders and get their sizes
function Get-FolderSizes {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$RootPath
    )

    $folders = Get-ChildItem -Path $RootPath -Directory -Force

    foreach ($folder in $folders) {
        $folderPath = Join-Path -Path $RootPath -ChildPath $folder.Name
        $folderSize = Get-FolderSize -Path $folderPath

        Write-Output "$folderPath`: $folderSize bytes"
        Get-FolderSizes -RootPath $folderPath
    }
}

# Set the root path of the file server
# set the share Name for the root
# $rootPath = "\\ServerName\Share"

# Start calculating folder sizes
Get-FolderSizes -RootPath $rootPath

# Function to get the number of files in a folder and its subfolders

function Get-FileCount {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({Test-Path -Path $_ -PathType 'Container'})]
        [string]$Path
    )

    $folder = Get-Item -Path $Path
    $fileCount = $folder | Get-ChildItem -Recurse -Force |
        Measure-Object -Property Length |
        Select-Object -ExpandProperty Count

    $fileCount
}
