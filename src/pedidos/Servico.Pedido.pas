unit Servico.Pedido;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, Model.Cliente, Model.Produto, Model.Pedido, Repositorio.Cliente,
  Repositorio.Produto, Repositorio.Pedido;

type
  EValidacao = class(Exception);

  TServicoPedido = class
  private
    FConexao: TFDConnection;
    FRepositorioCliente: IRepositorioCliente;
    FRepositorioProduto: IRepositorioProduto;
    FRepositorioPedido: IRepositorioPedido;
    procedure ValidarPedido(const APedido: TPedido);
  public
    constructor Create(const AConexao: TFDConnection; const ARepositorioCliente: IRepositorioCliente;
      const ARepositorioProduto: IRepositorioProduto; const ARepositorioPedido: IRepositorioPedido);
    function BuscarCliente(const ACodigo: Integer): TCliente;
    function BuscarProduto(const ACodigo: Integer): TProduto;
    function BuscarPedido(const ANumeroPedido: Int64): TPedido;
    procedure Gravar(const APedido: TPedido);
    procedure Listar(const AFiltro: string; const ADestino: TFDMemTable);
  end;

implementation

uses
  Model.PedidoItem;

constructor TServicoPedido.Create(const AConexao: TFDConnection; const ARepositorioCliente: IRepositorioCliente;
  const ARepositorioProduto: IRepositorioProduto; const ARepositorioPedido: IRepositorioPedido);
begin
  inherited Create;
  FConexao := AConexao;
  FRepositorioCliente := ARepositorioCliente;
  FRepositorioProduto := ARepositorioProduto;
  FRepositorioPedido := ARepositorioPedido;
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

function TServicoPedido.BuscarPedido(const ANumeroPedido: Int64): TPedido;
begin
  Result := FRepositorioPedido.BuscarPorNumero(ANumeroPedido);

  if not Assigned(Result) then
    raise EValidacao.CreateFmt('Pedido %d não encontrado.', [ANumeroPedido]);
end;

// Cabeçalho e itens na mesma transação: ou grava tudo, ou nada. Número 0 é pedido novo; com número, é edição.
procedure TServicoPedido.Gravar(const APedido: TPedido);
var
  LPedidoNovo: Boolean;
  LItem: TPedidoItem;
begin
  ValidarPedido(APedido);

  LPedidoNovo := APedido.NumeroPedido = 0;

  FConexao.StartTransaction;
  try
    if LPedidoNovo then
      FRepositorioPedido.Inserir(APedido)
    else
      FRepositorioPedido.Atualizar(APedido);

    FConexao.Commit;
  except
    FConexao.Rollback;

    // O banco desfez a gravação: o objeto não pode ficar com número e IDs que não existem mais.
    // Na edição o número continua valendo; os itens são regravados de qualquer forma.
    if LPedidoNovo then
      APedido.NumeroPedido := 0;
    for LItem in APedido.Itens do
      LItem.Id := 0;

    raise;
  end;
end;

procedure TServicoPedido.Listar(const AFiltro: string; const ADestino: TFDMemTable);
begin
  FRepositorioPedido.Listar(AFiltro, ADestino);
end;

procedure TServicoPedido.ValidarPedido(const APedido: TPedido);
var
  LItem: TPedidoItem;
begin
  if APedido.CodigoCliente = 0 then
    raise EValidacao.Create('Informe o cliente do pedido.');

  if APedido.Itens.Count = 0 then
    raise EValidacao.Create('Inclua pelo menos um item no pedido.');

  for LItem in APedido.Itens do
  begin
    if LItem.Quantidade <= 0 then
      raise EValidacao.CreateFmt('Quantidade inválida no produto %d.', [LItem.CodigoProduto]);

    if LItem.ValorUnitario < 0 then
      raise EValidacao.CreateFmt('Valor unitário inválido no produto %d.', [LItem.CodigoProduto]);
  end;
end;

end.

