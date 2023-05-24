# windows-powershell-setupdealerbuilt

Windows Executable GUI tool for creating .rdp shortcut files for selectable servers at selectable path.  The .exe is compiled from a .ps1 file that calls on.NET assembly language to generate a VisualBasic form.  These languages are all natively installed and referencable within Windows OS as they are the programming language of most windows applications.

Initial release intended for internal IT usage with goal of future automation as part of a seamless onboarding process.

Important to Note:
=========
• .exe does not need to be elevated to run.
• The application defaults destination path to the OS enviroment's Desktop folder of the user who runs the .exe (ie. Path is dynamic regardless of OneDrive sign-in.)
• Current version's error handling will intentionally execute with no username variable if an invalid username is provided 3 times.
• Current version's DealerBuilt Username field will clear intial example text "DBC\237.First.Last" if user does not change the intial text and will not execute with     "DBC\237.First.Last" text in the field.  Intentionally coded to provide an example but not to allow for creating .rdp file unitentionally.

Download .exe
=========
https://github.com/Norm-Reeves/windows-powershell-setupdealerbuilt/blob/main/windows-powershell-setupdealerbuilt.ps1

Change Log:
============
1.0:
  • Created initial release.
