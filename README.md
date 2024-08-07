This module simplifies creating Action1 Data Sources. Instead of manually creating the needed object, two functions can be pasted into a Data Source script and then easily integrated with your script.

# Usage
Paste the two functions from this module into your Action1 Data Source script:
```powershell
function New-A1DataSource {
    [CmdletBinding()]

    # Create a new PSCustomObject
    $DataSource = [PSCustomObject]@{
        A1_Key = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($env:COMPUTERNAME)).Replace('=', '')
    }

    $DataSource
}

function Set-A1DataSource {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [PSCustomObject]$InputObject,

        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [string]$Key,

        [Parameter(
            Mandatory = $true,
            Position = 2
        )]
        [string]$Value
    )

    process {
        # Test if the $Key exists in the $InputObject
        if ($InputObject.PSObject.Properties[$Key]) {
            # If it does, update the value
            $InputObject.$Key = $Value
        }
        else {
            # If it doesn't, add a new property
            $InputObject | Add-Member -MemberType NoteProperty -Name $Key -Value $Value

            # Ensure A1_Key is the last property
            $InputObject | Add-Member -MemberType NoteProperty -Name A1_Key -Value $InputObject.A1_Key -Force
        }
    }
}
```

Then, initialize a variable to store the data source data, add fields to it, and at the end of the script just output your data source variable. Here is an example that just logs the currently logged in user:
```powershell
$DataSource = New-A1DataSource

Set-A1DataSource $DataSource "Currently Logged On User" (Get-WMIObject -class Win32_ComputerSystem | select -ExpandProperty username)

$DataSource
```

# PowerShell Module
This is packaged as a PowerShell Module, but to be used in an Action1 Data Source only needs the two functions from the module to be pasted into the Action1 Data Source script. 
