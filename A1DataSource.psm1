<#
.SYNOPSIS
Creates a new Action1 Data Source.

.DESCRIPTION
The New-A1DataSource function creates a new Action1 Data Source object with hostname and unique A1_Key.
Use Set-A1DataSource to add or update properties of the data source.

.OUTPUTS
System.Management.Automation.PSCustomObject
Returns a PSCustomObject representing the new Action1 Data Source with the following properties:
- Hostname: The hostname of the computer.
- A1_Key: A unique GUID.

.EXAMPLE
PS> $MyDataSource = New-A1DataSource # Create new data source
PS> $MyDataSource | Set-A1DataSource -Key "Reboot Needed" -Value "Yes" # Add a key and value
PS> $MyDataSource # Outputs the data source to be logged by Action1.

#>
function New-A1DataSource {
    [CmdletBinding()]

    # Create a new PSCustomObject
    $DataSource = [PSCustomObject]@{
        Hostname = $env:COMPUTERNAME
        A1_Key   = (New-Guid).ToString()
    }

    $DataSource
}

<#
.SYNOPSIS
Sets or updates an Action 1 Data Source property.

.DESCRIPTION
The Set-A1DataSource function sets or updates a data source property of an object created with New-A1DataSource.

.PARAMETER InputObject
An object created with New-A1DataSource

.PARAMETER Key
The key/name of the data source property to set or update.

.PARAMETER Value
The value to set or update for the specified key.

.EXAMPLE
PS> $MyDataSource = New-A1DataSource # Create new data source
PS> Set-A1DataSource -InputObject $MyDataSource -Key "Reboot Needed" -Value "Yes" # Add property
PS> $MyDataSource # Output the data to be logged by Action1

.EXAMPLE
PS> $MyDataSource = New-A1DataSource # Create a new data source
PS> $MyDataSource | Set-A1DataSource "Reboot Needed" "Yes" # Add property
PS> $MyDataSource # Output the data to be logged by Action1

.INPUTS
System.Management.Automation.PSCustomObject

.OUTPUTS
System.Management.Automation.PSCustomObject

#>
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
        }
    }
}

Export-ModuleMember -Function @('New-A1DataSource', 'Set-A1DataSource')