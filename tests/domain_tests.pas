unit domain_tests;

interface

uses
  DUnitX.TestFramework,
  Note,
  Reminder;

type
  [TestFixture]
  TNoteTests = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    
    [Test]
    procedure TestNoteCreation;
    [Test]
    procedure TestNoteProperties;
    [Test]
    procedure TestNoteToDict;
    [Test]
    procedure TestNoteFromDict;
  end;

  [TestFixture]
  TReminderTests = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    
    [Test]
    procedure TestReminderCreation;
    [Test]
    procedure TestReminderProperties;
    [Test]
    procedure TestReminderIsTriggered;
  end;

implementation

procedure TNoteTests.Setup;
begin
end;

procedure TNoteTests.TearDown;
begin
end;

procedure TNoteTests.TestNoteCreation;
var
  LNote: TNote;
begin
  LNote := TNote.Create;
  try
    Assert.IsNotNull(LNote);
    Assert.AreEqual(0, LNote.Id);
    Assert.AreEqual('', LNote.Title);
    Assert.AreEqual('', LNote.Content);
    Assert.IsFalse(LNote.IsArchived);
    Assert.IsFalse(LNote.HasReminder);
  finally
    LNote.Free;
  end;
end;

procedure TNoteTests.TestNoteProperties;
var
  LNote: TNote;
  LTitle: string;
  LContent: string;
begin
  LNote := TNote.Create;
  try
    LTitle := 'Test Title';
    LContent := 'Test Content';
    
    LNote.Title := LTitle;
    LNote.Content := LContent;
    LNote.IsArchived := True;
    LNote.HasReminder := True;
    
    Assert.AreEqual(LTitle, LNote.Title);
    Assert.AreEqual(LContent, LNote.Content);
    Assert.IsTrue(LNote.IsArchived);
    Assert.IsTrue(LNote.HasReminder);
  finally
    LNote.Free;
  end;
end;

procedure TNoteTests.TestNoteToDict;
var
  LNote: TNote;
  LDict: TStringList;
begin
  LNote := TNote.Create;
  try
    LNote.Title := 'Test';
    LNote.Content := 'Content';
    
    LDict := LNote.ToDict;
    try
      Assert.IsNotNull(LDict);
      Assert.IsTrue(LDict.Count > 0);
      Assert.AreEqual('Test', LDict.Values['Title']);
      Assert.AreEqual('Content', LDict.Values['Content']);
    finally
      LDict.Free;
    end;
  finally
    LNote.Free;
  end;
end;

procedure TNoteTests.TestNoteFromDict;
var
  LNote: TNote;
  LDict: TStringList;
begin
  LNote := TNote.Create;
  try
    LDict := TStringList.Create;
    try
      LDict.AddPair('Title', 'From Dict');
      LDict.AddPair('Content', 'Dict Content');
      
      LNote.FromDict(LDict);
      
      Assert.AreEqual('From Dict', LNote.Title);
      Assert.AreEqual('Dict Content', LNote.Content);
    finally
      LDict.Free;
    end;
  finally
    LNote.Free;
  end;
end;

procedure TReminderTests.Setup;
begin
end;

procedure TReminderTests.TearDown;
begin
end;

procedure TReminderTests.TestReminderCreation;
var
  LReminder: TReminder;
begin
  LReminder := TReminder.Create;
  try
    Assert.IsNotNull(LReminder);
    Assert.AreEqual(0, LReminder.Id);
    Assert.AreEqual(0, LReminder.NoteId);
    Assert.AreEqual('', LReminder.Message);
    Assert.IsFalse(LReminder.IsTriggered);
  finally
    LReminder.Free;
  end;
end;

procedure TReminderTests.TestReminderProperties;
var
  LReminder: TReminder;
begin
  LReminder := TReminder.Create;
  try
    LReminder.NoteId := 123;
    LReminder.Message := 'Test Reminder';
    LReminder.IsTriggered := True;
    
    Assert.AreEqual(123, LReminder.NoteId);
    Assert.AreEqual('Test Reminder', LReminder.Message);
    Assert.IsTrue(LReminder.IsTriggered);
  finally
    LReminder.Free;
  end;
end;

procedure TReminderTests.TestReminderIsTriggered;
var
  LReminder: TReminder;
begin
  LReminder := TReminder.Create;
  try
    Assert.IsFalse(LReminder.IsTriggered);
    
    LReminder.IsTriggered := True;
    Assert.IsTrue(LReminder.IsTriggered);
    
    LReminder.IsTriggered := False;
    Assert.IsFalse(LReminder.IsTriggered);
  finally
    LReminder.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TNoteTests);
  TDUnitX.RegisterTestFixture(TReminderTests);
  
end.
