# pedido-venda-delphi

Pedido de Venda em Delphi com FireDAC e Firebird, organizado em camadas (View, Controller, Service, Repository e Infra).

**Autor:** Thiago Fassina · desenvolvido em *pair programming* com [Claude Code](https://claude.com/claude-code) (Anthropic).

O passo a passo da construção, com o que foi feito e o que falta em cada etapa, está em [`doc/trilha.html`](doc/trilha.html). Para ver formatado, baixe o arquivo e abra no navegador.

## Vídeos

1. **Instalando e executando o sistema** (Firebird, banco, `config.ini`, compilar e uma demonstração seguindo o roteiro): link em breve
2. **Arquitetura e código-fonte** (as camadas e o porquê de cada decisão): link em breve
3. **Testes unitários com DUnitX** (o que cada teste cobre e como rodar): link em breve

## Requisitos

- Windows 10 ou 11 (64 bits)
- Firebird 3.0 ou mais novo (testado no 5.0.4 x64)
- Delphi 13, para compilar

## 1. Instalar o Firebird

Baixe em [firebirdsql.org](https://firebirdsql.org/en/firebird-5-0/) o instalador **`Firebird-5.0.4.1812-0-windows-x64.exe`** (a versão usada no projeto) e instale com as opções padrão. Anote a senha do SYSDBA.

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

O programa lê o `config.ini` da mesma pasta do executável (`bin\config.ini`). Esse arquivo não vai para o repositório, porque guarda a senha do banco. Crie o seu a partir do [`config.ini.example`](config.ini.example), na raiz do projeto:

```bat
copy config.ini.example bin\config.ini
```

Depois abra o `bin\config.ini` e troque `SUA_SENHA` pela senha do SYSDBA. Se o banco foi criado em outro caminho, ajuste também o `Database`.

| Chave | O que é |
|---|---|
| `Server` | Servidor do Firebird (ex.: `localhost`) |
| `Port` | Porta do Firebird (padrão `3050`) |
| `Database` | Caminho do `.fdb` no servidor |
| `Username` / `Password` | Usuário e senha do banco |
| `ClientLibrary` | Caminho do `fbclient.dll`, relativo à pasta do INI ou absoluto |

O `bin` já traz o `fbclient.dll` x64 e o runtime do Visual C++ que ele usa, então não é preciso copiar nada para o Windows.

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
10. Carregue uma linha com **ENTER** e aperte **Esc**: os campos do item são limpos, o botão volta para **Inserir Item** e a linha do grid não muda.

**Gravar (2.6 e 4.1)**

11. Clique em **Gravar Pedido** sem cliente: aviso e foco no Cliente. Com cliente e sem itens: aviso e foco no Produto.
12. Com cliente e itens, clique em **Gravar Pedido**: aparece "Pedido N gravado com sucesso." e a lista mostra o pedido com o nome do cliente e o total.
13. Grave um pedido com **Observação** e outro com ela em branco: a lista mostra o texto no primeiro e a coluna vazia no segundo (no banco, `SELECT NUMERO_PEDIDO, OBSERVACAO FROM PEDIDO` mostra `NULL`).
14. Na lista, filtre pelo número do pedido ou por parte do nome do cliente e aperte Enter.

**Editar pedido (bônus)**

15. Na lista, selecione um pedido, clique em **Editar** e confirme: o pedido abre com número, data, cliente, observação e itens.
16. Altere um item, inclua outro, exclua um e mude a observação. Clique em **Gravar Pedido**: a lista mostra o novo total e, editando de novo, as mudanças estão lá. O número e a data de emissão não mudam.
17. Edite um pedido e clique em **Descartar**: a confirmação pergunta "Descartar as alterações do pedido N?"; respondendo Sim, o pedido continua como estava no banco.

**Cancelar pedido (bônus)**

18. Na lista, selecione um pedido e clique em **Cancelar Pedido**: confirmação com **Não** como padrão. Respondendo Sim, aparece "Pedido N cancelado." e ele sai da lista; no banco, `SELECT * FROM PEDIDO_ITEM WHERE NUMERO_PEDIDO = N` não traz nada.

**Descartar e sair**

19. Em um pedido novo, clique em **Descartar**: confirmação com **Não** como padrão; respondendo Sim, nada é gravado.
20. Na lista, clique em **Sair**: confirmação para fechar a tela.
21. Com um pedido aberto (novo ou em edição), feche o sistema pelo menu **Sair** ou pelo X da janela: aviso de alterações não gravadas, com **Não** como padrão. Respondendo Não, a aba do pedido fica à frente e nada se perde.

> O número do pedido vem de uma sequence: é crescente, mas pode pular números quando uma gravação é desfeita (rollback), porque a sequence não volta atrás.

## 7. Testes unitários (DUnitX)

Os testes ficam num projeto separado, [`tests/PedidoVendaTestes.dproj`](tests/PedidoVendaTestes.dproj), que usa só as units do Model: não precisam de banco nem de tela. O `PedidoVendaGrupo.groupproj`, na raiz, abre os dois projetos juntos.

1. Abra o `PedidoVendaGrupo.groupproj` (ou só o `tests\PedidoVendaTestes.dproj`) no Delphi 13, com a plataforma **Windows 64-bit**.
2. Ative o **PedidoVendaTestes** e compile (Ctrl+F9). O executável é gerado em `tests\bin\PedidoVendaTestes.exe`, fora do `bin` do sistema.
3. Na pasta do repositório, rode no PowerShell:

   ```powershell
   .\tests\bin\PedidoVendaTestes.exe
   ```

   O resultado aparece no console e também em `tests\bin\dunitx-results.xml` (formato NUnit, o que servidores de CI leem). Pela IDE (F9) a janela fecha ao terminar; para ela esperar o Enter, use **Run > Parameters** com `--exitbehavior:Pause`.

| Teste | O que garante |
|---|---|
| `PedidoVazioDeveTerTotalZero` | Pedido sem itens tem total 0 |
| `ItemDeveMultiplicarQuantidadePeloValorUnitario` | Total do item = quantidade × valor unitário |
| `PedidoDeveSomarOTotalDosItens` | Total do pedido = soma dos itens |
| `PedidoDeveRecalcularAoAtualizarItem` | Mudar quantidade e valor de um item muda o total |
| `PedidoDeveRecalcularAoExcluirItem` | Excluir um item tira o valor dele do total (4.2) |

## Decisões técnicas

- **Total sempre calculado no Model** (`TPedido.ValorTotal` soma os itens): a tela só exibe, então incluir, alterar ou excluir item nunca deixa o total errado.
- **Transação no Service:** cabeçalho e itens são gravados juntos; em qualquer erro, `Rollback` e a mensagem aparece sem perder o que foi digitado.
- **Edição do pedido:** `UPDATE` do cabeçalho, apaga e regrava os itens, tudo na mesma transação. É mais simples e seguro que comparar item a item; o custo é os itens ganharem IDs novos. Se o pedido sumiu do banco (`RowsAffected = 0`), a gravação é desfeita.
- **Cancelar pedido** apaga os itens e depois o cabeçalho, na mesma transação. O banco não tem `ON DELETE CASCADE` de propósito: a exclusão fica explícita no código e ninguém apaga itens sem querer ao mexer no pedido direto no banco.
- **Número do pedido** com `NEXT VALUE FOR` + `RETURNING`, sem trigger e sem `SELECT` extra; `PEDIDO_ITEM.ID` com `IDENTITY`.
- **Índices das FKs** nomeados com `USING INDEX`, porque no Firebird a FK já cria o índice.
- **Queries sempre parametrizadas**; o filtro da lista monta o `WHERE` conforme o que foi digitado, mas o valor vai sempre por parâmetro.
- **Dinheiro** em `NUMERIC(15,2)` no banco e `Currency` no Delphi.
- **Testes no Model:** como a regra do total está no `TPedido`, e não na tela, ela é testada sem banco e sem formulário. Cada teste recebe um pedido novo no `[Setup]`, liberado no `[TearDown]`; os itens são liberados junto, porque a lista é um `TObjectList` dono dos objetos.

## Sobre o uso de IA

O projeto foi desenvolvido por Thiago Fassina em *pair programming* com o Claude Code. Thiago conduziu as decisões, testou cada etapa no Delphi e fez os commits; o Claude Code apoiou com a arquitetura, a revisão do código, as explicações de cada escolha e parte da escrita do código.
