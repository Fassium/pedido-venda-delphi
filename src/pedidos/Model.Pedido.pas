unit Model.Pedido;

interface

uses
  System.Generics.Collections,
  Model.PedidoItem;

type
  TPedido = class
  private
    FNumeroPedido: Int64;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FItens: TObjectList<TPedidoItem>;
    function GetValorTotal: Currency;
  public
    constructor Create;
    destructor Destroy; override;
    property NumeroPedido: Int64 read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property Itens: TObjectList<TPedidoItem> read FItens;
    property ValorTotal: Currency read GetValorTotal;
  end;

implementation

constructor TPedido.Create;
begin
  inherited Create;
  FItens := TObjectList<TPedidoItem>.Create(True);
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  inherited Destroy;
end;

function TPedido.GetValorTotal: Currency;
var
  LItem: TPedidoItem;
begin
  Result := 0;
  for LItem in FItens do
    Result := Result + LItem.ValorTotal;
end;

end.

