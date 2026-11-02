unit View.PedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.Base, Controller.Pedido;

type
  TFrmPedidoVenda = class(TFrmBase)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FController: TControllerPedido;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmPedidoVenda.FormCreate(Sender: TObject);
begin
  FController := TControllerPedido.Create(Conexao);
end;

procedure TFrmPedidoVenda.FormDestroy(Sender: TObject);
begin
  FController.Free;
end;

end.

