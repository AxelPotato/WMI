Dim fso, MyFile
Set fso = CreateObject("Scripting.FileSystemObject")
Set MyFile = fso.CreateTextFile("c:\\WMI-Powershell-vbs.txt", True)
MyFile.WriteLine("test")
MyFile.Close