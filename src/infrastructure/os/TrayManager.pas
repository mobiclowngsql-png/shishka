unit TrayManager;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TTrayClickEvent = procedure(Sender: TObject) of object;

  TTrayManager = class
  private
    FTrayIcon: TObject; // TTrayIcon in VCL
    FVisible: Boolean;
    FOnDoubleClick: TTrayClickEvent;
    FOnMenuShow: TTrayClickEvent;
    FOnMenuExit: TTrayClickEvent;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Show;
    procedure Hide;
    procedure SetHint(const AHint: string);
    procedure SetIcon(const AIconPath: string);
    
    property Visible: Boolean read FVisible;
    property OnDoubleClick: TTrayClickEvent read FOnDoubleClick write FOnDoubleClick;
    property OnMenuShow: TTrayClickEvent read FOnMenuShow write FOnMenuShow;
    property OnMenuExit: TTrayClickEvent read FOnMenuExit write FOnMenuExit;
  end;

implementation

{$IFDEF MSWINDOWS}
uses
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Menus,
  Winapi.Windows,
  Winapi.Messages;
{$ENDIF}

constructor TTrayManager.Create;
begin
  inherited Create;
  FVisible := False;
{$IFDEF MSWINDOWS}
  // In production: create TTrayIcon with context menu
  // FTrayIcon := TTrayIcon.Create(nil);
  // Setup menu items: Show, Exit
{$ENDIF}
end;

destructor TTrayManager.Destroy;
begin
{$IFDEF MSWINDOWS}
  if Assigned(FTrayIcon) then
  begin
    TComponent(FTrayIcon).Free;
    FTrayIcon := nil;
  end;
{$ENDIF}
  inherited;
end;

procedure TTrayManager.Show;
begin
{$IFDEF MSWINDOWS}
  if Assigned(FTrayIcon) then
  begin
    TTrayIcon(FTrayIcon).Visible := True;
    FVisible := True;
  end;
{$ELSE}
  FVisible := True;
{$ENDIF}
end;

procedure TTrayManager.Hide;
begin
{$IFDEF MSWINDOWS}
  if Assigned(FTrayIcon) then
  begin
    TTrayIcon(FTrayIcon).Visible := False;
    FVisible := False;
  end;
{$ELSE}
  FVisible := False;
{$ENDIF}
end;

procedure TTrayManager.SetHint(const AHint: string);
begin
{$IFDEF MSWINDOWS}
  if Assigned(FTrayIcon) then
    TTrayIcon(FTrayIcon).Hint := AHint;
{$ENDIF}
end;

procedure TTrayManager.SetIcon(const AIconPath: string);
begin
{$IFDEF MSWINDOWS}
  if Assigned(FTrayIcon) and FileExists(AIconPath) then
    TTrayIcon(FTrayIcon).Icon.LoadFromFile(AIconPath);
{$ENDIF}
end;

end.
