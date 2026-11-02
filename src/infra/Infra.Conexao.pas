unit Infra.Conexao;

interface

uses
  FireDAC.Comp.Client, FireDAC.Phys.FB, Infra.Configuracao;

type
  TConexao = class
  private
    FDriverLink: TFDPhysFBDriverLink;
    FConexao: TFDConnection;
  public
    constructor Create(const AConfiguracao: TConfiguracao);
    destructor Destroy; override;
    property Conexao: TFDConnection read FConexao;
  end;

implementation

uses
  System.SysUtils, FireDAC.Stan.Def, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.VCLUI.Wait;

constructor TConexao.Create(const AConfiguracao: TConfiguracao);
begin
  inherited Create;

  FDriverLink := TFDPhysFBDriverLink.Create(nil);
  FDriverLink.VendorLib := AConfiguracao.BibliotecaCliente;

  FConexao := TFDConnection.Create(nil);
  FConexao.LoginPrompt := False;
  FConexao.Params.DriverID := 'FB';
  FConexao.Params.Database := AConfiguracao.Banco;
  FConexao.Params.UserName := AConfiguracao.Usuario;
  FConexao.Params.Password := AConfiguracao.Senha;
  FConexao.Params.Values['Server'] := AConfiguracao.Servidor;
  FConexao.Params.Values['Port'] := AConfiguracao.Porta.ToString;
  FConexao.Params.Values['Protocol'] := 'TCPIP';
  FConexao.Params.Values['CharacterSet'] := 'UTF8';

  FConexao.Connected := True;
end;

destructor TConexao.Destroy;
begin
  FConexao.Free;
  FDriverLink.Free;

  inherited;
end;

end.

