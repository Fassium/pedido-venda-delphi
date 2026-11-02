unit View.PedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.WinXPanels,
  View.Base, Controller.Pedido, Model.Pedido;

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
    procedure btnNovoClick(Sender: TObject);
    procedure btnDescartarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
  private
    { Private declarations }
    FController: TControllerPedido;
    FPedido: TPedido;
    procedure LimparPedido;
    procedure LimparCliente;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Model.Cliente, Servico.Pedido;

procedure TFrmPedidoVenda.FormCreate(Sender: TObject);
begin

  FController := TControllerPedido.Create(Conexao);

  grdItens.Cells[0, 0] := 'Cód. Produto';
  grdItens.Cells[1, 0] := 'Descrição';
  grdItens.Cells[2, 0] := 'Quantidade';
  grdItens.Cells[3, 0] := 'Vlr. Unitário';
  grdItens.Cells[4, 0] := 'Vlr. Total';

  cpnPedido.ActiveCard := crdLista;

end;

procedure TFrmPedidoVenda.FormDestroy(Sender: TObject);
begin

  FPedido.Free;
  FController.Free;

end;

procedure TFrmPedidoVenda.btnNovoClick(Sender: TObject);
begin

  FPedido.Free;
  FPedido := TPedido.Create;
  FPedido.DataEmissao := Date;

  LimparPedido;
  edtDataEmissao.Text := DateToStr(FPedido.DataEmissao);

  cpnPedido.ActiveCard := crdPedido;
  edtCodigoCliente.SetFocus;

end;

procedure TFrmPedidoVenda.btnDescartarClick(Sender: TObject);
begin

  FreeAndNil(FPedido);
  cpnPedido.ActiveCard := crdLista;

end;

procedure TFrmPedidoVenda.btnSairClick(Sender: TObject);
begin

  Close;

end;

procedure TFrmPedidoVenda.LimparPedido;
begin

  edtNumeroPedido.Clear;
  edtDataEmissao.Clear;
  edtCodigoCliente.Clear;
  edtNomeCliente.Clear;
  edtCidadeCliente.Clear;
  edtUFCliente.Clear;
  edtCodigoProduto.Clear;
  edtDescricaoProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;

  grdItens.RowCount := 2;
  grdItens.Rows[1].Clear;

  lblValorTotal.Caption := FormatFloat('#,##0.00', FPedido.ValorTotal);

end;

procedure TFrmPedidoVenda.edtCodigoClienteExit(Sender: TObject);
var
  LCodigo: Integer;
  LCliente: TCliente;
begin

  LimparCliente;

  if Trim(edtCodigoCliente.Text) = '' then
    Exit;

  if not TryStrToInt(edtCodigoCliente.Text, LCodigo) then
  begin
    MessageDlg('Código do cliente inválido.', mtWarning, [mbOK], 0);
    Exit;
  end;

  try
    LCliente := FController.BuscarCliente(LCodigo);
  except
    on E: EValidacao do
    begin
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
      Exit;
    end;
  end;

  try
    FPedido.CodigoCliente := LCliente.Codigo;
    edtNomeCliente.Text := LCliente.Nome;
    edtCidadeCliente.Text := LCliente.Cidade;
    edtUFCliente.Text := LCliente.UF;
  finally
    LCliente.Free;
  end;

end;

procedure TFrmPedidoVenda.LimparCliente;
begin

  FPedido.CodigoCliente := 0;
  edtNomeCliente.Clear;
  edtCidadeCliente.Clear;
  edtUFCliente.Clear;

end;

end.

