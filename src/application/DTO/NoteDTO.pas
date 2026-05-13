unit NoteDTO;

interface

type
  TNoteDTO = record
    Id: Integer;
    Title: string;
    Content: string;
    CreatedAt: TDateTime;
    UpdatedAt: TDateTime;
    IsArchived: Boolean;
    HasReminder: Boolean;
    ReminderDate: TDateTime;
    
    function ToDisplayString: string;
    class function FromInts(const AId: Integer; const ATitle, AContent: string): TNoteDTO; static;
  end;

implementation

uses
  System.SysUtils;

function TNoteDTO.ToDisplayString: string;
begin
  Result := Format('%d. %s (%s)', [Id, Title, DateTimeToStr(CreatedAt)]);
end;

class function TNoteDTO.FromInts(const AId: Integer; const ATitle, AContent: string): TNoteDTO;
begin
  Result.Id := AId;
  Result.Title := ATitle;
  Result.Content := AContent;
  Result.CreatedAt := Now;
  Result.UpdatedAt := Now;
  Result.IsArchived := False;
  Result.HasReminder := False;
  Result.ReminderDate := 0;
end;

end.
