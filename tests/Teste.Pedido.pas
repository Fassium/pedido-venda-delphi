unit Teste.Pedido;

interface

uses
  DUnitX.TestFramework, Model.Pedido;

type
  [TestFixture]
  TTestePedido = class
  private
    FPedido: TPedido;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Pedido recém-criado, sem itens, deve ter valor total zero.
    [Test]
    procedure PedidoVazioDeveTerTotalZero;
  end;

implementation

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
