unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.WinXCtrls, Vcl.ComCtrls;

type
  TFrmPrincipal = class(TForm)
    pnlTopo: TPanel;
    lblMenu: TLabel;
    lblTitulo: TLabel;
    svMenu: TSplitView;
    btnInicio: TSpeedButton;
    btnPedidoVenda: TSpeedButton;
    btnSair: TSpeedButton;
    pnlConteudo: TPanel;
    pnlCartao: TPanel;
    lblBemVindo: TLabel;
    pgcTelas: TPageControl;
    tabInicio: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure lblMenuClick(Sender: TObject);
    procedure btnInicioClick(Sender: TObject);
    procedure btnPedidoVendaClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pgcTelasChange(Sender: TObject);
  private
    { Private declarations }
    procedure SelecionarModulo(const ATitulo: string);
    procedure AbrirTela(const AClasse: TFormClass; const ATitulo: string);
    procedure TelaFechada(Sender: TObject; var Action: TCloseAction);
    procedure FecharAba(const AAba: TTabSheet);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  View.PedidoVenda;

{$R *.dfm}

// Mostra o nome do módulo ativo na barra do topo, ao lado do menu.
procedure TFrmPrincipal.SelecionarModulo(const ATitulo: string);
begin
  lblTitulo.Caption := ATitulo;
end;

// Ativa a aba da tela se ela já estiver aberta; senão cria a tela numa aba nova. As telas abertas ficam vivas.
procedure TFrmPrincipal.AbrirTela(const AClasse: TFormClass; const ATitulo: string);
var
  LIndice: Integer;
  LAba: TTabSheet;
  LTela: TForm;
begin

  LAba := nil;

  for LIndice := 0 to pgcTelas.PageCount - 1 do
    if pgcTelas.Pages[LIndice].Controls[0].ClassType = AClasse then
      LAba := pgcTelas.Pages[LIndice];

  if LAba = nil then
  begin

    LTela := AClasse.Create(Self);

    LAba := TTabSheet.Create(pgcTelas);
    LAba.PageControl := pgcTelas;
    LAba.Caption := ATitulo;

    LTela.OnClose := TelaFechada;
    LTela.Parent := LAba;
    LTela.Align := alClient;
    LTela.Show;

  end;

  pgcTelas.ActivePage := LAba;
  SelecionarModulo(ATitulo);

end;

procedure TFrmPrincipal.pgcTelasChange(Sender: TObject);
begin

  SelecionarModulo(pgcTelas.ActivePage.Caption);

end;

// A tela chamou Close (botão Sair). A aba, e a tela dentro dela, só é liberada depois que o clique termina:
// liberar o form dentro do evento de clique do próprio botão causa Access Violation.
procedure TFrmPrincipal.TelaFechada(Sender: TObject; var Action: TCloseAction);
var
  LAba: TTabSheet;
begin

  Action := caNone;
  LAba := TForm(Sender).Parent as TTabSheet;

  TThread.ForceQueue(nil,
    procedure
    begin
      FecharAba(LAba);
    end);

end;

procedure TFrmPrincipal.FecharAba(const AAba: TTabSheet);
begin

  AAba.Free;

  pgcTelas.ActivePage := pgcTelas.Pages[pgcTelas.PageCount - 1];
  SelecionarModulo(pgcTelas.ActivePage.Caption);

end;

procedure TFrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageDlg('Deseja sair do sistema?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  btnInicio.Click;
end;

procedure TFrmPrincipal.btnInicioClick(Sender: TObject);
begin
  pgcTelas.ActivePage := tabInicio;
  SelecionarModulo(tabInicio.Caption);
end;

procedure TFrmPrincipal.btnPedidoVendaClick(Sender: TObject);
begin
  AbrirTela(TFrmPedidoVenda, btnPedidoVenda.Caption);
end;

procedure TFrmPrincipal.lblMenuClick(Sender: TObject);
begin
  svMenu.Opened := not svMenu.Opened;
end;

procedure TFrmPrincipal.btnSairClick(Sender: TObject);
begin
  Close;
end;

end.
