program PedidoVenda;

uses
  Vcl.Forms,
  View.Principal in 'src\principal\View.Principal.pas' {FrmPrincipal},
  Infra.Configuracao in 'src\infra\Infra.Configuracao.pas',
  Infra.Conexao in 'src\infra\Infra.Conexao.pas',
  View.Login in 'src\autenticacao\View.Login.pas' {FrmLogin},
  Servico.Autenticacao in 'src\autenticacao\Servico.Autenticacao.pas',
  View.Base in 'src\comum\View.Base.pas' {FrmBase},
  View.PedidoVenda in 'src\pedidos\View.PedidoVenda.pas' {FrmPedidoVenda},
  Vcl.Themes,
  Vcl.Styles,
  Winapi.Windows,
  System.SysUtils,
  System.UITypes;

{$R *.res}

var
  LConfiguracao: TConfiguracao;
  LConexao: TConexao;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');

  try
    LConfiguracao := TConfiguracao.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
    try
      LConexao := TConexao.Create(LConfiguracao);
    finally
      LConfiguracao.Free;
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Não foi possível conectar ao banco de dados.' + sLineBreak + E.Message),
        'Pedido de Venda', MB_ICONERROR);
      Exit;
    end;
  end;

  try
    FrmLogin := TFrmLogin.Create(nil);
    try
      if FrmLogin.ShowModal <> mrOk then
        Exit;
    finally
      FrmLogin.Free;
    end;

    Application.CreateForm(TFrmPrincipal, FrmPrincipal);
    Application.Run;
  finally
    LConexao.Free;
  end;
end.

