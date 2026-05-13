unit DependencyInjector;

interface

uses
  INoteRepository,
  IReminderService,
  NoteManager,
  ReminderEngine,
  AppConfig;

type
  TDependencyInjector = class
  private
    FConfig: TAppConfig;
    FNoteRepository: INoteRepository;
    FNoteManager: TNoteManager;
    FReminderEngine: TReminderEngine;
    FLogger: TObject; // TLogger
    
    class var FInstance: TDependencyInjector;
    
    constructor Create;
  public
    destructor Destroy; override;
    
    class function Instance: TDependencyInjector;
    class procedure Initialize(const ABasePath: string);
    class procedure Finalize;
    
    function GetConfig: TAppConfig;
    function GetNoteRepository: INoteRepository;
    function GetNoteManager: TNoteManager;
    function GetReminderEngine: TReminderEngine;
    function GetLogger: TObject;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  SQLiteConnection,
  NoteRepositorySQLite,
  DatabaseInitializer,
  Logger;

constructor TDependencyInjector.Create;
var
  LDBPath: string;
  LConnection: TSQLiteConnection;
begin
  inherited Create;
  
  // Initialize configuration
  FConfig := TAppConfig.Create(
    IncludeTrailingPathDelimiter(GetCurrentDir) + 'config.json'
  );
  
  // Setup database path
  if FConfig.DatabasePath.IsEmpty then
  begin
    LDBPath := IncludeTrailingPathDelimiter(GetCurrentDir) + 'database\notes.db';
    FConfig.DatabasePath := LDBPath;
    FConfig.Save;
  end
  else
    LDBPath := FConfig.DatabasePath;
  
  // Initialize logger
  FLogger := TLogger.Create(
    IncludeTrailingPathDelimiter(GetCurrentDir) + 'logs\app.log'
  );
  
  // Initialize database
  TDatabaseInitializer.Initialize(LDBPath);
  
  // Create SQLite connection
  LConnection := TSQLiteConnection.Create(LDBPath);
  LConnection.Connect;
  
  // Create repository
  FNoteRepository := TNoteRepositorySQLite.Create(LConnection);
  
  // Create domain services
  FNoteManager := TNoteManager.Create(FNoteRepository);
  
  // Reminder engine will be started by MainForm
  FReminderEngine := nil;
end;

destructor TDependencyInjector.Destroy;
begin
  if Assigned(FReminderEngine) then
  begin
    FReminderEngine.Stop;
    FReminderEngine.Free;
  end;
  
  FNoteManager.Free;
  FConfig.Free;
  
  if Assigned(FLogger) then
    TLogger(FLogger).Free;
    
  inherited;
end;

class function TDependencyInjector.Instance: TDependencyInjector;
begin
  if not Assigned(FInstance) then
    raise Exception.Create('DependencyInjector not initialized. Call Initialize first.');
  Result := FInstance;
end;

class procedure TDependencyInjector.Initialize(const ABasePath: string);
begin
  if not Assigned(FInstance) then
  begin
    FInstance := TDependencyInjector.Create;
  end;
end;

class procedure TDependencyInjector.Finalize;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

function TDependencyInjector.GetConfig: TAppConfig;
begin
  Result := FConfig;
end;

function TDependencyInjector.GetNoteRepository: INoteRepository;
begin
  Result := FNoteRepository;
end;

function TDependencyInjector.GetNoteManager: TNoteManager;
begin
  Result := FNoteManager;
end;

function TDependencyInjector.GetReminderEngine: TReminderEngine;
begin
  if not Assigned(FReminderEngine) then
  begin
    // Lazy initialization
    // FReminderEngine := TReminderEngine.Create(
    //   FReminderService, 
    //   FConfig.CheckInterval
    // );
    // FReminderEngine.Start;
  end;
  Result := FReminderEngine;
end;

function TDependencyInjector.GetLogger: TObject;
begin
  Result := FLogger;
end;

initialization
finalization
  TDependencyInjector.Finalize;

end.
