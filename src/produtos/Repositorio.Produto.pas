unit Repositorio.Produto;

interface

uses
  FireDAC.Comp.Client, Model.Produto;

type
  IRepositorioProduto = interface
    ['{66760447-617C-46E4-9A0D-E95BA86E32E8}']
    function BuscarPorCodigo(const ACodigo: Integer): TProduto;
  end;

  TRepositorioProduto = class(TInterfacedObject, IRepositorioProduto)
  private
    FConexao: TFDConnection;
  public
    constructor Create(const AConexao: TFDConnection);
    function BuscarPorCodigo(const ACodigo: Integer): TProduto;
  end;

implementation

constructor TRepositorioProduto.Create(const AConexao: TFDConnection);
begin
  inherited Create;
  FConexao := AConexao;
end;

function TRepositorioProduto.BuscarPorCodigo(const ACodigo: Integer): TProduto;
var
  LConsulta: TFDQuery;
begin
  Result := nil;
  LConsulta := TFDQuery.Create(nil);
  try
    LConsulta.Connection := FConexao;
    LConsulta.SQL.Text := 'SELECT CODIGO, DESCRICAO, PRECO_VENDA FROM PRODUTO WHERE CODIGO = :CODIGO';
    LConsulta.ParamByName('CODIGO').AsInteger := ACodigo;
    LConsulta.Open;

    if LConsulta.IsEmpty then
      Exit;

    Result := TProduto.Create;
    Result.Codigo := LConsulta.FieldByName('CODIGO').AsInteger;
    Result.Descricao := LConsulta.FieldByName('DESCRICAO').AsString;
    Result.PrecoVenda := LConsulta.FieldByName('PRECO_VENDA').AsCurrency;
  finally
    LConsulta.Free;
  end;
end;

end.

