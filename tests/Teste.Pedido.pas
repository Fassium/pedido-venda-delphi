unit Teste.Pedido;

interface

uses
  DUnitX.TestFramework, Model.Pedido, Model.PedidoItem;

type
  [TestFixture]
  TTestePedido = class
  private
    FPedido: TPedido;
    function AdicionarItem(AQuantidade: Integer; AValorUnitario: Currency): TPedidoItem;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Pedido recém-criado, sem itens, deve ter valor total zero.
    [Test]
    procedure PedidoVazioDeveTerTotalZero;
    // Total do item é a quantidade vezes o valor unitário.
    [Test]
    procedure ItemDeveMultiplicarQuantidadePeloValorUnitario;
    // Total do pedido é a soma dos totais dos itens.
    [Test]
    procedure PedidoDeveSomarOTotalDosItens;
  end;

implementation

function TTestePedido.AdicionarItem(AQuantidade: Integer;
  AValorUnitario: Currency): TPedidoItem;
begin
  Result := TPedidoItem.Create;
  Result.Quantidade := AQuantidade;
  Result.ValorUnitario := AValorUnitario;
  FPedido.Itens.Add(Result);
end;

procedure TTestePedido.ItemDeveMultiplicarQuantidadePeloValorUnitario;
var
  LItem: TPedidoItem;
begin
  LItem := AdicionarItem(3, 4.25);

  Assert.AreEqual<Currency>(12.75, LItem.ValorTotal);
end;

procedure TTestePedido.PedidoDeveSomarOTotalDosItens;
begin
  AdicionarItem(2, 10.50);
  AdicionarItem(3, 4.25);

  Assert.AreEqual<Currency>(33.75, FPedido.ValorTotal);
end;

procedure TTestePedido.PedidoVazioDeveTerTotalZero;
begin
  Assert.AreEqual<Currency>(0, FPedido.ValorTotal);
end;

procedure TTestePedido.Setup;
begin
  FPedido := TPedido.Create;
end;

procedure TTestePedido.TearDown;
begin
  FPedido.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestePedido);

end.
