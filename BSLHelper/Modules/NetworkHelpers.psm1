function Get-IpAddress {
    $IpAddress = 0

    $WiFiInterface = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.Name -like "*Wi-Fi*" }

    if ($WiFiInterface) {
        $IpAddress = Get-NetIPAddress -InterfaceIndex $WiFiInterface.ifIndex | Where-Object { $_.AddressFamily -eq "IPv4" } | Select-Object -ExpandProperty IPAddress

        return $IpAddress
    }

    $EthernetInterface = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.Name -like "*Ethernet*" }

    if ($EthernetInterface) {
        $IpAddress = Get-NetIPAddress -InterfaceIndex $EthernetInterface.ifIndex | Where-Object { $_.AddressFamily -eq "IPv4" } | Select-Object -ExpandProperty IPAddress

        return $IpAddress
    }

    return $IpAddress
}