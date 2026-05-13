unit SettingsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, 
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmSettings = class(TForm)
    pnlMain: TPanel;
    grpGeneral: TGroupBox;
    chkAutoStart: TCheckBox;
    chkMinimizeToTray: TCheckBox;
    chkStartMinimized: TCheckBox;
    lblCheckInterval: TLabel;
    edtCheckInterval: TEdit;
    lblDatabasePath: TLabel;
    edtDatabasePath: TEdit;
    btnBrowseDB: TButton;
    grpAppearance: TGroupBox;
    lblLanguage: TLabel;
    cmbLanguage: TComboBox;
    lblTheme: TLabel;
    cmbTheme: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowseDBClick(Sender: TObject);
  private
    FConfig: TObject; // TAppConfig
    
    procedure LoadSettings;
    procedure SaveSettings;
  public
  end;

implementation

uses
  DependencyInjector,
  AppConfig,
  AutoStartManager,
  System.IOUtils;

{$R *.dfm}

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  FConfig := TDependencyInjector.Instance.GetConfig;
  
  // Populate language combo
  cmbLanguage.Items.Add('English');
  cmbLanguage.Items.Add('Русский');
  
  // Populate theme combo
  cmbTheme.Items.Add('Light');
  cmbTheme.Items.Add('Dark');
  
  LoadSettings;
end;

procedure TfrmSettings.LoadSettings;
var
  LConfig: TAppConfig;
begin
  LConfig := TAppConfig(FConfig);
  
  chkAutoStart.Checked := LConfig.AutoStart;
  chkMinimizeToTray.Checked := LConfig.MinimizeToTray;
  chkStartMinimized.Checked := LConfig.StartMinimized;
  edtCheckInterval.Text := IntToStr(LConfig.CheckInterval div 1000);
  edtDatabasePath.Text := LConfig.DatabasePath;
  
  if LConfig.Language = 'ru' then
    cmbLanguage.ItemIndex := 1
  else
    cmbLanguage.ItemIndex := 0;
    
  if LConfig.Theme = 'dark' then
    cmbTheme.ItemIndex := 1
  else
    cmbTheme.ItemIndex := 0;
end;

procedure TfrmSettings.SaveSettings;
var
  LConfig: TAppConfig;
  LAppPath: string;
begin
  LConfig := TAppConfig(FConfig);
  
  LConfig.AutoStart := chkAutoStart.Checked;
  LConfig.MinimizeToTray := chkMinimizeToTray.Checked;
  LConfig.StartMinimized := chkStartMinimized.Checked;
  LConfig.CheckInterval := StrToIntDef(edtCheckInterval.Text, 5) * 1000;
  LConfig.DatabasePath := edtDatabasePath.Text;
  
  if cmbLanguage.ItemIndex = 1 then
    LConfig.Language := 'ru'
  else
    LConfig.Language := 'en';
    
  if cmbTheme.ItemIndex = 1 then
    LConfig.Theme := 'dark'
  else
    LConfig.Theme := 'light';
  
  LConfig.Save;
  
  // Update auto-start in registry
  LAppPath := ParamStr(0);
  if LConfig.AutoStart then
    TAutoStartManager.Enable('NoteManager', LAppPath)
  else
    TAutoStartManager.Disable('NoteManager');
end;

procedure TfrmSettings.btnOKClick(Sender: TObject);
begin
  SaveSettings;
  ModalResult := mrOk;
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSettings.btnBrowseDBClick(Sender: TObject);
var
  LSaveDialog: TSaveDialog;
begin
  LSaveDialog := TSaveDialog.Create(Self);
  try
    LSaveDialog.Filter := 'SQLite Database|*.db|All Files|*.*';
    LSaveDialog.DefaultExt := 'db';
    if LSaveDialog.Execute then
      edtDatabasePath.Text := LSaveDialog.FileName;
  finally
    LSaveDialog.Free;
  end;
end;

end.
