# Based on https://learn-powershell.net/2013/08/14/powershell-and-events-permanent-wmi-event-subscriptions/

# Creating a new event filter
$instanceFilter = ([wmiclass]"\\.\root\subscription:__EventFilter").CreateInstance()
$instanceFilter.QueryLanguage = "WQL"
$instanceFilter.Query = "select * from __InstanceCreationEvent  within 5 where targetInstance isa 'Win32_Process' and TargetInstance.Name = 'chrome.exe'"
$instanceFilter.Name = "BugSecFilter"
$instanceFilter.EventNamespace = 'root\cimv2'

$result = $instanceFilter.Put()
$filterResult = $result.Path

# Creating a new event consumer
$instanceConsumer = ([wmiclass]"\\.\root\subscription:CommandLineEventConsumer").CreateInstance()
$instanceConsumer.Name = 'BugSecConsumer'
$instanceConsumer.CommandLineTemplate = "cmd.exe /c echo test > c:\WMI-class.txt"

$result = $instanceConsumer.Put()
$consumerResult = $result.Path

# Bind filter and consumer
$instanceBinding = ([wmiclass]"\\.\root\subscription:__FilterToConsumerBinding").CreateInstance()
$instanceBinding.Filter = $filterResult
$instanceBinding.Consumer = $consumerResult

$result = $instanceBinding.Put()
