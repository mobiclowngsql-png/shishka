unit repository_tests;

interface

uses
  DUnitX.TestFramework,
  INoteRepository,
  Note,
  System.Generics.Collections;

type
  [TestFixture]
  TNoteRepositoryTests = class
  private
    FRepository: INoteRepository;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    
    [Test]
    procedure TestRepositoryCreate;
    [Test]
    procedure TestRepositoryGetById;
    [Test]
    procedure TestRepositoryGetAll;
    [Test]
    procedure TestRepositoryUpdate;
    [Test]
    procedure TestRepositoryDelete;
    [Test]
    procedure TestRepositoryArchive;
    [Test]
    procedure TestRepositoryCount;
  end;

implementation

uses
  NoteRepositorySQLite,
  SQLiteConnection,
  System.IOUtils;

procedure TNoteRepositoryTests.Setup;
var
  LDBPath: string;
  LConnection: TSQLiteConnection;
begin
  // Create test database in temp location
  LDBPath := TPath.GetTempPath + 'test_notes.db';
  
  // Delete if exists
  if FileExists(LDBPath) then
    DeleteFile(LDBPath);
  
  // Create connection and initialize
  LConnection := TSQLiteConnection.Create(LDBPath);
  try
    LConnection.Connect;
    FRepository := TNoteRepositorySQLite.Create(LConnection);
  finally
    // Connection is owned by repository in production
    // For tests, we keep it separate
  end;
end;

procedure TNoteRepositoryTests.TearDown;
var
  LDBPath: string;
begin
  FRepository := nil;
  
  // Cleanup test database
  LDBPath := TPath.GetTempPath + 'test_notes.db';
  if FileExists(LDBPath) then
    DeleteFile(LDBPath);
end;

procedure TNoteRepositoryTests.TestRepositoryCreate;
var
  LNote: TNote;
  LId: Integer;
begin
  LNote := TNote.Create;
  try
    LNote.Title := 'Test Note';
    LNote.Content := 'Test Content';
    
    LId := FRepository.Create(LNote);
    
    Assert.IsTrue(LId > 0);
    Assert.AreEqual(LId, LNote.Id);
  finally
    LNote.Free;
  end;
end;

procedure TNoteRepositoryTests.TestRepositoryGetById;
var
  LNote: TNote;
  LRetrieved: TNote;
  LId: Integer;
begin
  // Create note first
  LNote := TNote.Create;
  try
    LNote.Title := 'GetById Test';
    LNote.Content := 'Content for GetById';
    LId := FRepository.Create(LNote);
  finally
    LNote.Free;
  end;
  
  // Retrieve by ID
  LRetrieved := FRepository.GetById(LId);
  try
    Assert.IsNotNull(LRetrieved);
    Assert.AreEqual('GetById Test', LRetrieved.Title);
    Assert.AreEqual('Content for GetById', LRetrieved.Content);
  finally
    LRetrieved.Free;
  end;
end;

procedure TNoteRepositoryTests.TestRepositoryGetAll;
var
  LNotes: TObjectList<TNote>;
  LNote1, LNote2: TNote;
begin
  // Create multiple notes
  LNote1 := TNote.Create;
  LNote2 := TNote.Create;
  try
    LNote1.Title := 'Note 1';
    LNote2.Title := 'Note 2';
    
    FRepository.Create(LNote1);
    FRepository.Create(LNote2);
    
    // Get all
    LNotes := FRepository.GetAll;
    try
      Assert.IsNotNull(LNotes);
      Assert.IsTrue(LNotes.Count >= 2);
    finally
      LNotes.Free;
    end;
  finally
    LNote1.Free;
    LNote2.Free;
  end;
end;

procedure TNoteRepositoryTests.TestRepositoryUpdate;
var
  LNote: TNote;
  LId: Integer;
  LUpdated: TNote;
begin
  // Create note
  LNote := TNote.Create;
  try
    LNote.Title := 'Original Title';
    LNote.Content := 'Original Content';
    LId := FRepository.Create(LNote);
  finally
    LNote.Free;
  end;
  
  // Update note
  LNote := TNote.Create;
  try
    LNote.Id := LId;
    LNote.Title := 'Updated Title';
    LNote.Content := 'Updated Content';
    
    FRepository.Update(LNote);
    
    // Verify update
    LUpdated := FRepository.GetById(LId);
    try
      Assert.AreEqual('Updated Title', LUpdated.Title);
      Assert.AreEqual('Updated Content', LUpdated.Content);
    finally
      LUpdated.Free;
    end;
  finally
    LNote.Free;
  end;
end;

procedure TNoteRepositoryTests.TestRepositoryDelete;
var
  LNote: TNote;
  LId: Integer;
  LDeleted: TNote;
begin
  // Create note
  LNote := TNote.Create;
  try
    LNote.Title := 'To Delete';
    LId := FRepository.Create(LNote);
  finally
    LNote.Free;
  end;
  
  // Delete note
  FRepository.Delete(LId);
  
  // Verify deletion
  LDeleted := FRepository.GetById(LId);
  try
    Assert.IsNull(LDeleted);
  finally
    LDeleted.Free;
  end;
end;

procedure TNoteRepositoryTests.TestRepositoryArchive;
var
  LNote: TNote;
  LId: Integer;
  LArchived: TNote;
begin
  // Create note
  LNote := TNote.Create;
  try
    LNote.Title := 'To Archive';
    LId := FRepository.Create(LNote);
  finally
    LNote.Free;
  end;
  
  // Archive note
  FRepository.Archive(LId);
  
  // Verify archived
  LArchived := FRepository.GetById(LId);
  try
    Assert.IsTrue(LArchived.IsArchived);
  finally
    LArchived.Free;
  end;
end;

procedure TNoteRepositoryTests.TestRepositoryCount;
var
  LInitialCount: Integer;
  LNote: TNote;
begin
  LInitialCount := FRepository.Count;
  
  // Create a note
  LNote := TNote.Create;
  try
    LNote.Title := 'Count Test';
    FRepository.Create(LNote);
    
    Assert.AreEqual(LInitialCount + 1, FRepository.Count);
  finally
    LNote.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TNoteRepositoryTests);
  
end.
