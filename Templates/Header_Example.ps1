<#
	.SYNOPSIS
		Created: TheRealShadoh
		Date:
		Multithread your scripts!

	.DESCRIPTION
		Leverage the power of runspaces to quickly execute a script or scriptblock.
		Pass this function the script or scriptblock, as well as the target for it to run against.
		Ensure that each entry is on its own line. And if you are passing an array of objects, make sure you pass the correct object, IE.. $computers.name
		Within your scriptblock, you should print the information you desire to the console, I recommend using a PSCustomObject and printing an object to the console.

	.PARAMETER Target
		Computer name of your target, or a list of your targets. Currently not accepting pipeline input.

	.PARAMETER Scriptblock
		Pass your scriptblock in here, or the path to your script.
		Your scriptblock should be written as if it was running independently, do not reference anything outside of the scriptblock, the only exception is the remote computer name you are targetting (See NOTE below).
		NOTE: In your scriptblock anytime you reference the computername, be sure to use $args[0]. This is the only argument that is passed into the runspace.

	.PARAMETER Timeout
		Set your timeout period, in minutes, default is 5 minutes.

	.PARAMETER Maxthreads
		Set that max amount of threads you want to allow, default is 100.

	.NOTES
		Use at your own risk.
	.EXAMPLE
    Put example explanation here
        Put example code here
    .EXAMPLE
    Put example explanation here
        Put example code here
#>