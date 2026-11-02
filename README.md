# pedido-venda-delphi

Pedido de Venda em Delphi com FireDAC e Firebird, organizado em camadas (View, Controller, Service, Repository e Infra).

**Autor:** Thiago Fassina · desenvolvido em *pair programming* com [Claude Code](https://claude.com/claude-code) (Anthropic).

O passo a passo da construção, com o que foi feito e o que falta em cada etapa, está em [`doc/trilha.html`](doc/trilha.html). Para ver formatado, baixe o arquivo e abra no navegador.

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

O programa lê o `config.ini` da mesma pasta do executável (`bin\config.ini`). O repositório já traz esse arquivo pronto para o banco local do passo 2; o [`config.ini.example`](config.ini.example) mostra as mesmas chaves com valores de exemplo.

| Chave | O que é |
|---|---|
| `Server` | Servidor do Firebird (ex.: `localhost`) |
| `Port` | Porta do Firebird (padrão `3050`) |
| `Database` | Caminho do `.fdb` no servidor |
| `Username` / `Password` | Usuário e senha do banco |
| `ClientLibrary` | Caminho do `fbclient.dll`, relativo à pasta do INI ou absoluto |

Ajuste `Password` se a senha do SYSDBA for outra. O `bin` já traz o `fbclient.dll` x64 e o runtime do Visual C++ que ele usa, então não é preciso copiar nada para o Windows.

## 5. Executar

1. Abra o `PedidoVenda.dproj` no Delphi 13, com a plataforma **Windows 64-bit**.
2. Compile e rode (F9). O executável é gerado em `bin\PedidoVenda.exe`.
3. Entre com `thiago@fassium.com` / `admin123`. O login é só demonstrativo (credencial fixa no código).
4. No menu lateral, abra **Pedido de Venda**.

## 6. Roteiro de testes

**Lista e novo pedido**

1. A tela abre na lista de pedidos. Clique em **Novo**: aparece o pedido com a data de hoje e o cursor no Cliente.

**Cliente (2.1)**

2. Digite `1` e Tab: aparecem Nome, Cidade e UF, que não podem ser editados.
3. Digite `99` e Tab: aviso "Cliente 99 não encontrado." e os campos do cliente ficam vazios.

**Itens (2.2 e 2.3)**

4. Produto `1` e Tab: aparecem a descrição e o preço de venda em Vlr. Unitário, e a quantidade vem 1.
5. Altere o valor unitário e clique em **Inserir Item**: a linha entra no grid com o valor digitado e o total do rodapé muda.
6. Insira o mesmo produto de novo: ele entra em outra linha.
7. Tente inserir com quantidade 0 ou valor inválido: aviso e foco no campo com problema.

**Edição e exclusão pelo teclado (2.4 e 4.2)**

8. Selecione uma linha do grid e aperte **ENTER**: os campos são carregados e o botão vira **Atualizar Item**. Mude a quantidade e confirme: a mesma linha é alterada.
9. Selecione uma linha e aperte **DEL**: confirme e veja a linha sair e o total ser recalculado na hora.

**Gravar (2.6 e 4.1)**

10. Clique em **Gravar Pedido** sem cliente: aviso e foco no Cliente. Com cliente e sem itens: aviso e foco no Produto.
11. Com cliente e itens, clique em **Gravar Pedido**: aparece "Pedido N gravado com sucesso." e a lista mostra o pedido com o nome do cliente e o total.
12. Grave um pedido com **Observação** e outro com ela em branco: a lista mostra o texto no primeiro e a coluna vazia no segundo (no banco, `SELECT NUMERO_PEDIDO, OBSERVACAO FROM PEDIDO` mostra `NULL`).
13. Na lista, filtre pelo número do pedido ou por parte do nome do cliente e aperte Enter.

**Editar pedido (bônus)**

14. Na lista, selecione um pedido, clique em **Editar** e confirme: o pedido abre com número, data, cliente, observação e itens.
15. Altere um item, inclua outro, exclua um e mude a observação. Clique em **Gravar Pedido**: a lista mostra o novo total e, editando de novo, as mudanças estão lá. O número e a data de emissão não mudam.
16. Edite um pedido e clique em **Descartar**: a confirmação pergunta "Descartar as alterações do pedido N?"; respondendo Sim, o pedido continua como estava no banco.

**Cancelar pedido (bônus)**

17. Na lista, selecione um pedido e clique em **Cancelar Pedido**: confirmação com **Não** como padrão. Respondendo Sim, aparece "Pedido N cancelado." e ele sai da lista; no banco, `SELECT * FROM PEDIDO_ITEM WHERE NUMERO_PEDIDO = N` não traz nada.

**Descartar e sair**

18. Em um pedido novo, clique em **Descartar**: confirmação com **Não** como padrão; respondendo Sim, nada é gravado.
19. Na lista, clique em **Sair**: confirmação para fechar a tela.

> O número do pedido vem de uma sequence: é crescente, mas pode pular números quando uma gravação é desfeita (rollback), porque a sequence não volta atrás.

## Decisões técnicas

- **Total sempre calculado no Model** (`TPedido.ValorTotal` soma os itens): a tela só exibe, então incluir, alterar ou excluir item nunca deixa o total errado.
- **Transação no Service:** cabeçalho e itens são gravados juntos; em qualquer erro, `Rollback` e a mensagem aparece sem perder o que foi digitado.
- **Edição do pedido:** `UPDATE` do cabeçalho, apaga e regrava os itens, tudo na mesma transação. É mais simples e seguro que comparar item a item; o custo é os itens ganharem IDs novos. Se o pedido sumiu do banco (`RowsAffected = 0`), a gravação é desfeita.
- **Cancelar pedido** apaga os itens e depois o cabeçalho, na mesma transação. O banco não tem `ON DELETE CASCADE` de propósito: a exclusão fica explícita no código e ninguém apaga itens sem querer ao mexer no pedido direto no banco.
- **Número do pedido** com `NEXT VALUE FOR` + `RETURNING`, sem trigger e sem `SELECT` extra; `PEDIDO_ITEM.ID` com `IDENTITY`.
- **Índices das FKs** nomeados com `USING INDEX`, porque no Firebird a FK já cria o índice.
- **Queries sempre parametrizadas**; o filtro da lista monta o `WHERE` conforme o que foi digitado, mas o valor vai sempre por parâmetro.
- **Dinheiro** em `NUMERIC(15,2)` no banco e `Currency` no Delphi.

## Sobre o uso de IA

O projeto foi desenvolvido por Thiago Fassina em *pair programming* com o Claude Code. Thiago conduziu as decisões, testou cada etapa no Delphi e fez os commits; o Claude Code apoiou com a arquitetura, a revisão do código, as explicações de cada escolha e parte da escrita do código.
