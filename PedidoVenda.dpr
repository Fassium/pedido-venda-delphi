program PedidoVenda;

uses
  Vcl.Forms,
  View.Principal in 'src\principal\View.Principal.pas' {FrmPrincipal},
  Infra.Configuracao in 'src\infra\Infra.Configuracao.pas',
  Infra.Conexao in 'src\infra\Infra.Conexao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
