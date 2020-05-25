function detailObject($object)
# Counts how many object fields are in a PSCustomObject
{
	$properties = $object | gm -type Property, noteproperty
	$pcount = $properties.count
	$counter = 0
	While ($counter -lt $pcount)
	{
		$name = ($properties[$counter].name)
		$value = $object[$counter].name
		$Counter++
	}
	$counter
	
}