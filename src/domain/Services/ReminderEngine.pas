unit ReminderEngine;

interface

uses
  Reminder,
  IReminderService,
  System.Classes,
  System.SysUtils;

type
  TOnReminderTriggered = procedure(const AReminder: TReminder) of object;

  TReminderEngine = class(TThread)
  private
    FReminderService: IReminderService;
    FCheckInterval: Cardinal;
    FOnReminderTriggered: TOnReminderTriggered;
    FStopped: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(const AReminderService: IReminderService; 
                       const ACheckInterval: Cardinal = 5000);
    
    procedure Stop;
    
    property OnReminderTriggered: TOnReminderTriggered 
      read FOnReminderTriggered write FOnReminderTriggered;
  end;

implementation

constructor TReminderEngine.Create(const AReminderService: IReminderService; 
                                   const ACheckInterval: Cardinal);
begin
  inherited Create(True); // Start suspended
  FreeOnTerminate := False;
  FReminderService := AReminderService;
  FCheckInterval := ACheckInterval;
  FStopped := False;
end;

procedure TReminderEngine.Execute;
var
  LPendingReminders: TObjectList<TReminder>;
  LReminder: TReminder;
  i: Integer;
begin
  while not FStopped and not Terminated do
  begin
    try
      LPendingReminders := FReminderService.GetPending;
      try
        for i := 0 to LPendingReminders.Count - 1 do
        begin
          if FStopped or Terminated then
            Break;
            
          LReminder := LPendingReminders[i];
          
          if LReminder.ReminderDate <= Now then
          begin
            if Assigned(FOnReminderTriggered) then
            begin
              Synchronize(
                procedure
                begin
                  FOnReminderTriggered(LReminder);
                end
              );
            end;
            
            FReminderService.MarkAsTriggered(LReminder.Id);
          end;
        end;
      finally
        LPendingReminders.Free;
      end;
      
      if not FStopped and not Terminated then
        WaitForSingleObject(0, FCheckInterval);
        
    except
      on E: Exception do
      begin
        // Log error here in production
        if not FStopped and not Terminated then
          WaitForSingleObject(0, FCheckInterval);
      end;
    end;
  end;
end;

procedure TReminderEngine.Stop;
begin
  FStopped := True;
  Terminate;
  WaitFor;
end;

end.
