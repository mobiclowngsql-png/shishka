unit AutoStartManager;

interface

type
  TAutoStartManager = class
  public
    class procedure Enable(const AAppName, AAppPath: string);
    class procedure Disable(const AAppName: string);
    class function IsEnabled(const AAppName: string): Boolean;
  end;

implementation

uses
  System.SysUtils,
{$IFDEF MSWINDOWS}
  Winapi.Windows,
  Winapi.Registry,
{$ENDIF}
  System.IOUtils;

const
  RUN_KEY = 'Software\Microsoft\Windows\CurrentVersion\Run';

class procedure TAutoStartManager.Enable(const AAppName, AAppPath: string);
{$IFDEF MSWINDOWS}
var
  LReg: TRegistry;
begin
  LReg := TRegistry.Create(KEY_WRITE);
  try
    LReg.RootKey := HKEY_CURRENT_USER;
    if LReg.OpenKey(RUN_KEY, True) then
    begin
      LReg.WriteString(AAppName, '"' + AAppPath + '"');
      LReg.CloseKey;
    end;
  finally
    LReg.Free;
  end;
end;
{$ELSE}
begin
  // Not supported on non-Windows platforms
  Raise Exception.Create('AutoStart is only supported on Windows');
end;
{$ENDIF}

class procedure TAutoStartManager.Disable(const AAppName: string);
{$IFDEF MSWINDOWS}
var
  LReg: TRegistry;
begin
  LReg := TRegistry.Create(KEY_WRITE);
  try
    LReg.RootKey := HKEY_CURRENT_USER;
    if LReg.OpenKey(RUN_KEY, False) then
    begin
      if LReg.ValueExists(AAppName) then
        LReg.DeleteValue(AAppName);
      LReg.CloseKey;
    end;
  finally
    LReg.Free;
  end;
end;
{$ELSE}
begin
  Raise Exception.Create('AutoStart is only supported on Windows');
end;
{$ENDIF}

class function TAutoStartManager.IsEnabled(const AAppName: string): Boolean;
{$IFDEF MSWINDOWS}
var
  LReg: TRegistry;
begin
  Result := False;
  LReg := TRegistry.Create(KEY_READ);
  try
    LReg.RootKey := HKEY_CURRENT_USER;
    if LReg.OpenKeyReadOnly(RUN_KEY) then
    begin
      Result := LReg.ValueExists(AAppName);
      LReg.CloseKey;
    end;
  finally
    LReg.Free;
  end;
end;
{$ELSE}
begin
  Result := False;
end;
{$ENDIF}

end.
