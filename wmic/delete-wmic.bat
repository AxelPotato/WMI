:: Delete instaces of WMI
wmic /NAMESPACE:"\\root\subscription" PATH __EventFilter WHERE Name="BugSecFilter" DELETE
wmic /NAMESPACE:"\\root\subscription" PATH CommandLineEventConsumer WHERE Name="BugSecConsumer" DELETE
wmic /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE Filter='\\\\.\\root\\subscription:__EventFilter.Name="BugSecFilter"' DELETE
