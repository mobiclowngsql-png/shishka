unit DatabaseInitializer;

interface

uses
  System.SysUtils;

type
  TDatabaseInitializer = class
  public
    class procedure Initialize(const ADatabasePath: string);
    class procedure Migrate(const ADatabasePath: string; AVersion: Integer);
  end;

implementation

uses
  SQLiteConnection;

const
  CURRENT_DB_VERSION = 1;
  
class procedure TDatabaseInitializer.Initialize(const ADatabasePath: string);
var
  LConnection: TSQLiteConnection;
begin
  LConnection := TSQLiteConnection.Create(ADatabasePath);
  try
    LConnection.Connect;
    
    // Create tables if not exist
    LConnection.ExecuteNonQuery(
      'CREATE TABLE IF NOT EXISTS notes (' +
      '  id INTEGER PRIMARY KEY AUTOINCREMENT,' +
      '  title TEXT NOT NULL,' +
      '  content TEXT,' +
      '  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,' +
      '  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,' +
      '  is_archived INTEGER DEFAULT 0,' +
      '  has_reminder INTEGER DEFAULT 0,' +
      '  reminder_date DATETIME' +
      ')'
    );
    
    LConnection.ExecuteNonQuery(
      'CREATE TABLE IF NOT EXISTS reminders (' +
      '  id INTEGER PRIMARY KEY AUTOINCREMENT,' +
      '  note_id INTEGER,' +
      '  message TEXT,' +
      '  reminder_date DATETIME NOT NULL,' +
      '  is_triggered INTEGER DEFAULT 0,' +
      '  FOREIGN KEY (note_id) REFERENCES notes(id)' +
      ')'
    );
    
    LConnection.ExecuteNonQuery(
      'CREATE INDEX IF NOT EXISTS idx_notes_archived ON notes(is_archived)'
    );
    
    LConnection.ExecuteNonQuery(
      'CREATE INDEX IF NOT EXISTS idx_reminders_triggered ON reminders(is_triggered)'
    );
    
    // Set user version
    LConnection.ExecuteNonQuery(
      Format('PRAGMA user_version = %d', [CURRENT_DB_VERSION])
    );
    
  finally
    LConnection.Free;
  end;
end;

class procedure TDatabaseInitializer.Migrate(const ADatabasePath: string; AVersion: Integer);
var
  LConnection: TSQLiteConnection;
  LCurrentVersion: Integer;
begin
  LConnection := TSQLiteConnection.Create(ADatabasePath);
  try
    LConnection.Connect;
    
    // Get current version
    LCurrentVersion := LConnection.ExecuteScalar('PRAGMA user_version');
    
    if LCurrentVersion >= AVersion then
      Exit;
    
    // Perform migrations based on version
    // Example: if LCurrentVersion < 2 then migrate to v2
    
    // Update version
    LConnection.ExecuteNonQuery(
      Format('PRAGMA user_version = %d', [AVersion])
    );
    
  finally
    LConnection.Free;
  end;
end;

end.
