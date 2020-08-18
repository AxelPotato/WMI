# Based on https://learn-powershell.net/2013/08/14/powershell-and-events-permanent-wmi-event-subscriptions/

# Set the namespace
$wmiParams = @{
  NameSpace = 'root\subscription'
}

# Creating a new event filter
$wmiParams.Class = '__EventFilter'
$wmiParams.Arguments = @{
  Name           = 'BugSecFilter'
  EventNamespace = 'root\CIMV2'
  QueryLanguage  = 'WQL'
  Query          = "select * from __InstanceCreationEvent  within 5 where targetInstance isa 'Win32_Process' and TargetInstance.Name = 'chrome.exe'"
}

$filterResult = Set-WmiInstance @wmiParams

# Creating a new consumer
$wmiParams.Class = 'CommandLineEventConsumer'
$wmiParams.Arguments = @{
  Name                = 'BugSecConsumer'
  CommandLineTemplate = "cmd.exe /c echo test > c:\WMI-instance.txt"
}

$consumerResult = Set-WmiInstance @wmiParams

# Bind filter to consumer
$wmiParams.Class = '__FilterToConsumerBinding'
$wmiParams.Arguments = @{
  Filter   = $filterResult
  Consumer = $consumerResult
}

Set-WmiInstance @wmiParams