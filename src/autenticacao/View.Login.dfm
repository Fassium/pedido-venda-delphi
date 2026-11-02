object FrmLogin: TFrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Entrar'
  ClientHeight = 400
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object lblEmail: TLabel
    Left = 40
    Top = 125
    Width = 34
    Height = 15
    Caption = 'E-mail'
  end
  object lblSenha: TLabel
    Left = 40
    Top = 195
    Width = 32
    Height = 15
    Caption = 'Senha'
  end
  object lblSubtitulo: TLabel
    Left = 40
    Top = 80
    Width = 107
    Height = 15
    Caption = 'Entre para continuar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object lblTitulo: TLabel
    Left = 40
    Top = 40
    Width = 215
    Height = 37
    Caption = 'Pedido de Venda'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnEntrar: TButton
    Left = 40
    Top = 297
    Width = 300
    Height = 42
    Caption = 'Entrar'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnEntrarClick
  end
  object chkMostrarSenha: TCheckBox
    Left = 40
    Top = 258
    Width = 150
    Height = 17
    Caption = 'Mostrar senha'
    TabOrder = 2
    OnClick = chkMostrarSenhaClick
  end
  object edtEmail: TEdit
    Left = 40
    Top = 145
    Width = 300
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = 'thiago@fassium.com'
    TextHint = 'seu@email.com'
  end
  object edtSenha: TEdit
    Left = 40
    Top = 215
    Width = 300
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 1
    Text = 'admin123'
    TextHint = 'Sua senha'
  end
end
