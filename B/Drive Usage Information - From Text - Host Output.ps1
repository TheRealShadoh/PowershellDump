﻿# Issue warning if % free disk space is less than:
$PERCENTWARNING = 15
# Get server list:
$SERVERS = GET-CONTENT "C:\USESERVERS.TXT"
FOREACH($SERVER IN $SERVERS)
{   # Get drive info:
    $DISKS = GET-WMIOBJECT WIN32_LOGICALDISK -CN $SERVER -FILTER "DRIVETYPE=3" -ERRORACTION SILENTLYCONTINUE
    FOREACH($DISK IN $DISKS)
    {   $DEVICEID = $DISK.DEVICEID
        $SIZE = $DISK.SIZE
        $FREESPACE = $DISK.FREESPACE

        $PERCENTFREE = [Math]::ROUND(($FREESPACE/$SIZE) * 100, 1)
        $SIZEGB = [Math]::ROUND($SIZE/1073741824, 1)
        $FREESPACEGB = [Math]::ROUND($FREESPACE/1073741824, 1)
        $USEDGB = [Math]::ROUND(($SIZEGB - $freespaceGB), 1)
        
        IF($PERCENTFREE -gt $PERCENTWARNING){$COLOR = "GREEN"}
        ELSEIF($PERCENTFREE -lt $PERCENTWARNING){$COLOR = "RED"}
        WRITE-HOST -FOREGROUNDCOLOR $COLOR "$SERVER ($DEVICEID)
TOTAL:  $SIZEGB GB
USED:   $USEDGB GB
FREE:   $FREESPACEGB GB
% FREE: $PERCENTFREE%
            "        
    }
}
