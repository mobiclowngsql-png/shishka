unit IReminderService;

interface

uses
  Reminder,
  System.Generics.Collections;

type
  IReminderService = interface
    ['{B2C3D4E5-F6A7-8901-BCDE-F12345678901}']
    
    function GetById(const AId: Integer): TReminder;
    function GetAll: TObjectList<TReminder>;
    function GetPending: TObjectList<TReminder>;
    function GetByNoteId(const ANoteId: Integer): TObjectList<TReminder>;
    
    function Create(const AReminder: TReminder): Integer;
    procedure Update(const AReminder: TReminder);
    procedure Delete(const AId: Integer);
    procedure MarkAsTriggered(const AId: Integer);
    
    function HasPendingReminders: Boolean;
    function GetNextReminderTime: TDateTime;
  end;

implementation

end.
