unit View.Base;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Comp.Client;

type
  TFrmBase = class(TForm)
  private
    FConexao: TFDConnection;
  protected
    property Conexao: TFDConnection read FConexao;
  public
    constructor Create(AOwner: TComponent; const AConexao: TFDConnection); reintroduce; virtual;
    function TemAlteracaoNaoGravada: Boolean; virtual;
  end;

  TFrmBaseClass = class of TFrmBase;

implementation

{$R *.dfm}

constructor TFrmBase.Create(AOwner: TComponent; const AConexao: TFDConnection);
begin
  inherited Create(AOwner);
  FConexao := AConexao;
end;

// A tela que guarda dados ainda não gravados sobrescreve, para a principal avisar antes de fechar o sistema.
function TFrmBase.TemAlteracaoNaoGravada: Boolean;
begin

  Result := False;

end;

end.

