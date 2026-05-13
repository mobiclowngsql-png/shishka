unit CheckRemindersUseCase;

interface

uses
  Reminder,
  IReminderService,
  System.Generics.Collections;

type
  TCheckRemindersUseCase = class
  private
    FReminderService: IReminderService;
  public
    constructor Create(const AReminderService: IReminderService);
    function Execute: TObjectList<TReminder>;
  end;

implementation

constructor TCheckRemindersUseCase.Create(const AReminderService: IReminderService);
begin
  inherited Create;
  FReminderService := AReminderService;
end;

function TCheckRemindersUseCase.Execute: TObjectList<TReminder>;
var
  LPendingReminders: TObjectList<TReminder>;
  i: Integer;
begin
  Result := TObjectList<TReminder>.Create(True);
  
  LPendingReminders := FReminderService.GetPending;
  try
    for i := 0 to LPendingReminders.Count - 1 do
    begin
      if LPendingReminders[i].ReminderDate <= Now then
      begin
        // Clone reminder to avoid ownership issues
        Result.Add(TReminder.Create);
        Result.Last.Id := LPendingReminders[i].Id;
        Result.Last.NoteId := LPendingReminders[i].NoteId;
        Result.Last.Message := LPendingReminders[i].Message;
        Result.Last.ReminderDate := LPendingReminders[i].ReminderDate;
        
        FReminderService.MarkAsTriggered(LPendingReminders[i].Id);
      end;
    end;
  finally
    LPendingReminders.Free;
  end;
end;

end.
