unit Controller.Pedido;

interface

uses
  FireDAC.Comp.Client, Model.Cliente, Model.Produto, Servico.Pedido;

type
  TControllerPedido = class
  private
    FServico: TServicoPedido;
  public
    constructor Create(const AConexao: TFDConnection);
    destructor Destroy; override;
    function BuscarCliente(const ACodigo: Integer): TCliente;
    function BuscarProduto(const ACodigo: Integer): TProduto;
  end;

implementation

uses
  Repositorio.Cliente, Repositorio.Produto;

constructor TControllerPedido.Create(const AConexao: TFDConnection);
var
  LRepositorioCliente: IRepositorioCliente;
  LRepositorioProduto: IRepositorioProduto;
begin
  inherited Create;
  LRepositorioCliente := TRepositorioCliente.Create(AConexao);
  LRepositorioProduto := TRepositorioProduto.Create(AConexao);
  FServico := TServicoPedido.Create(LRepositorioCliente, LRepositorioProduto);
end;

destructor TControllerPedido.Destroy;
begin
  FServico.Free;
  inherited Destroy;
end;

function TControllerPedido.BuscarCliente(const ACodigo: Integer): TCliente;
begin
  Result := FServico.BuscarCliente(ACodigo);
end;

function TControllerPedido.BuscarProduto(const ACodigo: Integer): TProduto;
begin
  Result := FServico.BuscarProduto(ACodigo);
end;

end.

