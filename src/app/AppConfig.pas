unit AppConfig;

interface

uses
  System.SysUtils;

type
  TAppConfig = class
  private
    FConfigPath: string;
    FAutoStart: Boolean;
    FCheckInterval: Integer;
    FDatabasePath: string;
    FLanguage: string;
    FTheme: string;
    FMinimizeToTray: Boolean;
    FStartMinimized: Boolean;
    
    procedure Load;
    procedure Save;
  public
    constructor Create(const AConfigPath: string);
    
    property AutoStart: Boolean read FAutoStart write FAutoStart;
    property CheckInterval: Integer read FCheckInterval write FCheckInterval;
    property DatabasePath: string read FDatabasePath write FDatabasePath;
    property Language: string read FLanguage write FLanguage;
    property Theme: string read FTheme write FTheme;
    property MinimizeToTray: Boolean read FMinimizeToTray write FMinimizeToTray;
    property StartMinimized: Boolean read FStartMinimized write FStartMinimized;
    
    procedure Reload;
  end;

implementation

uses
  System.IOUtils,
  System.JSON;

constructor TAppConfig.Create(const AConfigPath: string);
begin
  inherited Create;
  FConfigPath := AConfigPath;
  
  // Set defaults
  FAutoStart := False;
  FCheckInterval := 5000; // 5 seconds
  FDatabasePath := '';
  FLanguage := 'en';
  FTheme := 'light';
  FMinimizeToTray := True;
  FStartMinimized := False;
  
  Load;
end;

procedure TAppConfig.Load;
var
  LJSON: TStringStream;
  LJSONObject: TJSONObject;
  LJSONValue: TJSONValue;
begin
  if not FileExists(FConfigPath) then
  begin
    Save;
    Exit;
  end;
  
  try
    LJSON := TStringStream.Create;
    try
      LJSON.LoadFromFile(FConfigPath);
      
      LJSONObject := TJSONObject.ParseJSONValue(LJSON.DataString) as TJSONObject;
      if Assigned(LJSONObject) then
      try
        LJSONValue := LJSONObject.GetValue('AutoStart');
        if Assigned(LJSONValue) then
          FAutoStart := (LJSONValue as TJSONBool).AsBoolean;
          
        LJSONValue := LJSONObject.GetValue('CheckInterval');
        if Assigned(LJSONValue) then
          FCheckInterval := (LJSONValue as TJSONNumber).AsInt;
          
        LJSONValue := LJSONObject.GetValue('DatabasePath');
        if Assigned(LJSONValue) then
          FDatabasePath := LJSONValue.Value;
          
        LJSONValue := LJSONObject.GetValue('Language');
        if Assigned(LJSONValue) then
          FLanguage := LJSONValue.Value;
          
        LJSONValue := LJSONObject.GetValue('Theme');
        if Assigned(LJSONValue) then
          FTheme := LJSONValue.Value;
          
        LJSONValue := LJSONObject.GetValue('MinimizeToTray');
        if Assigned(LJSONValue) then
          FMinimizeToTray := (LJSONValue as TJSONBool).AsBoolean;
          
        LJSONValue := LJSONObject.GetValue('StartMinimized');
        if Assigned(LJSONValue) then
          FStartMinimized := (LJSONValue as TJSONBool).AsBoolean;
          
      finally
        LJSONObject.Free;
      end;
    finally
      LJSON.Free;
    end;
  except
    on E: Exception do
    begin
      // Use defaults if config is corrupted
      Save;
    end;
  end;
end;

procedure TAppConfig.Save;
var
  LJSON: TJSONObject;
  LJSONString: string;
begin
  try
    LJSON := TJSONObject.Create;
    try
      LJSON.AddPair('AutoStart', TJSONBool.Create(FAutoStart));
      LJSON.AddPair('CheckInterval', TJSONNumber.Create(FCheckInterval));
      LJSON.AddPair('DatabasePath', FDatabasePath);
      LJSON.AddPair('Language', FLanguage);
      LJSON.AddPair('Theme', FTheme);
      LJSON.AddPair('MinimizeToTray', TJSONBool.Create(FMinimizeToTray));
      LJSON.AddPair('StartMinimized', TJSONBool.Create(FStartMinimized));
      
      LJSONString := LJSON.ToString;
      
      // Ensure directory exists
      if not DirectoryExists(ExtractFilePath(FConfigPath)) then
        ForceDirectories(ExtractFilePath(FConfigPath));
      
      // Write to file
      TStringStream.Create(LJSONString).SaveToFile(FConfigPath);
    finally
      LJSON.Free;
    end;
  except
    // Silent fail - app can work with defaults
  end;
end;

procedure TAppConfig.Reload;
begin
  Load;
end;

end.
