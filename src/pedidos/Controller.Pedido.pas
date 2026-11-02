unit Controller.Pedido;

interface

uses
  FireDAC.Comp.Client, Model.Cliente, Model.Produto, Model.Pedido, Servico.Pedido;

type
  TControllerPedido = class
  private
    FServico: TServicoPedido;
  public
    constructor Create(const AConexao: TFDConnection);
    destructor Destroy; override;
    function BuscarCliente(const ACodigo: Integer): TCliente;
    function BuscarProduto(const ACodigo: Integer): TProduto;
    function BuscarPedido(const ANumeroPedido: Int64): TPedido;
    procedure Gravar(const APedido: TPedido);
    procedure Listar(const AFiltro: string; const ADestino: TFDMemTable);
  end;

implementation

uses
  Repositorio.Cliente, Repositorio.Produto, Repositorio.Pedido;

constructor TControllerPedido.Create(const AConexao: TFDConnection);
var
  LRepositorioCliente: IRepositorioCliente;
  LRepositorioProduto: IRepositorioProduto;
  LRepositorioPedido: IRepositorioPedido;
begin
  inherited Create;
  LRepositorioCliente := TRepositorioCliente.Create(AConexao);
  LRepositorioProduto := TRepositorioProduto.Create(AConexao);
  LRepositorioPedido := TRepositorioPedido.Create(AConexao);
  FServico := TServicoPedido.Create(AConexao, LRepositorioCliente, LRepositorioProduto, LRepositorioPedido);
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

function TControllerPedido.BuscarPedido(const ANumeroPedido: Int64): TPedido;
begin
  Result := FServico.BuscarPedido(ANumeroPedido);
end;

procedure TControllerPedido.Gravar(const APedido: TPedido);
begin
  FServico.Gravar(APedido);
end;

procedure TControllerPedido.Listar(const AFiltro: string; const ADestino: TFDMemTable);
begin
  FServico.Listar(AFiltro, ADestino);
end;

end.

