object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Note Manager'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 300
    Height = 600
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 300
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblTitle: TLabel
        Left = 10
        Top = 12
        Width = 87
        Height = 15
        Caption = 'Мои заметки'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtSearch: TEdit
        Left = 10
        Top = 33
        Width = 280
        Height = 23
        Hint = 'Поиск...'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = edtSearchChange
      end
    end
    object lstNotes: TListView
      Left = 0
      Top = 41
      Width = 300
      Height = 518
      Align = alClient
      Columns = <>
      TabOrder = 1
      ViewStyle = vsReport
      OnSelectItem = lstNotesSelectItem
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 559
      Width = 300
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object btnNew: TButton
        Left = 10
        Top = 8
        Width = 60
        Height = 25
        Caption = 'Новая'
        TabOrder = 0
        OnClick = btnNewClick
      end
      object btnEdit: TButton
        Left = 76
        Top = 8
        Width = 60
        Height = 25
        Caption = 'Открыть'
        TabOrder = 1
        OnClick = btnEditClick
      end
      object btnDelete: TButton
        Left = 142
        Top = 8
        Width = 60
        Height = 25
        Caption = 'Удалить'
        TabOrder = 2
        OnClick = btnDeleteClick
      end
      object btnArchive: TButton
        Left = 208
        Top = 8
        Width = 80
        Height = 25
        Caption = 'Архив'
        TabOrder = 3
        OnClick = btnArchiveClick
      end
    end
  end
  object Splitter1: TSplitter
    Left = 300
    Top = 0
    Height = 600
  end
  object pnlRight: TPanel
    Left = 303
    Top = 0
    Width = 597
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object memContent: TMemo
      Left = 0
      Top = 0
      Width = 597
      Height = 600
      Align = alClient
      Lines.Strings = (
        'memContent')
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object imgIcons: TImageList
    Left = 360
    Top = 50
  end
end
