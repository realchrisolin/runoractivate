; ===========================================================================
; Run a program or switch to it if already running.
;    Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
;    WinTitle - Optional title of the window to activate.  Programs like
;    MS Outlook might have multiple windows open (main window and email
;    windows).  This parm allows activating a specific window.
; ===========================================================================
SetWorkingDir = "C:\Users\Colin"

;RunOrActivate(Target, Parameters = "", WinTitle = "")
RunOrActivate(Target, WinTitle = "", Parameters = "")
{
   ; Get the filename without a path
   SplitPath, Target, TargetNameOnly

   Process, Exist, %TargetNameOnly%
   If ErrorLevel > 0
      PID = %ErrorLevel%
   Else
      Run, %Target% "%Parameters%", , , PID

   ; At least one app (Seapine TestTrack wouldn't always become the active
   ; window after using Run), so we always force a window activate.
   ; Activate by title if given, otherwise use PID.
   If WinTitle <> 
   {
      SetTitleMatchMode, 2
      WinWait, %WinTitle%, , 3
      TrayTip, , Activating Window Title "%WinTitle%" (%TargetNameOnly%)
      WinActivate, %WinTitle%
   }
   Else
   {
      WinWait, ahk_pid %PID%, , 3
      TrayTip, , Activating PID %PID% (%TargetNameOnly%)
      WinActivate, ahk_pid %PID%
   }


   SetTimer, RunOrActivateTrayTipOff, 1
}

; Turn off the tray tip
RunOrActivateTrayTipOff:
   SetTimer, RunOrActivateTrayTipOff, off
   TrayTip
Return
; Example uses...
F12::RunOrActivate("C:\cygwin64\bin\mintty.exe","","-")
;^F11::RunOrActivate("C:\Program Files\Mozilla Firefox\firefox.exe")
;NumpadDown::RunOrActivate("C:\Program Files\Internet Explorer\iexplore.exe") 
;NumpadPgDn::RunOrActivate("C:\Program Files\Notepad++\notepad++.exe")
;NumpadRight::RunOrActivate("C:\Program Files\Pidgin\pidgin.exe", "cevista") 
; Outlook can have multiple child windows, so specify which window to activate 
;NumpadClear::RunOrActivate("C:\Program Files\Microsoft Office\OFFICE12\OUTLOOK.EXE","Microsoft Outlook")
;Minimize/maximize active window
;^Down::WinMinimize, A
;^Up::WinRestore, A
;^+Up::WinMaximize, A
;!.::Send {Volume_Mute}
;^+Insert::Send {Media_Play_Pause}
;^+Up::Send {Volume_Up}
;^+Down::Send {Volume_Down}
;^+Left::Send {Media_Prev}
;^+Right::Send {Media_Next}