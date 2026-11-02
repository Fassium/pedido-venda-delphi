unit Repositorio.Pedido;

interface

uses
  FireDAC.Comp.Client, Model.Pedido;

type
  IRepositorioPedido = interface
    ['{FFC9529B-2AC2-4CFC-B9C0-60D5113CDC83}']
    function BuscarPorNumero(const ANumeroPedido: Int64): TPedido;
    procedure Inserir(const APedido: TPedido);
    procedure Atualizar(const APedido: TPedido);
    procedure Listar(const AFiltro: string; const ADestino: TFDMemTable);
  end;

  TRepositorioPedido = class(TInterfacedObject, IRepositorioPedido)
  private
    FConexao: TFDConnection;
    procedure AtribuirObservacao(const AConsulta: TFDQuery; const AObservacao: string);
    procedure InserirItens(const APedido: TPedido);
    procedure ExcluirItens(const ANumeroPedido: Int64);
  public
    constructor Create(const AConexao: TFDConnection);
    function BuscarPorNumero(const ANumeroPedido: Int64): TPedido;
    procedure Inserir(const APedido: TPedido);
    procedure Atualizar(const APedido: TPedido);
    procedure Listar(const AFiltro: string; const ADestino: TFDMemTable);
  end;

implementation

uses
  System.SysUtils, Data.DB, FireDAC.Comp.DataSet, Model.PedidoItem;

constructor TRepositorioPedido.Create(const AConexao: TFDConnection);
begin
  inherited Create;
  FConexao := AConexao;
end;

// Devolve nil se o pedido não existir. Quem chama fica dono do objeto.
function TRepositorioPedido.BuscarPorNumero(const ANumeroPedido: Int64): TPedido;
var
  LConsulta: TFDQuery;
  LItem: TPedidoItem;
begin
  Result := nil;

  LConsulta := TFDQuery.Create(nil);
  try
    LConsulta.Connection := FConexao;
    LConsulta.SQL.Text :=
      'SELECT NUMERO_PEDIDO, DATA_EMISSAO, CODIGO_CLIENTE, OBSERVACAO ' +
      'FROM PEDIDO ' +
      'WHERE NUMERO_PEDIDO = :NUMERO_PEDIDO';
    LConsulta.ParamByName('NUMERO_PEDIDO').AsLargeInt := ANumeroPedido;
    LConsulta.Open;

    if LConsulta.IsEmpty then
      Exit;

    Result := TPedido.Create;
    try
      Result.NumeroPedido := LConsulta.FieldByName('NUMERO_PEDIDO').AsLargeInt;
      Result.DataEmissao := LConsulta.FieldByName('DATA_EMISSAO').AsDateTime;
      Result.CodigoCliente := LConsulta.FieldByName('CODIGO_CLIENTE').AsInteger;
      Result.Observacao := LConsulta.FieldByName('OBSERVACAO').AsString;

      // ORDER BY ID devolve os itens na ordem em que foram lançados.
      LConsulta.Close;
      LConsulta.SQL.Text :=
        'SELECT I.ID, I.CODIGO_PRODUTO, P.DESCRICAO, I.QUANTIDADE, I.VLR_UNITARIO ' +
        'FROM PEDIDO_ITEM I ' +
        'INNER JOIN PRODUTO P ON P.CODIGO = I.CODIGO_PRODUTO ' +
        'WHERE I.NUMERO_PEDIDO = :NUMERO_PEDIDO ' +
        'ORDER BY I.ID';
      LConsulta.ParamByName('NUMERO_PEDIDO').AsLargeInt := ANumeroPedido;
      LConsulta.Open;

      while not LConsulta.Eof do
      begin
        // Entra na lista logo após criar: se algo falhar, o pedido libera o item.
        LItem := TPedidoItem.Create;
        Result.Itens.Add(LItem);

        LItem.Id := LConsulta.FieldByName('ID').AsLargeInt;
        LItem.CodigoProduto := LConsulta.FieldByName('CODIGO_PRODUTO').AsInteger;
        LItem.DescricaoProduto := LConsulta.FieldByName('DESCRICAO').AsString;
        LItem.Quantidade := LConsulta.FieldByName('QUANTIDADE').AsInteger;
        LItem.ValorUnitario := LConsulta.FieldByName('VLR_UNITARIO').AsCurrency;

        LConsulta.Next;
      end;
    except
      Result.Free;
      raise;
    end;
  finally
    LConsulta.Free;
  end;
end;

// Não abre transação: quem chama (o Service) controla o commit e o rollback.
procedure TRepositorioPedido.Inserir(const APedido: TPedido);
var
  LConsulta: TFDQuery;
begin
  LConsulta := TFDQuery.Create(nil);
  try
    LConsulta.Connection := FConexao;
    LConsulta.SQL.Text :=
      'INSERT INTO PEDIDO (NUMERO_PEDIDO, DATA_EMISSAO, CODIGO_CLIENTE, VALOR_TOTAL, OBSERVACAO) ' +
      'VALUES (NEXT VALUE FOR SEQ_PEDIDO_NUMERO, :DATA_EMISSAO, :CODIGO_CLIENTE, :VALOR_TOTAL, :OBSERVACAO) ' +
      'RETURNING NUMERO_PEDIDO';
    LConsulta.ParamByName('DATA_EMISSAO').AsDate := APedido.DataEmissao;
    LConsulta.ParamByName('CODIGO_CLIENTE').AsInteger := APedido.CodigoCliente;
    LConsulta.ParamByName('VALOR_TOTAL').AsCurrency := APedido.ValorTotal;
    AtribuirObservacao(LConsulta, APedido.Observacao);
    LConsulta.Open;

    APedido.NumeroPedido := LConsulta.FieldByName('NUMERO_PEDIDO').AsLargeInt;
  finally
    LConsulta.Free;
  end;

  InserirItens(APedido);
end;

// Não abre transação. Os itens são apagados e regravados: mais simples e seguro que comparar item a item;
// o custo é os itens ganharem IDs novos. A data de emissão não muda na edição.
procedure TRepositorioPedido.Atualizar(const APedido: TPedido);
var
  LConsulta: TFDQuery;
begin
  LConsulta := TFDQuery.Create(nil);
  try
    LConsulta.Connection := FConexao;
    LConsulta.SQL.Text :=
      'UPDATE PEDIDO SET CODIGO_CLIENTE = :CODIGO_CLIENTE, VALOR_TOTAL = :VALOR_TOTAL, OBSERVACAO = :OBSERVACAO ' +
      'WHERE NUMERO_PEDIDO = :NUMERO_PEDIDO';
    LConsulta.ParamByName('CODIGO_CLIENTE').AsInteger := APedido.CodigoCliente;
    LConsulta.ParamByName('VALOR_TOTAL').AsCurrency := APedido.ValorTotal;
    AtribuirObservacao(LConsulta, APedido.Observacao);
    LConsulta.ParamByName('NUMERO_PEDIDO').AsLargeInt := APedido.NumeroPedido;
    LConsulta.ExecSQL;

    // Nenhuma linha alterada: o pedido foi apagado depois de carregado (ex.: cancelado em outra estação).
    if LConsulta.RowsAffected = 0 then
      raise Exception.CreateFmt('O pedido %d não existe mais.', [APedido.NumeroPedido]);
  finally
    LConsulta.Free;
  end;

  ExcluirItens(APedido.NumeroPedido);
  InserirItens(APedido);
end;

// Observação em branco vai como NULL: "não informada", e não um texto vazio.
procedure TRepositorioPedido.AtribuirObservacao(const AConsulta: TFDQuery; const AObservacao: string);
begin
  AConsulta.ParamByName('OBSERVACAO').AsString := AObservacao;
  if AObservacao = '' then
    AConsulta.ParamByName('OBSERVACAO').Clear;
end;

// A mesma query é preparada uma vez e executada para cada item, só trocando os parâmetros.
procedure TRepositorioPedido.InserirItens(const APedido: TPedido);
var
  LConsulta: TFDQuery;
  LItem: TPedidoItem;
begin
  LConsulta := TFDQuery.Create(nil);
  try
    LConsulta.Connection := FConexao;
    LConsulta.SQL.Text :=
      'INSERT INTO PEDIDO_ITEM (NUMERO_PEDIDO, CODIGO_PRODUTO, QUANTIDADE, VLR_UNITARIO, VLR_TOTAL) ' +
      'VALUES (:NUMERO_PEDIDO, :CODIGO_PRODUTO, :QUANTIDADE, :VLR_UNITARIO, :VLR_TOTAL) ' +
      'RETURNING ID';

    // Sem isso o Prepare pega o tipo do banco (NUMERIC = FMTBcd) e o AsCurrency depois gera o erro -338.
    LConsulta.ParamByName('VLR_UNITARIO').DataType := ftCurrency;
    LConsulta.ParamByName('VLR_TOTAL').DataType := ftCurrency;
    LConsulta.Prepare;

    for LItem in APedido.Itens do
    begin
      LConsulta.Close;
      LConsulta.ParamByName('NUMERO_PEDIDO').AsLargeInt := APedido.NumeroPedido;
      LConsulta.ParamByName('CODIGO_PRODUTO').AsInteger := LItem.CodigoProduto;
      LConsulta.ParamByName('QUANTIDADE').AsInteger := LItem.Quantidade;
      LConsulta.ParamByName('VLR_UNITARIO').AsCurrency := LItem.ValorUnitario;
      LConsulta.ParamByName('VLR_TOTAL').AsCurrency := LItem.ValorTotal;
      LConsulta.Open;

      LItem.Id := LConsulta.FieldByName('ID').AsLargeInt;
    end;
  finally
    LConsulta.Free;
  end;
end;

procedure TRepositorioPedido.ExcluirItens(const ANumeroPedido: Int64);
var
  LConsulta: TFDQuery;
begin
  LConsulta := TFDQuery.Create(nil);
  try
    LConsulta.Connection := FConexao;
    LConsulta.SQL.Text := 'DELETE FROM PEDIDO_ITEM WHERE NUMERO_PEDIDO = :NUMERO_PEDIDO';
    LConsulta.ParamByName('NUMERO_PEDIDO').AsLargeInt := ANumeroPedido;
    LConsulta.ExecSQL;
  finally
    LConsulta.Free;
  end;
end;

// Filtro vazio lista tudo; só dígitos busca pelo número (usa a PK); texto busca no nome do cliente.
procedure TRepositorioPedido.Listar(const AFiltro: string; const ADestino: TFDMemTable);
var
  LConsulta: TFDQuery;
  LFiltro: string;
  LNumero: Int64;
begin
  LFiltro := Trim(AFiltro);

  LConsulta := TFDQuery.Create(nil);
  try
    LConsulta.Connection := FConexao;
    LConsulta.SQL.Text :=
      'SELECT P.NUMERO_PEDIDO, P.DATA_EMISSAO, P.CODIGO_CLIENTE, C.NOME AS NOME_CLIENTE, P.VALOR_TOTAL, P.OBSERVACAO ' +
      'FROM PEDIDO P ' +
      'INNER JOIN CLIENTE C ON C.CODIGO = P.CODIGO_CLIENTE';

    // O SQL fica completo antes dos parâmetros: mudar o SQL depois recria os parâmetros.
    if TryStrToInt64(LFiltro, LNumero) then
    begin
      LConsulta.SQL.Add('WHERE P.NUMERO_PEDIDO = :NUMERO_PEDIDO');
      LConsulta.SQL.Add('ORDER BY P.NUMERO_PEDIDO DESC');
      LConsulta.ParamByName('NUMERO_PEDIDO').AsLargeInt := LNumero;
    end
    else if LFiltro <> '' then
    begin
      LConsulta.SQL.Add('WHERE C.NOME CONTAINING :NOME');
      LConsulta.SQL.Add('ORDER BY P.NUMERO_PEDIDO DESC');
      LConsulta.ParamByName('NOME').AsString := LFiltro;
    end
    else
      LConsulta.SQL.Add('ORDER BY P.NUMERO_PEDIDO DESC');

    LConsulta.Open;

    if not ADestino.Active then
      ADestino.CreateDataSet;

    ADestino.EmptyDataSet;
    ADestino.CopyDataSet(LConsulta, [coAppend]);
    ADestino.First;
  finally
    LConsulta.Free;
  end;
end;

end.
