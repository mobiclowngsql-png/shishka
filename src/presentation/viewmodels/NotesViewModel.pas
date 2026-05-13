unit NotesViewModel;

interface

uses
  Note,
  System.Generics.Collections,
  System.Classes;

type
  TNotesViewModel = class
  private
    FNotes: TObjectList<TNote>;
    FSelectedNote: TNote;
    FSearchQuery: string;
    FOnChange: TNotifyEvent;
    
    procedure SetSearchQuery(const Value: string);
    procedure SetSelectedNote(const Value: TNote);
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure LoadNotes(const ANotes: TObjectList<TNote>);
    procedure AddNote(const ANote: TNote);
    procedure UpdateNote(const ANote: TNote);
    procedure RemoveNote(const AId: Integer);
    
    function GetFilteredNotes: TObjectList<TNote>;
    
    property Notes: TObjectList<TNote> read FNotes;
    property SelectedNote: TNote read FSelectedNote write SetSelectedNote;
    property SearchQuery: string read FSearchQuery write SetSearchQuery;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  System.SysUtils;

constructor TNotesViewModel.Create;
begin
  inherited Create;
  FNotes := TObjectList<TNote>.Create(True);
  FSearchQuery := '';
end;

destructor TNotesViewModel.Destroy;
begin
  FNotes.Free;
  inherited;
end;

procedure TNotesViewModel.LoadNotes(const ANotes: TObjectList<TNote>);
var
  i: Integer;
begin
  FNotes.Clear;
  for i := 0 to ANotes.Count - 1 do
  begin
    FNotes.Add(ANotes[i]);
  end;
  
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TNotesViewModel.AddNote(const ANote: TNote);
begin
  FNotes.Add(ANote);
  
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TNotesViewModel.UpdateNote(const ANote: TNote);
var
  i: Integer;
begin
  for i := 0 to FNotes.Count - 1 do
  begin
    if FNotes[i].Id = ANote.Id then
    begin
      FNotes[i].Title := ANote.Title;
      FNotes[i].Content := ANote.Content;
      FNotes[i].UpdatedAt := ANote.UpdatedAt;
      Break;
    end;
  end;
  
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TNotesViewModel.RemoveNote(const AId: Integer);
var
  i: Integer;
begin
  for i := 0 to FNotes.Count - 1 do
  begin
    if FNotes[i].Id = AId then
    begin
      FNotes.Delete(i);
      Break;
    end;
  end;
  
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TNotesViewModel.GetFilteredNotes: TObjectList<TNote>;
var
  i: Integer;
begin
  Result := TObjectList<TNote>.Create(False); // Don't own objects
  
  if FSearchQuery.IsEmpty then
  begin
    // Return all
    for i := 0 to FNotes.Count - 1 do
      Result.Add(FNotes[i]);
  end
  else
  begin
    // Filter by title
    for i := 0 to FNotes.Count - 1 do
    begin
      if Pos(LowerCase(FSearchQuery), LowerCase(FNotes[i].Title)) > 0 then
        Result.Add(FNotes[i]);
    end;
  end;
end;

procedure TNotesViewModel.SetSearchQuery(const Value: string);
begin
  if FSearchQuery <> Value then
  begin
    FSearchQuery := Value;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TNotesViewModel.SetSelectedNote(const Value: TNote);
begin
  FSelectedNote := Value;
end;

end.
