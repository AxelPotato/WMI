##Removing WMI Subscriptions using Remove-WMIObject
#Filter
Get-WMIObject -Namespace root\Subscription -Class __EventFilter -Filter "Name='BugSecFilter'" | 
Remove-WmiObject -Verbose
 
#Consumer
Get-WMIObject -Namespace root\Subscription -Class CommandLineEventConsumer -Filter "Name='BugSecConsumer'" | 
Remove-WmiObject -Verbose

#Consumer
Get-WMIObject -Namespace root\Subscription -Class ActiveScriptEventConsumer -Filter "Name='BugSecConsumer'" | 
Remove-WmiObject -Verbose
 
#Binding
Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding -Filter "__Path LIKE '%BugSecFilter%'"  | 
Remove-WmiObject -Verbose