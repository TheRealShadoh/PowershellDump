<#  .DESCRIPTION

Multi-thread tool to be used as the baseline template for future scripts utilizing PS Jobs

If using template ONLY modify the sections within $Scriptblock
In order to maintain error handling only chang the between $ping and $success

Object details for the final variable of $outcome

Target_ID - Variable input from list
Ping - if ONLINE or OFFLINE
Task_Status - Did the task schedule
Error - Recorded Error Message
Success - True or False value to track and record numbers from push
Use $outcome to view results
#>