unit NotificationService;

interface

uses
  System.SysUtils;

type
  TNotificationType = (ntInfo, ntWarning, ntError, ntSuccess);

  TNotificationService = class
  public
    class procedure Show(const ATitle, AMessage: string; 
                         const ANotificationType: TNotificationType = ntInfo);
    class procedure ShowReminder(const ATitle, AMessage: string);
  end;

implementation

{$IFDEF MSWINDOWS}
uses
  Winapi.Windows,
  Winapi.Messages,
  Vcl.Forms;
{$ENDIF}

class procedure TNotificationService.Show(const ATitle, AMessage: string; 
                                          const ANotificationType: TNotificationType);
begin
{$IFDEF MSWINDOWS}
  // In production: use Windows Toast Notifications or custom tray balloon
  // For Windows 7/10 compatibility, use Shell_NotifyIcon
  
  case ANotificationType of
    ntInfo:
      // Show info notification
      ;
    ntWarning:
      // Show warning notification
      ;
    ntError:
      // Show error notification
      ;
    ntSuccess:
      // Show success notification
      ;
  end;
  
  // Fallback to simple message box for now
  // In production: replace with non-blocking notification
  MessageBox(0, PChar(AMessage), PChar(ATitle), MB_ICONINFORMATION or MB_TOPMOST);
{$ELSE}
  // Non-Windows fallback
  WriteLn(Format('[%s] %s: %s', 
    [GetEnumName(TypeInfo(TNotificationType), Ord(ANotificationType)), 
     ATitle, AMessage]));
{$ENDIF}
end;

class procedure TNotificationService.ShowReminder(const ATitle, AMessage: string);
begin
{$IFDEF MSWINDOWS}
  // Play system sound
  MessageBeep(MB_OK);
  
  // Show reminder notification (always on top)
  MessageBox(0, PChar(AMessage), PChar(ATitle), 
             MB_ICONEXCLAMATION or MB_TOPMOST or MB_SETFOREGROUND);
{$ELSE}
  WriteLn(Format('[REMINDER] %s: %s', [ATitle, AMessage]));
{$ENDIF}
end;

end.
