unit INoteRepository;

interface

uses
  Note,
  System.Generics.Collections;

type
  INoteRepository = interface
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    
    function GetById(const AId: Integer): TNote;
    function GetAll: TObjectList<TNote>;
    function GetActive: TObjectList<TNote>;
    function GetArchived: TObjectList<TNote>;
    function GetByTitle(const ATitle: string): TObjectList<TNote>;
    
    function Create(const ANote: TNote): Integer;
    procedure Update(const ANote: TNote);
    procedure Delete(const AId: Integer);
    
    procedure Archive(const AId: Integer);
    procedure Unarchive(const AId: Integer);
    
    function Count: Integer;
  end;

implementation

end.
