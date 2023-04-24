# Assumes host file format is 
#       IP fqdn

$host_content = Get-content "C:\Windows\SYSVOL\domain\scripts\hosts"

$master_hash = @{}
$master_hash.add('hostfile_data', @())

# parse data 
foreach ($data in $host_content){
    # Trim leading and trailling whitespace
    $data = $data.trim()
    # skip comments
    if ($data -notlike "#*" -and $data.length -gt 1) {
        $data = $data.split(' ')
        $data_obj = @{
            "IP" = $data[0];
            "fqdn" = $data[1];
            "shortname" = $data[1].split('.')[0];
            "zone" = ''
        }
        $data_obj.zone = $data_obj.fqdn.replace($data_obj.shortname +'.','')
        $master_hash.hostfile_data += $data_obj
    }

}

# verify zones 

$dns_zones = Get-DnsServerZone

## Ensure each unique zone from host file is in dns
$master_hash.hostfile_data.zone | unique | foreach-object {
    $dns_zones = Get-DnsServerZone
    if ($_ -notin $dns_zones.zonename){
        Add-DnsServerPrimaryZone -Name $_ -ReplicationScope Forest -PassThru
    }
}

# Add records

foreach ($record in $master_hash.hostfile_data) {
    try {s
        Get-DnsServerResourceRecord -Name $record.shortname -ZoneName $record.zone
    }
    catch [Microsoft.Management.Infrastructure.CimException] {
        Add-DnsServerResourceRecordA -Name $record.shortname -ZoneName $record.zone -IPv4Address $record.IP
    }
}
