# pedido-venda-delphi

Pedido de Venda em Delphi com FireDAC e Firebird.

## Requisitos

- Windows 10 ou 11 (64 bits)
- Firebird 3.0 ou mais novo (testado no 5.0.4 x64)
- Delphi 13, para compilar

## 1. Instalar o Firebird

Baixe em [firebirdsql.org](https://firebirdsql.org/en/firebird-5-0/) o instalador Windows x64 e instale com as opções padrão. Anote a senha do SYSDBA.

## 2. Criar o banco

No PowerShell:

```powershell
mkdir C:\PedidoVenda
& "C:\Program Files\Firebird\Firebird_5_0\isql.exe" -user SYSDBA -password SUA_SENHA
```

No `SQL>`:

```sql
CREATE DATABASE 'localhost:C:\PedidoVenda\PEDIDO_VENDA.FDB' DEFAULT CHARACTER SET UTF8;
quit;
```

## 3. Rodar o script

Abra o [`db/db.sql`](db/db.sql) numa ferramenta SQL (ex.: DBeaver), conectada ao banco em modo auto-commit, e execute como script. Ele cria as tabelas e cadastra 12 clientes e 12 produtos para teste.

## 4. Configurar

Em construção.

## 5. Executar

Em construção.

## 6. Roteiro de testes

Em construção.
