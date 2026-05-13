unit Reminder;

interface

uses
  System.SysUtils;

type
  TReminder = class
  private
    FId: Integer;
    FNoteId: Integer;
    FMessage: string;
    FReminderDate: TDateTime;
    FIsTriggered: Boolean;
  public
    constructor Create;
    function ToDict: TStringList;
    procedure FromDict(const ADict: TStringList);
    
    property Id: Integer read FId write FId;
    property NoteId: Integer read FNoteId write FNoteId;
    property Message: string read FMessage write FMessage;
    property ReminderDate: TDateTime read FReminderDate write FReminderDate;
    property IsTriggered: Boolean read FIsTriggered write FIsTriggered;
  end;

implementation

constructor TReminder.Create;
begin
  inherited Create;
  FId := 0;
  FNoteId := 0;
  FMessage := '';
  FReminderDate := 0;
  FIsTriggered := False;
end;

function TReminder.ToDict: TStringList;
begin
  Result := TStringList.Create;
  try
    Result.AddPair('Id', IntToStr(FId));
    Result.AddPair('NoteId', IntToStr(FNoteId));
    Result.AddPair('Message', FMessage);
    Result.AddPair('ReminderDate', DateTimeToStr(FReminderDate));
    Result.AddPair('IsTriggered', BoolToStr(FIsTriggered, True));
  except
    Result.Free;
    raise;
  end;
end;

procedure TReminder.FromDict(const ADict: TStringList);
begin
  FId := StrToIntDef(ADict.Values['Id'], 0);
  FNoteId := StrToIntDef(ADict.Values['NoteId'], 0);
  FMessage := ADict.Values['Message'];
  if ADict.IndexOfName('ReminderDate') >= 0 then
    FReminderDate := StrToDateTimeDef(ADict.Values['ReminderDate'], 0);
  if ADict.IndexOfName('IsTriggered') >= 0 then
    FIsTriggered := StrToBoolDef(ADict.Values['IsTriggered'], False);
end;

end.
