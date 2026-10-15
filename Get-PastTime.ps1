function Get-PastTime {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidatePattern('^\d*\.?\d+[mhdMHD]$')]
        [string]$RelativeTime,

        [Parameter(Mandatory = $false)]
        [datetime]$StartTime = (Get-Date)
    )

    # Extract the numeric value (supporting decimals) and the unit
    $value = [double]($RelativeTime -replace '[^\d.]')
    $unit = $RelativeTime -replace '[\d.]'

    # Calculate the TimeSpan accurately with fractions
    $timeSpan = switch ($unit.ToLower()) {
        'm' { [timespan]::FromMinutes($value) }
        'h' { [timespan]::FromHours($value) }
        'd' { [timespan]::FromDays($value) }
        default { 
            Write-Error "Invalid unit '$unit'. Please use 'm' for minutes, 'h' for hours, or 'd' for days."
            return
        }
    }

    # Calculate the past time from the specified start time
    $absoluteTime = $StartTime - $timeSpan

    # Output the results
    [PSCustomObject]@{
        InputRelativeTime = $RelativeTime
        StartTime         = $StartTime
        AbsoluteTime      = $absoluteTime
        FormattedString   = $absoluteTime.ToString("yyyy-MM-dd HH:mm:ss.fff")
        EpochSeconds      = ([datetimeoffset]$absoluteTime).ToUnixTimeSeconds()
    }
}
