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
  public
    constructor Create(const ACaminhoArquivo: string);
    property Servidor: string read FServidor;
    property Porta: Integer read FPorta;
    property Banco: string read FBanco;
    property Usuario: string read FUsuario;
    property Senha: string read FSenha;
  end;

implementation

uses
  System.SysUtils, System.IniFiles;

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
  finally
    LArquivo.Free;
  end;

  if FBanco.IsEmpty then
    raise Exception.Create('Chave Database não informada no config.ini.');
end;

end.

