unit Repositorio.Cliente;

interface

uses
  FireDAC.Comp.Client, Model.Cliente;

type
  IRepositorioCliente = interface
    ['{8996F876-9CC0-4514-96FB-C0C47C8F6F7A}']
    function BuscarPorCodigo(const ACodigo: Integer): TCliente;
  end;

  TRepositorioCliente = class(TInterfacedObject, IRepositorioCliente)
  private
    FConexao: TFDConnection;
  public
    constructor Create(const AConexao: TFDConnection);
    function BuscarPorCodigo(const ACodigo: Integer): TCliente;
  end;

implementation

constructor TRepositorioCliente.Create(const AConexao: TFDConnection);
begin
  inherited Create;
  FConexao := AConexao;
end;

function TRepositorioCliente.BuscarPorCodigo(const ACodigo: Integer): TCliente;
var
  LConsulta: TFDQuery;
begin
  Result := nil;
  LConsulta := TFDQuery.Create(nil);
  try
    LConsulta.Connection := FConexao;
    LConsulta.SQL.Text := 'SELECT CODIGO, NOME, CIDADE, UF FROM CLIENTE WHERE CODIGO = :CODIGO';
    LConsulta.ParamByName('CODIGO').AsInteger := ACodigo;
    LConsulta.Open;

    if LConsulta.IsEmpty then
      Exit;

    Result := TCliente.Create;
    Result.Codigo := LConsulta.FieldByName('CODIGO').AsInteger;
    Result.Nome := LConsulta.FieldByName('NOME').AsString;
    Result.Cidade := LConsulta.FieldByName('CIDADE').AsString;
    Result.UF := LConsulta.FieldByName('UF').AsString;
  finally
    LConsulta.Free;
  end;
end;

end.

