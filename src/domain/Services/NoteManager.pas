unit NoteManager;

interface

uses
  Note,
  INoteRepository,
  System.Generics.Collections;

type
  TNoteManager = class
  private
    FRepository: INoteRepository;
  public
    constructor Create(const ARepository: INoteRepository);
    
    function GetNoteById(const AId: Integer): TNote;
    function GetAllNotes: TObjectList<TNote>;
    function GetActiveNotes: TObjectList<TNote>;
    function GetArchivedNotes: TObjectList<TNote>;
    function SearchNotes(const AQuery: string): TObjectList<TNote>;
    
    function CreateNote(const ATitle, AContent: string): TNote;
    procedure UpdateNote(const ANote: TNote);
    procedure DeleteNote(const AId: Integer);
    
    procedure ArchiveNote(const AId: Integer);
    procedure UnarchiveNote(const AId: Integer);
    
    function GetNoteCount: Integer;
  end;

implementation

uses
  System.SysUtils;

constructor TNoteManager.Create(const ARepository: INoteRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TNoteManager.GetNoteById(const AId: Integer): TNote;
begin
  Result := FRepository.GetById(AId);
end;

function TNoteManager.GetAllNotes: TObjectList<TNote>;
begin
  Result := FRepository.GetAll;
end;

function TNoteManager.GetActiveNotes: TObjectList<TNote>;
begin
  Result := FRepository.GetActive;
end;

function TNoteManager.GetArchivedNotes: TObjectList<TNote>;
begin
  Result := FRepository.GetArchived;
end;

function TNoteManager.SearchNotes(const AQuery: string): TObjectList<TNote>;
begin
  Result := FRepository.GetByTitle(AQuery);
end;

function TNoteManager.CreateNote(const ATitle, AContent: string): TNote;
var
  LNote: TNote;
begin
  LNote := TNote.Create;
  try
    LNote.Title := ATitle;
    LNote.Content := AContent;
    FRepository.Create(LNote);
    Result := LNote;
  except
    LNote.Free;
    raise;
  end;
end;

procedure TNoteManager.UpdateNote(const ANote: TNote);
begin
  ANote.UpdatedAt := Now;
  FRepository.Update(ANote);
end;

procedure TNoteManager.DeleteNote(const AId: Integer);
begin
  FRepository.Delete(AId);
end;

procedure TNoteManager.ArchiveNote(const AId: Integer);
begin
  FRepository.Archive(AId);
end;

procedure TNoteManager.UnarchiveNote(const AId: Integer);
begin
  FRepository.Unarchive(AId);
end;

function TNoteManager.GetNoteCount: Integer;
begin
  Result := FRepository.Count;
end;

end.
