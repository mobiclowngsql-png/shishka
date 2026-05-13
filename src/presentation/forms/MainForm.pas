unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, 
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ImgList;

type
  TfrmMain = class(TForm)
    pnlLeft: TPanel;
    pnlRight: TPanel;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    lstNotes: TListView;
    btnNew: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnArchive: TButton;
    edtSearch: TEdit;
    lblTitle: TLabel;
    memContent: TMemo;
    Splitter1: TSplitter;
    imgIcons: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnArchiveClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure lstNotesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
  private
    FViewModel: TObject; // TNotesViewModel
    FTrayManager: TObject; // TTrayManager
    FReminderEngine: TObject; // TReminderEngine
    
    procedure InitializeUI;
    procedure LoadNotes;
    procedure DisplayNote(const AId: Integer);
    procedure OnReminderTriggered(const AReminder: TObject);
    procedure OnViewModelChange(Sender: TObject);
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses
  DependencyInjector,
  NoteManager,
  NotesViewModel,
  TrayManager,
  ReminderEngine,
  NotificationService,
  AppConfig;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitializeUI;
  
  // Get dependencies
  FViewModel := TNotesViewModel.Create;
  TNotesViewModel(FViewModel).OnChange := OnViewModelChange;
  
  // Initialize tray manager
  FTrayManager := TTrayManager.Create;
  TTrayManager(FTrayManager).OnDoubleClick := 
    procedure(Sender: TObject)
    begin
      Show;
      BringToFront;
    end;
  TTrayManager(FTrayManager).Show;
  
  // Load notes from database
  LoadNotes;
  
  // Initialize reminder engine (optional - can be lazy loaded)
  // FReminderEngine := TReminderEngine.Create(...);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FReminderEngine) then
  begin
    TReminderEngine(FReminderEngine).Stop;
    TReminderEngine(FReminderEngine).Free;
  end;
  
  FViewModel.Free;
  FTrayManager.Free;
end;

procedure TfrmMain.InitializeUI;
begin
  Caption := 'Note Manager';
  WindowState := wsNormal;
  
  // Setup list view
  lstNotes.ViewStyle := vsReport;
  lstNotes.Columns.Add.Caption := 'Title';
  lstNotes.Columns.Add.Caption := 'Created';
  lstNotes.Columns[0].Width := 200;
  lstNotes.Columns[1].Width := 120;
end;

procedure TfrmMain.LoadNotes;
var
  LNotes: TObject; // TObjectList<TNote>
  i: Integer;
  LItem: TListItem;
begin
  // Get notes from domain layer
  LNotes := TDependencyInjector.Instance.GetNoteManager.GetAllNotes;
  try
    TNotesViewModel(FViewModel).LoadNotes(TObjectList<TNote>(LNotes));
  finally
    // Don't free - owned by viewModel
  end;
end;

procedure TfrmMain.DisplayNote(const AId: Integer);
var
  LNote: TObject; // TNote
begin
  LNote := TDependencyInjector.Instance.GetNoteManager.GetNoteById(AId);
  if Assigned(LNote) then
  begin
    TNotesViewModel(FViewModel).SelectedNote := TNote(LNote);
    memContent.Text := TNote(LNote).Content;
  end;
end;

procedure TfrmMain.OnReminderTriggered(const AReminder: TObject);
begin
  TNotificationService.ShowReminder(
    'Напоминание',
    TReminder(AReminder).Message
  );
end;

procedure TfrmMain.OnViewModelChange(Sender: TObject);
var
  LFiltered: TObjectList<TNote>;
  i: Integer;
  LItem: TListItem;
begin
  lstNotes.Items.Clear;
  
  LFiltered := TNotesViewModel(FViewModel).GetFilteredNotes;
  try
    for i := 0 to LFiltered.Count - 1 do
    begin
      LItem := lstNotes.Items.Add;
      LItem.Caption := LFiltered[i].Title;
      LItem.SubItems.Add(DateTimeToStr(LFiltered[i].CreatedAt));
      LItem.Data := Pointer(LFiltered[i].Id);
    end;
  finally
    LFiltered.Free; // Don't own items
  end;
end;

procedure TfrmMain.btnNewClick(Sender: TObject);
begin
  // Open NoteEditorForm in production
  ShowMessage('Создание новой заметки');
end;

procedure TfrmMain.btnEditClick(Sender: TObject);
begin
  if lstNotes.Selected <> nil then
    DisplayNote(Integer(lstNotes.Selected.Data))
  else
    ShowMessage('Выберите заметку для редактирования');
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var
  LId: Integer;
begin
  if lstNotes.Selected <> nil then
  begin
    if MessageDlg('Удалить заметку?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      LId := Integer(lstNotes.Selected.Data);
      TDependencyInjector.Instance.GetNoteManager.DeleteNote(LId);
      LoadNotes;
    end;
  end
  else
    ShowMessage('Выберите заметку для удаления');
end;

procedure TfrmMain.btnArchiveClick(Sender: TObject);
var
  LId: Integer;
begin
  if lstNotes.Selected <> nil then
  begin
    LId := Integer(lstNotes.Selected.Data);
    TDependencyInjector.Instance.GetNoteManager.ArchiveNote(LId);
    LoadNotes;
  end
  else
    ShowMessage('Выберите заметку для архивации');
end;

procedure TfrmMain.edtSearchChange(Sender: TObject);
begin
  TNotesViewModel(FViewModel).SearchQuery := edtSearch.Text;
  OnViewModelChange(FViewModel);
end;

procedure TfrmMain.lstNotesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Selected and Assigned(Item) then
    DisplayNote(Integer(Item.Data));
end;

end.
