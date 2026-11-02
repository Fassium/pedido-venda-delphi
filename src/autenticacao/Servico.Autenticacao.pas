unit Servico.Autenticacao;

interface

uses
  System.SysUtils;

type
  EAutenticacao = class(Exception);

  TServicoAutenticacao = class
  public
    class procedure Entrar(const AEmail, ASenha: string);
  end;

implementation

const
  // Login apenas demonstrativo: credencial fixa, sem tabela de usuários (fora do escopo do teste).
  EMAIL_PADRAO = 'thiago@fassium.com';
  SENHA_PADRAO = 'admin123';

class procedure TServicoAutenticacao.Entrar(const AEmail, ASenha: string);
begin
  if (AEmail <> EMAIL_PADRAO) or (ASenha <> SENHA_PADRAO) then
    raise EAutenticacao.Create('E-mail ou senha inválidos.');
end;

end.
