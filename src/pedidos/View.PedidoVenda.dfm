inherited FrmPedidoVenda: TFrmPedidoVenda
  Caption = 'Pedido de Venda'
  ClientHeight = 600
  ClientWidth = 1000
  TextHeight = 15
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  object cpnPedido: TCardPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 600
    Align = alClient
    ActiveCard = crdLista
    BevelOuter = bvNone
    Caption = ''
    TabOrder = 0
    object crdLista: TCard
      Left = 0
      Top = 0
      Width = 1000
      Height = 600
      Caption = ''
      CardIndex = 0
      TabOrder = 0
      object pnlLista: TPanel
        Left = 0
        Top = 0
        Width = 1000
        Height = 600
        Align = alClient
        BevelOuter = bvNone
        Color = 15920617
        Padding.Left = 16
        Padding.Top = 16
        Padding.Right = 16
        Padding.Bottom = 16
        ParentBackground = False
        ShowCaption = False
        TabOrder = 0
        StyleElements = [seFont, seBorder]
        object pnlFiltro: TPanel
          Left = 16
          Top = 16
          Width = 968
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          ShowCaption = False
          TabOrder = 0
          StyleElements = [seFont, seBorder]
          DesignSize = (
            968
            41)
          object edtBusca: TEdit
            Left = 0
            Top = 8
            Width = 300
            Height = 23
            TabOrder = 0
            OnKeyPress = edtBuscaKeyPress
            TextHint = 'N'#186' do pedido ou nome do cliente'
          end
          object btnBuscar: TButton
            Left = 304
            Top = 7
            Width = 80
            Height = 25
            Caption = '&Buscar'
            TabOrder = 1
            OnClick = btnBuscarClick
          end
          object btnNovo: TButton
            Left = 596
            Top = 7
            Width = 80
            Height = 25
            Anchors = [akTop, akRight]
            Caption = '&Novo'
            TabOrder = 2
            OnClick = btnNovoClick
          end
          object btnEditar: TButton
            Left = 680
            Top = 7
            Width = 80
            Height = 25
            Anchors = [akTop, akRight]
            Caption = '&Editar'
            TabOrder = 3
            OnClick = btnEditarClick
          end
          object btnCancelarPedido: TButton
            Left = 764
            Top = 7
            Width = 120
            Height = 25
            Anchors = [akTop, akRight]
            Caption = '&Cancelar Pedido'
            TabOrder = 4
          end
          object btnSair: TButton
            Left = 888
            Top = 7
            Width = 80
            Height = 25
            Anchors = [akTop, akRight]
            Caption = '&Sair'
            TabOrder = 5
            OnClick = btnSairClick
          end
        end
        object dbgLista: TDBGrid
          Left = 16
          Top = 57
          Width = 968
          Height = 527
          Align = alClient
          DataSource = dsLista
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
    end
    object crdPedido: TCard
      Left = 0
      Top = 0
      Width = 1000
      Height = 600
      Caption = ''
      CardIndex = 1
      TabOrder = 1
      object pnlPedido: TPanel
        Left = 0
        Top = 0
        Width = 1000
        Height = 600
        Align = alClient
        BevelOuter = bvNone
        Color = 15920617
        Padding.Left = 16
        Padding.Top = 16
        Padding.Right = 16
        Padding.Bottom = 16
        ParentBackground = False
        ShowCaption = False
        TabOrder = 0
        StyleElements = [seFont, seBorder]
        object pnlCabecalho: TPanel
          Left = 16
          Top = 16
          Width = 968
          Height = 115
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          ShowCaption = False
          TabOrder = 0
          StyleElements = [seFont, seBorder]
          object lblNumeroPedido: TLabel
            Left = 0
            Top = 8
            Height = 15
            Caption = 'Pedido'
            FocusControl = edtNumeroPedido
          end
          object lblDataEmissao: TLabel
            Left = 98
            Top = 8
            Height = 15
            Caption = 'Emiss'#227'o'
            FocusControl = edtDataEmissao
          end
          object lblCodigoCliente: TLabel
            Left = 196
            Top = 8
            Height = 15
            Caption = 'C&liente'
            FocusControl = edtCodigoCliente
          end
          object lblNomeCliente: TLabel
            Left = 284
            Top = 8
            Height = 15
            Caption = 'Nome'
            FocusControl = edtNomeCliente
          end
          object lblCidadeCliente: TLabel
            Left = 592
            Top = 8
            Height = 15
            Caption = 'Cidade'
            FocusControl = edtCidadeCliente
          end
          object lblUFCliente: TLabel
            Left = 780
            Top = 8
            Height = 15
            Caption = 'UF'
            FocusControl = edtUFCliente
          end
          object lblObservacao: TLabel
            Left = 0
            Top = 58
            Height = 15
            Caption = '&Observa'#231#227'o'
            FocusControl = edtObservacao
          end
          object edtNumeroPedido: TEdit
            Left = 0
            Top = 26
            Width = 90
            Height = 23
            Enabled = False
            TabOrder = 0
          end
          object edtDataEmissao: TEdit
            Left = 98
            Top = 26
            Width = 90
            Height = 23
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
          end
          object edtCodigoCliente: TEdit
            Left = 196
            Top = 26
            Width = 80
            Height = 23
            NumbersOnly = True
            TabOrder = 2
            OnExit = edtCodigoClienteExit
          end
          object edtNomeCliente: TEdit
            Left = 284
            Top = 26
            Width = 300
            Height = 23
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 3
          end
          object edtCidadeCliente: TEdit
            Left = 592
            Top = 26
            Width = 180
            Height = 23
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 4
          end
          object edtUFCliente: TEdit
            Left = 780
            Top = 26
            Width = 40
            Height = 23
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 5
          end
          object edtObservacao: TEdit
            Left = 0
            Top = 76
            Width = 820
            Height = 23
            MaxLength = 200
            TabOrder = 6
          end
        end
        object pnlItem: TPanel
          Left = 16
          Top = 131
          Width = 968
          Height = 65
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          ShowCaption = False
          TabOrder = 1
          StyleElements = [seFont, seBorder]
          object lblCodigoProduto: TLabel
            Left = 0
            Top = 8
            Height = 15
            Caption = '&Produto'
            FocusControl = edtCodigoProduto
          end
          object lblDescricaoProduto: TLabel
            Left = 88
            Top = 8
            Height = 15
            Caption = 'Descri'#231#227'o'
            FocusControl = edtDescricaoProduto
          end
          object lblQuantidade: TLabel
            Left = 446
            Top = 8
            Height = 15
            Caption = '&Quantidade'
            FocusControl = edtQuantidade
          end
          object lblValorUnitario: TLabel
            Left = 534
            Top = 8
            Height = 15
            Caption = '&Vlr. Unit'#225'rio'
            FocusControl = edtValorUnitario
          end
          object edtCodigoProduto: TEdit
            Left = 0
            Top = 26
            Width = 80
            Height = 23
            NumbersOnly = True
            TabOrder = 0
            OnExit = edtCodigoProdutoExit
          end
          object edtDescricaoProduto: TEdit
            Left = 88
            Top = 26
            Width = 350
            Height = 23
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
          end
          object edtQuantidade: TEdit
            Left = 446
            Top = 26
            Width = 80
            Height = 23
            NumbersOnly = True
            TabOrder = 2
          end
          object edtValorUnitario: TEdit
            Left = 534
            Top = 26
            Width = 100
            Height = 23
            Alignment = taRightJustify
            TabOrder = 3
          end
          object btnInserirAtualizarItem: TButton
            Left = 642
            Top = 25
            Width = 150
            Height = 25
            Caption = '&Inserir/Atualizar Item'
            TabOrder = 4
            OnClick = btnInserirAtualizarItemClick
          end
        end
        object grdItens: TStringGrid
          Left = 16
          Top = 196
          Width = 968
          Height = 338
          Align = alClient
          ColCount = 5
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          TabOrder = 2
          OnDblClick = grdItensDblClick
          OnKeyDown = grdItensKeyDown
        end
        object pnlRodape: TPanel
          Left = 16
          Top = 534
          Width = 968
          Height = 50
          Align = alBottom
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          ShowCaption = False
          TabOrder = 3
          StyleElements = [seFont, seBorder]
          DesignSize = (
            968
            50)
          object lblTituloTotal: TLabel
            Left = 0
            Top = 16
            Height = 15
            Caption = 'Valor Total do Pedido:'
          end
          object lblValorTotal: TLabel
            Left = 134
            Top = 12
            Height = 21
            Caption = '0,00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object btnGravarPedido: TButton
            Left = 730
            Top = 12
            Width = 130
            Height = 25
            Anchors = [akTop, akRight]
            Caption = '&Gravar Pedido'
            TabOrder = 0
            OnClick = btnGravarPedidoClick
          end
          object btnDescartar: TButton
            Left = 868
            Top = 12
            Width = 100
            Height = 25
            Anchors = [akTop, akRight]
            Caption = '&Descartar'
            TabOrder = 1
            OnClick = btnDescartarClick
          end
        end
      end
    end
  end
  object mtLista: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 456
    Top = 288
    object mtListaNUMERO_PEDIDO: TLargeintField
      DisplayLabel = 'N'#186' Pedido'
      DisplayWidth = 10
      FieldName = 'NUMERO_PEDIDO'
    end
    object mtListaDATA_EMISSAO: TDateField
      DisplayLabel = 'Emiss'#227'o'
      FieldName = 'DATA_EMISSAO'
    end
    object mtListaCODIGO_CLIENTE: TIntegerField
      DisplayLabel = 'C'#243'd. Cliente'
      FieldName = 'CODIGO_CLIENTE'
    end
    object mtListaNOME_CLIENTE: TStringField
      DisplayLabel = 'Cliente'
      DisplayWidth = 50
      FieldName = 'NOME_CLIENTE'
      Size = 100
    end
    object mtListaVALOR_TOTAL: TBCDField
      DisplayLabel = 'Valor Total'
      FieldName = 'VALOR_TOTAL'
      currency = True
      Precision = 15
      Size = 2
    end
    object mtListaOBSERVACAO: TStringField
      DisplayLabel = 'Observa'#231#227'o'
      DisplayWidth = 50
      FieldName = 'OBSERVACAO'
      Size = 200
    end
  end
  object dsLista: TDataSource
    DataSet = mtLista
    Left = 536
    Top = 288
  end
end
