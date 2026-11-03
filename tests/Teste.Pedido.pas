unit Teste.Pedido;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestePedido = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

procedure TTestePedido.Setup;
begin
end;

procedure TTestePedido.TearDown;
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestePedido);

end.
