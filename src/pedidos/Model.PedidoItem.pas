unit Model.PedidoItem;

interface

type
  TPedidoItem = class
  private
    FId: Int64;
    FCodigoProduto: Integer;
    FDescricaoProduto: string;
    FQuantidade: Integer;
    FValorUnitario: Currency;
    function GetValorTotal: Currency;
  public
    property Id: Int64 read FId write FId;
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
    property DescricaoProduto: string read FDescricaoProduto write FDescricaoProduto;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
    property ValorTotal: Currency read GetValorTotal;
  end;

implementation

function TPedidoItem.GetValorTotal: Currency;
begin
  Result := FQuantidade * FValorUnitario;
end;

end.

