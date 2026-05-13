unit CreateNoteUseCase;

interface

uses
  Note,
  INoteRepository;

type
  TCreateNoteUseCase = class
  private
    FRepository: INoteRepository;
  public
    constructor Create(const ARepository: INoteRepository);
    function Execute(const ATitle, AContent: string): TNote;
  end;

implementation

constructor TCreateNoteUseCase.Create(const ARepository: INoteRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TCreateNoteUseCase.Execute(const ATitle, AContent: string): TNote;
begin
  Result := TNote.Create;
  try
    Result.Title := ATitle;
    Result.Content := AContent;
    FRepository.Create(Result);
  except
    Result.Free;
    raise;
  end;
end;

end.
