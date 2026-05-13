object frmNoteEditor: TfrmNoteEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Редактирование заметки'
  ClientHeight = 450
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  Position = poOwnerFormCenter
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 10
      Top = 15
      Width = 45
      Height = 15
      Caption = 'Заголовок:'
    end
    object edtTitle: TEdit
      Left = 10
      Top = 33
      Width = 580
      Height = 23
      TabOrder = 0
    end
  end
  object memContent: TMemo
    Left = 0
    Top = 50
    Width = 600
    Height = 350
    Align = alClient
    Lines.Strings = (
      'memContent')
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 400
    Width = 600
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object chkHasReminder: TCheckBox
      Left = 10
      Top = 15
      Width = 120
      Height = 17
      Caption = 'Напомнить:'
      TabOrder = 0
      OnClick = chkHasReminderClick
    end
    object dtpReminder: TDateTimePicker
      Left = 130
      Top = 12
      Width = 200
      Height = 23
      Date = 45345.000000000000000000
      Time = 0.500000000000000000
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 435
      Top = 10
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 515
      Top = 10
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Отмена'
      ModalResult = 2
      TabOrder = 3
      OnClick = btnCancelClick
    end
  end
end
