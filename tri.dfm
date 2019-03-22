object Form1: TForm1
  Left = 50
  Top = 50
  BorderStyle = bsDialog
  Caption = 'BASIC OpenGL Program'
  ClientHeight = 513
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poDesigned
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 232
    Top = 120
  end
end
