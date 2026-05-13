unit UpdateNoteUseCase;

interface

uses
  Note,
  INoteRepository;

type
  TUpdateNoteUseCase = class
  private
    FRepository: INoteRepository;
  public
    constructor Create(const ARepository: INoteRepository);
    procedure Execute(const ANote: TNote);
  end;

implementation

constructor TUpdateNoteUseCase.Create(const ARepository: INoteRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

procedure TUpdateNoteUseCase.Execute(const ANote: TNote);
begin
  ANote.UpdatedAt := Now;
  FRepository.Update(ANote);
end;

end.
