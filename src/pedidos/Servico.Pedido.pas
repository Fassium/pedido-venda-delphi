unit Servico.Pedido;

interface

uses
  System.SysUtils, Model.Cliente, Model.Produto, Repositorio.Cliente, Repositorio.Produto;

type
  EValidacao = class(Exception);

  TServicoPedido = class
  private
    FRepositorioCliente: IRepositorioCliente;
    FRepositorioProduto: IRepositorioProduto;
  public
    constructor Create(const ARepositorioCliente: IRepositorioCliente;
      const ARepositorioProduto: IRepositorioProduto);
    function BuscarCliente(const ACodigo: Integer): TCliente;
    function BuscarProduto(const ACodigo: Integer): TProduto;
  end;

implementation

constructor TServicoPedido.Create(const ARepositorioCliente: IRepositorioCliente;
  const ARepositorioProduto: IRepositorioProduto);
begin
  inherited Create;
  FRepositorioCliente := ARepositorioCliente;
  FRepositorioProduto := ARepositorioProduto;
end;

function TServicoPedido.BuscarCliente(const ACodigo: Integer): TCliente;
begin
  Result := FRepositorioCliente.BuscarPorCodigo(ACodigo);

  if not Assigned(Result) then
    raise EValidacao.CreateFmt('Cliente %d não encontrado.', [ACodigo]);
end;

function TServicoPedido.BuscarProduto(const ACodigo: Integer): TProduto;
begin
  Result := FRepositorioProduto.BuscarPorCodigo(ACodigo);

  if not Assigned(Result) then
    raise EValidacao.CreateFmt('Produto %d não encontrado.', [ACodigo]);
end;

end.

