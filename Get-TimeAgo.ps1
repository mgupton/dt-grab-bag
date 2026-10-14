function Get-TimeAgo {
    param (
        [Parameter(Mandatory)]
        [double]$Value,

        [Parameter(Mandatory)]
        [ValidateSet('Minutes', 'Hours', 'Days')]
        [string]$Unit
    )

    $offset = switch ($Unit) {
        'Minutes' { :FromMinutes($Value) }
        'Hours'   { :FromHours($Value) }
        'Days'    { :FromDays($Value) }
    }

    (Get-Date) - $offset
}
