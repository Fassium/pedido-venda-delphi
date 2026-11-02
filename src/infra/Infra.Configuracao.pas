unit Infra.Configuracao;

interface

type
  TConfiguracao = class
  private
    FServidor: string;
    FPorta: Integer;
    FBanco: string;
    FUsuario: string;
    FSenha: string;
    FBibliotecaCliente: string;
  public
    constructor Create(const ACaminhoArquivo: string);
    property Servidor: string read FServidor;
    property Porta: Integer read FPorta;
    property Banco: string read FBanco;
    property Usuario: string read FUsuario;
    property Senha: string read FSenha;
    property BibliotecaCliente: string read FBibliotecaCliente;
  end;

implementation

uses
  System.SysUtils, System.IniFiles, System.IOUtils;

const
  SECAO_CONEXAO = 'Conexao';

constructor TConfiguracao.Create(const ACaminhoArquivo: string);
var
  LArquivo: TIniFile;
begin
  if not FileExists(ACaminhoArquivo) then
    raise Exception.CreateFmt('Arquivo de configuração não encontrado: %s', [ACaminhoArquivo]);

  LArquivo := TIniFile.Create(ACaminhoArquivo);
  try
    FServidor := LArquivo.ReadString(SECAO_CONEXAO, 'Server', 'localhost');
    FPorta := LArquivo.ReadInteger(SECAO_CONEXAO, 'Port', 3050);
    FBanco := LArquivo.ReadString(SECAO_CONEXAO, 'Database', '');
    FUsuario := LArquivo.ReadString(SECAO_CONEXAO, 'Username', '');
    FSenha := LArquivo.ReadString(SECAO_CONEXAO, 'Password', '');
    FBibliotecaCliente := LArquivo.ReadString(SECAO_CONEXAO, 'ClientLibrary', '');
  finally
    LArquivo.Free;
  end;

  if FBanco.IsEmpty then
    raise Exception.Create('Chave Database não informada no config.ini.');

  if FBibliotecaCliente.IsEmpty then
    raise Exception.Create('Chave ClientLibrary não informada no config.ini.');

  // Caminho relativo vale a partir da pasta do config.ini; o absoluto passa direto.
  FBibliotecaCliente := TPath.Combine(ExtractFilePath(ACaminhoArquivo), FBibliotecaCliente);

  if not FileExists(FBibliotecaCliente) then
    raise Exception.CreateFmt('Biblioteca do Firebird não encontrada: %s', [FBibliotecaCliente]);
end;

end.

