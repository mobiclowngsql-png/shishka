unit DeleteNoteUseCase;

interface

uses
  INoteRepository;

type
  TDeleteNoteUseCase = class
  private
    FRepository: INoteRepository;
  public
    constructor Create(const ARepository: INoteRepository);
    procedure Execute(const AId: Integer);
  end;

implementation

constructor TDeleteNoteUseCase.Create(const ARepository: INoteRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

procedure TDeleteNoteUseCase.Execute(const AId: Integer);
begin
  FRepository.Delete(AId);
end;

end.
