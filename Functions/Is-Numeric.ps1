function Is-Numeric ($value)
{
	return $value -match "^[\d\.]+$"
}