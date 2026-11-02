unit View.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmLogin = class(TForm)
    btnEntrar: TButton;
    chkMostrarSenha: TCheckBox;
    edtEmail: TEdit;
    edtSenha: TEdit;
    lblEmail: TLabel;
    lblSenha: TLabel;
    lblSubtitulo: TLabel;
    lblTitulo: TLabel;
    procedure btnEntrarClick(Sender: TObject);
    procedure chkMostrarSenhaClick(Sender: TObject);
  private
    { Private declarations }
  protected
    // Dá ao login o próprio botão na barra de tarefas. Ele abre antes da janela principal existir
    // e, sem este ajuste, o Windows não mostraria o programa na barra.
    // WS_EX_APPWINDOW força o botão; WndParent := 0 solta o login da janela invisível do Application.
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses
  Servico.Autenticacao;

{$R *.dfm}

{ TFrmLogin }

procedure TFrmLogin.btnEntrarClick(Sender: TObject);
begin
  if Trim(edtEmail.Text).IsEmpty then
  begin
    MessageDlg('Informe o e-mail.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
    edtEmail.SetFocus;
    Exit;
  end;

  if Trim(edtSenha.Text).IsEmpty then
  begin
    MessageDlg('Informe a senha.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
    edtSenha.SetFocus;
    Exit;
  end;

  try
    TServicoAutenticacao.Entrar(Trim(edtEmail.Text), edtSenha.Text);
    ModalResult := mrOk;
  except
    on E: EAutenticacao do
    begin
      MessageDlg(E.Message, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
      edtSenha.SetFocus;
      edtSenha.SelectAll;
    end;
  end;
end;

procedure TFrmLogin.chkMostrarSenhaClick(Sender: TObject);
begin
  if chkMostrarSenha.Checked then
    edtSenha.PasswordChar := #0
  else
    edtSenha.PasswordChar := '*';
end;

procedure TFrmLogin.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

end.
