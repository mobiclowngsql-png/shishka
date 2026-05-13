unit Logger;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TLogLevel = (llDebug, llInfo, llWarning, llError, llFatal);

  TLogger = class
  private
    FLogPath: string;
    FLogFile: TStringList;
    FLock: TCriticalSection;
    FMinLevel: TLogLevel;
    
    procedure WriteLog(const ALevel: TLogLevel; const AMessage: string);
  public
    constructor Create(const ALogPath: string);
    destructor Destroy; override;
    
    procedure Debug(const AMessage: string);
    procedure Info(const AMessage: string);
    procedure Warning(const AMessage: string);
    procedure Error(const AMessage: string; const AException: Exception = nil);
    procedure Fatal(const AMessage: string; const AException: Exception = nil);
    
    procedure Clear;
    
    property MinLevel: TLogLevel read FMinLevel write FMinLevel;
  end;

implementation

uses
  System.IOUtils;

constructor TLogger.Create(const ALogPath: string);
begin
  inherited Create;
  FLogPath := ALogPath;
  FLogFile := TStringList.Create;
  FLock := TCriticalSection.Create;
  FMinLevel := llInfo;
  
  // Ensure log directory exists
  if not DirectoryExists(ExtractFilePath(FLogPath)) then
    ForceDirectories(ExtractFilePath(FLogPath));
end;

destructor TLogger.Destroy;
begin
  FLock.Free;
  FLogFile.Free;
  inherited;
end;

procedure TLogger.WriteLog(const ALevel: TLogLevel; const AMessage: string);
var
  LLevelStr: string;
  LTimeStamp: string;
  LLogLine: string;
begin
  if ALevel < FMinLevel then
    Exit;
    
  FLock.Enter;
  try
    case ALevel of
      llDebug: LLevelStr := 'DEBUG';
      llInfo: LLevelStr := 'INFO';
      llWarning: LLevelStr := 'WARNING';
      llError: LLevelStr := 'ERROR';
      llFatal: LLevelStr := 'FATAL';
    else
      LLevelStr := 'UNKNOWN';
    end;
    
    LTimeStamp := DateTimeToStr(Now);
    LLogLine := Format('%s [%s] %s', [LTimeStamp, LLevelStr, AMessage]);
    
    // Append to file
    try
      FLogFile.Append(LLogLine);
    except
      // Silent fail to prevent cascading errors
    end;
    
  finally
    FLock.Leave;
  end;
end;

procedure TLogger.Debug(const AMessage: string);
begin
  WriteLog(llDebug, AMessage);
end;

procedure TLogger.Info(const AMessage: string);
begin
  WriteLog(llInfo, AMessage);
end;

procedure TLogger.Warning(const AMessage: string);
begin
  WriteLog(llWarning, AMessage);
end;

procedure TLogger.Error(const AMessage: string; const AException: Exception);
var
  LFullMessage: string;
begin
  LFullMessage := AMessage;
  if Assigned(AException) then
    LFullMessage := LFullMessage + ' | Exception: ' + AException.Message;
  WriteLog(llError, LFullMessage);
end;

procedure TLogger.Fatal(const AMessage: string; const AException: Exception);
var
  LFullMessage: string;
begin
  LFullMessage := AMessage;
  if Assigned(AException) then
    LFullMessage := LFullMessage + ' | Exception: ' + AException.Message;
  WriteLog(llFatal, LFullMessage);
end;

procedure TLogger.Clear;
begin
  FLock.Enter;
  try
    if FileExists(FLogPath) then
      DeleteFile(FLogPath);
  finally
    FLock.Leave;
  end;
end;

initialization
finalization

end.
