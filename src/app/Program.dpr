program NoteManagerApp;

uses
  Vcl.Forms,
  Winapi.Windows,
  MainForm in '..\presentation\forms\MainForm.pas' {frmMain},
  Note in '..\domain\Entities\Note.pas',
  Reminder in '..\domain\Entities\Reminder.pas',
  INoteRepository in '..\domain\Interfaces\INoteRepository.pas',
  IReminderService in '..\domain\Interfaces\IReminderService.pas',
  NoteManager in '..\domain\Services\NoteManager.pas',
  ReminderEngine in '..\domain\Services\ReminderEngine.pas',
  SQLiteConnection in '..\infrastructure\database\SQLiteConnection.pas',
  NoteRepositorySQLite in '..\infrastructure\database\NoteRepositorySQLite.pas',
  DatabaseInitializer in '..\infrastructure\database\DatabaseInitializer.pas',
  AutoStartManager in '..\infrastructure\os\AutoStartManager.pas',
  TrayManager in '..\infrastructure\os\TrayManager.pas',
  NotificationService in '..\infrastructure\notifications\NotificationService.pas',
  Logger in '..\infrastructure\logging\Logger.pas',
  AppConfig in 'AppConfig.pas',
  DependencyInjector in 'DependencyInjector.pas',
  CreateNoteUseCase in '..\application\UseCases\CreateNoteUseCase.pas',
  UpdateNoteUseCase in '..\application\UseCases\UpdateNoteUseCase.pas',
  DeleteNoteUseCase in '..\application\UseCases\DeleteNoteUseCase.pas',
  CheckRemindersUseCase in '..\application\UseCases\CheckRemindersUseCase.pas',
  NoteDTO in '..\application\DTO\NoteDTO.pas';

{$R *.res}

begin
  // Initialize dependency injection container
  TDependencyInjector.Initialize(GetCurrentDir);
  
  try
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.Title := 'Note Manager';
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    TDependencyInjector.Finalize;
  end;
end.
