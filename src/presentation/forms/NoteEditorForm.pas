unit NoteEditorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, 
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmNoteEditor = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    edtTitle: TEdit;
    memContent: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    chkHasReminder: TCheckBox;
    dtpReminder: TDateTimePicker;
    lblTitle: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure chkHasReminderClick(Sender: TObject);
  private
    FNoteId: Integer;
    FIsNew: Boolean;
    
    function Validate: Boolean;
    procedure Save;
  public
    property NoteId: Integer read FNoteId write FNoteId;
    property IsNew: Boolean read FIsNew write FIsNew;
    
    class function EditNote(const ANoteId: Integer): Boolean;
    class function CreateNote: Boolean;
  end;

implementation

uses
  DependencyInjector,
  NoteManager,
  Note;

{$R *.dfm}

procedure TfrmNoteEditor.FormCreate(Sender: TObject);
begin
  if not FIsNew and (FNoteId > 0) then
  begin
    // Load existing note
    // In production: load from repository via DI
  end;
  
  dtpReminder.Enabled := chkHasReminder.Checked;
end;

procedure TfrmNoteEditor.btnOKClick(Sender: TObject);
begin
  if Validate then
  begin
    Save;
    ModalResult := mrOk;
  end;
end;

procedure TfrmNoteEditor.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmNoteEditor.chkHasReminderClick(Sender: TObject);
begin
  dtpReminder.Enabled := chkHasReminder.Checked;
end;

function TfrmNoteEditor.Validate: Boolean;
begin
  Result := True;
  
  if edtTitle.Text.Trim.IsEmpty then
  begin
    ShowMessage('Введите заголовок');
    edtTitle.SetFocus;
    Result := False;
    Exit;
  end;
  
  if chkHasReminder.Checked and (dtpReminder.DateTime <= Now) then
  begin
    ShowMessage('Дата напоминания должна быть в будущем');
    dtpReminder.SetFocus;
    Result := False;
    Exit;
  end;
end;

procedure TfrmNoteEditor.Save;
var
  LNote: TNote;
  LNoteManager: TNoteManager;
begin
  LNoteManager := TDependencyInjector.Instance.GetNoteManager;
  
  if FIsNew then
  begin
    // Create new note
    LNote := LNoteManager.CreateNote(edtTitle.Text, memContent.Text);
    try
      if chkHasReminder.Checked then
      begin
        LNote.HasReminder := True;
        LNote.ReminderDate := dtpReminder.DateTime;
        LNoteManager.UpdateNote(LNote);
      end;
    finally
      LNote.Free;
    end;
  end
  else
  begin
    // Update existing note
    LNote := LNoteManager.GetNoteById(FNoteId);
    try
      LNote.Title := edtTitle.Text;
      LNote.Content := memContent.Text;
      LNote.HasReminder := chkHasReminder.Checked;
      if chkHasReminder.Checked then
        LNote.ReminderDate := dtpReminder.DateTime;
      LNoteManager.UpdateNote(LNote);
    finally
      LNote.Free;
    end;
  end;
end;

class function TfrmNoteEditor.EditNote(const ANoteId: Integer): Boolean;
var
  LForm: TfrmNoteEditor;
begin
  LForm := TfrmNoteEditor.Create(Application);
  try
    LForm.FNoteId := ANoteId;
    LForm.FIsNew := False;
    LForm.Caption := 'Редактирование заметки';
    Result := LForm.ShowModal = mrOk;
  finally
    LForm.Free;
  end;
end;

class function TfrmNoteEditor.CreateNote: Boolean;
var
  LForm: TfrmNoteEditor;
begin
  LForm := TfrmNoteEditor.Create(Application);
  try
    LForm.FNoteId := 0;
    LForm.FIsNew := True;
    LForm.Caption := 'Новая заметка';
    Result := LForm.ShowModal = mrOk;
  finally
    LForm.Free;
  end;
end;

end.
