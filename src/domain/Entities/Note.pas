unit Note;

interface

type
  TNote = class
  private
    FId: Integer;
    FTitle: string;
    FContent: string;
    FCreatedAt: TDateTime;
    FUpdatedAt: TDateTime;
    FIsArchived: Boolean;
    FHasReminder: Boolean;
    FReminderDate: TDateTime;
  public
    constructor Create;
    function ToDict: TStringList;
    procedure FromDict(const ADict: TStringList);
    
    property Id: Integer read FId write FId;
    property Title: string read FTitle write FTitle;
    property Content: string read FContent write FContent;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
    property IsArchived: Boolean read FIsArchived write FIsArchived;
    property HasReminder: Boolean read FHasReminder write FHasReminder;
    property ReminderDate: TDateTime read FReminderDate write FReminderDate;
  end;

implementation

uses
  System.SysUtils;

constructor TNote.Create;
begin
  inherited Create;
  FId := 0;
  FTitle := '';
  FContent := '';
  FCreatedAt := Now;
  FUpdatedAt := Now;
  FIsArchived := False;
  FHasReminder := False;
  FReminderDate := 0;
end;

function TNote.ToDict: TStringList;
begin
  Result := TStringList.Create;
  try
    Result.AddPair('Id', IntToStr(FId));
    Result.AddPair('Title', FTitle);
    Result.AddPair('Content', FContent);
    Result.AddPair('CreatedAt', DateTimeToStr(FCreatedAt));
    Result.AddPair('UpdatedAt', DateTimeToStr(FUpdatedAt));
    Result.AddPair('IsArchived', BoolToStr(FIsArchived, True));
    Result.AddPair('HasReminder', BoolToStr(FHasReminder, True));
    if FHasReminder then
      Result.AddPair('ReminderDate', DateTimeToStr(FReminderDate));
  except
    Result.Free;
    raise;
  end;
end;

procedure TNote.FromDict(const ADict: TStringList);
begin
  FId := StrToIntDef(ADict.Values['Id'], 0);
  FTitle := ADict.Values['Title'];
  FContent := ADict.Values['Content'];
  if ADict.IndexOfName('CreatedAt') >= 0 then
    FCreatedAt := StrToDateTimeDef(ADict.Values['CreatedAt'], Now);
  if ADict.IndexOfName('UpdatedAt') >= 0 then
    FUpdatedAt := StrToDateTimeDef(ADict.Values['UpdatedAt'], Now);
  if ADict.IndexOfName('IsArchived') >= 0 then
    FIsArchived := StrToBoolDef(ADict.Values['IsArchived'], False);
  if ADict.IndexOfName('HasReminder') >= 0 then
    FHasReminder := StrToBoolDef(ADict.Values['HasReminder'], False);
  if FHasReminder and (ADict.IndexOfName('ReminderDate') >= 0) then
    FReminderDate := StrToDateTimeDef(ADict.Values['ReminderDate'], 0);
end;

end.
