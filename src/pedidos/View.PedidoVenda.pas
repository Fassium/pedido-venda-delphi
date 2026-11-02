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
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure btnInserirAtualizarItemClick(Sender: TObject);
    procedure grdItensDblClick(Sender: TObject);
    procedure grdItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnBuscarClick(Sender: TObject);
    procedure edtBuscaKeyPress(Sender: TObject; var Key: Char);
    procedure btnGravarPedidoClick(Sender: TObject);
  private
    { Private declarations }
    FController: TControllerPedido;
    FPedido: TPedido;
    FCodigoProdutoExibido: Integer;
    FIndiceEmEdicao: Integer;
    procedure LimparPedido;
    procedure LimparCliente;
    procedure LimparProduto;
    procedure LimparItem;
    procedure ExibirItens;
    function IndiceItemSelecionado: Integer;
    procedure CarregarItemSelecionado;
    procedure ExcluirItemSelecionado;
    procedure CarregarLista;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  System.Math, Model.Cliente, Model.Produto, Model.PedidoItem, Servico.Pedido;

procedure TFrmPedidoVenda.FormCreate(Sender: TObject);
begin

  FController := TControllerPedido.Create(Conexao);

  grdItens.Cells[0, 0] := 'Cód. Produto';
  grdItens.Cells[1, 0] := 'Descrição';
  grdItens.Cells[2, 0] := 'Quantidade';
  grdItens.Cells[3, 0] := 'Vlr. Unitário';
  grdItens.Cells[4, 0] := 'Vlr. Total';

  grdItens.ColWidths[0] := 110;
  grdItens.ColWidths[1] := 400;
  grdItens.ColWidths[2] := 90;
  grdItens.ColWidths[3] := 110;
  grdItens.ColWidths[4] := 110;

  cpnPedido.ActiveCard := crdLista;
  CarregarLista;

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

  if MessageDlg('Descartar o pedido? Tudo o que foi lançado será perdido.',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) <> mrYes then
    Exit;

  FreeAndNil(FPedido);
  cpnPedido.ActiveCard := crdLista;

end;

procedure TFrmPedidoVenda.btnSairClick(Sender: TObject);
begin

  if MessageDlg('Deseja sair do Pedido de Venda?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) <> mrYes then
    Exit;

  Close;

end;

procedure TFrmPedidoVenda.LimparPedido;
begin

  edtNumeroPedido.Clear;
  edtDataEmissao.Clear;
  edtCodigoCliente.Clear;
  LimparCliente;
  LimparItem;
  ExibirItens;

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

procedure TFrmPedidoVenda.edtCodigoProdutoExit(Sender: TObject);
var
  LCodigo: Integer;
  LProduto: TProduto;
begin

  if Trim(edtCodigoProduto.Text) = '' then
  begin
    LimparProduto;
    Exit;
  end;

  if not TryStrToInt(edtCodigoProduto.Text, LCodigo) then
  begin
    LimparProduto;
    MessageDlg('Código do produto inválido.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if LCodigo = FCodigoProdutoExibido then
    Exit;

  LimparProduto;

  try
    LProduto := FController.BuscarProduto(LCodigo);
  except
    on E: EValidacao do
    begin
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
      Exit;
    end;
  end;

  try
    FCodigoProdutoExibido := LProduto.Codigo;
    edtDescricaoProduto.Text := LProduto.Descricao;
    edtValorUnitario.Text := FormatFloat('0.00', LProduto.PrecoVenda);

    if Trim(edtQuantidade.Text) = '' then
      edtQuantidade.Text := '1';
  finally
    LProduto.Free;
  end;

end;

procedure TFrmPedidoVenda.LimparProduto;
begin

  FCodigoProdutoExibido := 0;
  edtDescricaoProduto.Clear;
  edtValorUnitario.Clear;

end;

procedure TFrmPedidoVenda.btnInserirAtualizarItemClick(Sender: TObject);
var
  LQuantidade: Integer;
  LValorUnitario: Currency;
  LItem: TPedidoItem;
begin

  // O atalho Alt+I clica no botão sem tirar o foco do código, então o OnExit pode não ter rodado.
  edtCodigoProdutoExit(edtCodigoProduto);

  if FCodigoProdutoExibido = 0 then
  begin
    if Trim(edtCodigoProduto.Text) = '' then
      MessageDlg('Informe o produto.', mtWarning, [mbOK], 0);

    edtCodigoProduto.SetFocus;
    Exit;
  end;

  if not TryStrToInt(edtQuantidade.Text, LQuantidade) or (LQuantidade <= 0) then
  begin
    MessageDlg('Informe uma quantidade maior que zero.', mtWarning, [mbOK], 0);
    edtQuantidade.SetFocus;
    Exit;
  end;

  if not TryStrToCurr(edtValorUnitario.Text, LValorUnitario) or (LValorUnitario < 0) then
  begin
    MessageDlg('Informe um valor unitário maior ou igual a zero.', mtWarning, [mbOK], 0);
    edtValorUnitario.SetFocus;
    Exit;
  end;

  if FIndiceEmEdicao = -1 then
  begin
    LItem := TPedidoItem.Create;
    FPedido.Itens.Add(LItem);
  end
  else
    LItem := FPedido.Itens[FIndiceEmEdicao];

  LItem.CodigoProduto := FCodigoProdutoExibido;
  LItem.DescricaoProduto := edtDescricaoProduto.Text;
  LItem.Quantidade := LQuantidade;
  LItem.ValorUnitario := LValorUnitario;

  ExibirItens;
  LimparItem;
  edtCodigoProduto.SetFocus;

end;

procedure TFrmPedidoVenda.LimparItem;
begin

  FIndiceEmEdicao := -1;
  btnInserirAtualizarItem.Caption := '&Inserir Item';
  edtCodigoProduto.Clear;
  edtQuantidade.Clear;
  LimparProduto;

end;

procedure TFrmPedidoVenda.ExibirItens;
var
  LIndice: Integer;
  LItem: TPedidoItem;
begin

  grdItens.RowCount := Max(FPedido.Itens.Count, 1) + 1;
  grdItens.Rows[1].Clear;

  for LIndice := 0 to FPedido.Itens.Count - 1 do
  begin
    LItem := FPedido.Itens[LIndice];
    grdItens.Cells[0, LIndice + 1] := IntToStr(LItem.CodigoProduto);
    grdItens.Cells[1, LIndice + 1] := LItem.DescricaoProduto;
    grdItens.Cells[2, LIndice + 1] := IntToStr(LItem.Quantidade);
    grdItens.Cells[3, LIndice + 1] := FormatFloat('#,##0.00', LItem.ValorUnitario);
    grdItens.Cells[4, LIndice + 1] := FormatFloat('#,##0.00', LItem.ValorTotal);
  end;

  lblValorTotal.Caption := FormatFloat('#,##0.00', FPedido.ValorTotal);

end;

procedure TFrmPedidoVenda.grdItensDblClick(Sender: TObject);
begin

  CarregarItemSelecionado;

end;

procedure TFrmPedidoVenda.grdItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  case Key of
    VK_RETURN:
      begin
        CarregarItemSelecionado;
        Key := 0;
      end;
    VK_DELETE:
      begin
        ExcluirItemSelecionado;
        Key := 0;
      end;
  end;

end;

// A linha 0 do grid é o título: a linha N mostra o item N - 1. Devolve -1 se não houver item selecionado.
function TFrmPedidoVenda.IndiceItemSelecionado: Integer;
begin

  Result := grdItens.Row - 1;

  if (Result < 0) or (Result >= FPedido.Itens.Count) then
    Result := -1;

end;

procedure TFrmPedidoVenda.CarregarItemSelecionado;
var
  LIndice: Integer;
  LItem: TPedidoItem;
begin

  LIndice := IndiceItemSelecionado;

  if LIndice = -1 then
    Exit;

  LItem := FPedido.Itens[LIndice];

  FIndiceEmEdicao := LIndice;
  FCodigoProdutoExibido := LItem.CodigoProduto;
  edtCodigoProduto.Text := IntToStr(LItem.CodigoProduto);
  edtDescricaoProduto.Text := LItem.DescricaoProduto;
  edtQuantidade.Text := IntToStr(LItem.Quantidade);
  edtValorUnitario.Text := FormatFloat('0.00', LItem.ValorUnitario);
  btnInserirAtualizarItem.Caption := '&Atualizar Item';

  edtQuantidade.SetFocus;

end;

procedure TFrmPedidoVenda.ExcluirItemSelecionado;
var
  LIndice: Integer;
begin

  LIndice := IndiceItemSelecionado;

  if LIndice = -1 then
    Exit;

  if MessageDlg(Format('Excluir o item %d (%s)?', [LIndice + 1, FPedido.Itens[LIndice].DescricaoProduto]),
    mtConfirmation, [mbYes, mbNo], 0, mbNo) <> mrYes then
    Exit;

  if LIndice = FIndiceEmEdicao then
    LimparItem
  else if LIndice < FIndiceEmEdicao then
    Dec(FIndiceEmEdicao);

  FPedido.Itens.Delete(LIndice);
  ExibirItens;

end;

procedure TFrmPedidoVenda.btnBuscarClick(Sender: TObject);
begin

  CarregarLista;

end;

procedure TFrmPedidoVenda.edtBuscaKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin
    Key := #0;
    CarregarLista;
  end;

end;

procedure TFrmPedidoVenda.CarregarLista;
begin

  FController.Listar(edtBusca.Text, mtLista);

end;

procedure TFrmPedidoVenda.btnGravarPedidoClick(Sender: TObject);
begin

  // Mesmo motivo do Alt+I: o atalho Alt+G não dispara o OnExit do código do cliente.
  if Trim(edtCodigoCliente.Text) <> IntToStr(FPedido.CodigoCliente) then
    edtCodigoClienteExit(edtCodigoCliente);

  try
    FController.Gravar(FPedido);
  except
    on E: EValidacao do
    begin
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
      Exit;
    end;
    on E: Exception do
    begin
      MessageDlg('Não foi possível gravar o pedido.' + sLineBreak + E.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  MessageDlg(Format('Pedido %d gravado com sucesso.', [FPedido.NumeroPedido]), mtInformation, [mbOK], 0);

  FreeAndNil(FPedido);
  CarregarLista;
  cpnPedido.ActiveCard := crdLista;

end;

end.

