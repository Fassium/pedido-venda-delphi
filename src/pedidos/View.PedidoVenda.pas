unit View.PedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.WinXPanels,
  View.Base, Controller.Pedido;

type
  TFrmPedidoVenda = class(TFrmBase)
    cpnPedido: TCardPanel;
    crdLista: TCard;
    pnlLista: TPanel;
    pnlFiltro: TPanel;
    edtBusca: TEdit;
    btnBuscar: TButton;
    btnNovo: TButton;
    btnEditar: TButton;
    btnCancelarPedido: TButton;
    btnSair: TButton;
    dbgLista: TDBGrid;
    crdPedido: TCard;
    pnlPedido: TPanel;
    pnlCabecalho: TPanel;
    lblNumeroPedido: TLabel;
    lblDataEmissao: TLabel;
    lblCodigoCliente: TLabel;
    lblNomeCliente: TLabel;
    lblCidadeCliente: TLabel;
    lblUFCliente: TLabel;
    edtNumeroPedido: TEdit;
    edtDataEmissao: TEdit;
    edtCodigoCliente: TEdit;
    edtNomeCliente: TEdit;
    edtCidadeCliente: TEdit;
    edtUFCliente: TEdit;
    pnlItem: TPanel;
    lblCodigoProduto: TLabel;
    lblDescricaoProduto: TLabel;
    lblQuantidade: TLabel;
    lblValorUnitario: TLabel;
    edtCodigoProduto: TEdit;
    edtDescricaoProduto: TEdit;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    btnInserirAtualizarItem: TButton;
    grdItens: TStringGrid;
    pnlRodape: TPanel;
    lblTituloTotal: TLabel;
    lblValorTotal: TLabel;
    btnGravarPedido: TButton;
    btnDescartar: TButton;
    mtLista: TFDMemTable;
    mtListaNUMERO_PEDIDO: TLargeintField;
    mtListaDATA_EMISSAO: TDateField;
    mtListaCODIGO_CLIENTE: TIntegerField;
    mtListaNOME_CLIENTE: TStringField;
    mtListaVALOR_TOTAL: TBCDField;
    dsLista: TDataSource;
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

