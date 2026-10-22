# SIGEH — Sistema Integrado de Gestão de Emergência Hospitalar

Projecto de Base de Dados · Tecnologias de Base de Dados · Licenciatura em Informática, 2.º ano · Universidade Licungo

| | |
|---|---|
| **Estudante** | Joel Ali Viano Pinto |
| **Tema** | Sistema Integrado de Gestão de Emergência Hospitalar |
| **SGBD** | MySQL |

## 1. Descrição do problema

Em situações de emergência (acidentes, surtos, calamidades), o maior problema não é só atender o doente, mas saber **onde** o pode receber. Muitas vezes a unidade que recebe o primeiro caso não tem camas livres, sangue compatível, medicamentos ou o serviço necessário, e a decisão de transferir o doente é tomada por chamadas telefónicas, sem informação actualizada. Esse atraso pode custar vidas.

O SIGEH pretende informatizar esta coordenação entre hospitais. Cada **hospital** da rede (com a sua província, cidade e nível: central, provincial, distrital ou geral) regista os seus **serviços** (urgência, cirurgia, pediatria, cuidados intensivos, banco de sangue, etc.), as suas **camas** e o seu estado (livre, ocupada, reservada, indisponível), o **stock de medicamentos** com quantidade, quantidade reservada e validade do lote, e as **bolsas de sangue** por grupo e factor Rh, com datas de colheita e validade.

Quando surge uma **emergência**, é registada com um código único, data e hora, prioridade (baixa a crítica), descrição e origem. A emergência indica as suas **necessidades** (cama, medicamento, sangue, serviço ou equipamento) e quantidades. A partir daí, o sistema permite enviar **pedidos de recepção** aos hospitais que possam ajudar; cada hospital aceita ou recusa o pedido. Quando um hospital aceita, o doente é identificado por um código (sem dados pessoais sensíveis) e é feito o **internamento** numa cama concreta, até à alta ou transferência. Se o doente tiver de ser levado para outro hospital, regista-se o **encaminhamento**, com hospital de origem (que pode não existir, se o caso vem de uma comunidade), hospital de destino e meio de transporte.

## 2. Regras de negócio

1. Cada hospital tem um identificador único e um email único; o nível é Central, Provincial, Distrital ou Geral, e o estado é ACTIVO ou INACTIVO.
2. Um serviço pertence a um único hospital; um hospital pode ter vários serviços.
3. Uma cama pertence a um hospital e a um serviço; o código da cama é único dentro do hospital.
4. O tipo de cama é GERAL, PEDIATRICA, INTENSIVA ou MATERNIDADE; o seu estado é LIVRE, OCUPADA, RESERVADA ou INDISPONIVEL.
5. Um medicamento é definido por nome, forma, concentração e unidade de medida.
6. Cada medicamento tem no máximo um registo de stock por hospital.
7. A quantidade em stock não pode ser negativa, e a quantidade reservada não pode ser negativa nem superior à quantidade existente.
8. Cada bolsa de sangue pertence a um hospital, tem grupo (A, B, AB, O) e factor Rh (positivo ou negativo), e a data de validade não pode ser anterior à data de colheita.
9. O estado de uma bolsa é DISPONIVEL, RESERVADA, UTILIZADA ou EXPIRADA.
10. Cada emergência tem um código único, data e hora, prioridade (BAIXA, MEDIA, ALTA, CRITICA), origem e estado (REGISTADA, EM_AVALIACAO, ENCAMINHADA, CONCLUIDA, CANCELADA).
11. Uma emergência pode ter várias necessidades; uma necessidade não existe sem emergência (entidade fraca).
12. A quantidade de uma necessidade tem de ser maior que zero.
13. Uma emergência pode gerar vários pedidos de recepção, dirigidos a hospitais diferentes; o pedido está PENDENTE, ACEITE, RECUSADO ou CANCELADO.
14. Um internamento liga uma emergência, um hospital, uma cama e um paciente identificado por código; a data de alta, quando existe, não pode ser anterior à data de entrada.
15. Um internamento está ATIVO, em ALTA ou TRANSFERIDO; um internamento activo mantém a cama OCUPADA.
16. Um encaminhamento tem sempre hospital de destino; o hospital de origem é opcional (casos vindos da comunidade).
17. O meio de transporte é AMBULANCIA, MEIOS_PROPRIOS ou OUTRO.
18. Não se pode eliminar um registo que seja referenciado por outro (integridade referencial): por exemplo, um hospital com serviços, camas ou internamentos.
19. Por razões de privacidade, o sistema guarda apenas códigos de paciente, nunca nome ou documentos de identificação.

## 3. Sistema web previsto (Programação Web)

Num futuro sistema web, os utilizadores (gestores de emergência, pessoal dos hospitais e administradores) poderão registar emergências, consultar camas, sangue e medicamentos disponíveis, pesquisar hospitais por província ou serviço, enviar e responder a pedidos de recepção, e alterar ou eliminar registos, sempre com informação actualizada.

**Perfis de utilizador previstos:**

| Perfil | O que faz |
|---|---|
| Gestor de emergência | Regista emergências e necessidades, envia pedidos de recepção e acompanha encaminhamentos |
| Pessoal do hospital | Actualiza camas, stock de medicamentos e bolsas de sangue; aceita ou recusa pedidos; regista internamentos e altas |
| Administrador | Gere hospitais, serviços e utilizadores |

## 4. Diagrama ER

![Diagrama ER do SIGEH](diagrama_er.png)

O modelo relacional (tabelas, chaves primárias e estrangeiras, domínios e cardinalidades) está em [`modelo_relacional.md`](modelo_relacional.md).

## 5. Base de dados

- **11 tabelas**, com 20 registos em cada uma: `hospitais`, `servicos`, `camas`, `medicamentos`, `stock_medicamentos`, `bolsas_sangue`, `emergencias`, `necessidades`, `pedidos_recepcao`, `internamentos`, `encaminhamentos`.
- Restrições usadas: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `ENUM` e `CHECK`.
- **Entidade fraca:** `necessidades` (só existe associada a uma emergência).
- **Entidades associativas:** `stock_medicamentos`, `pedidos_recepcao`, `encaminhamentos`.

## 6. Como executar

1. Abra o MySQL (Workbench, phpMyAdmin, DBeaver ou linha de comandos).
2. Execute `01_criacao_e_insercao.sql`. Atenção: o script faz `DROP DATABASE IF EXISTS sigeh` e recria tudo de raiz.
3. Execute `02_manipulacao.sql` **comando a comando**, para ver o resultado de cada um.

```bash
mysql -u root -p < 01_criacao_e_insercao.sql
mysql -u root -p < 02_manipulacao.sql
```

> O último comando do ficheiro 02 é o teste de integridade e termina propositadamente com erro (código 1452). Ao executar o ficheiro inteiro por linha de comandos, o MySQL pára nesse ponto.

## 7. Estrutura do repositório

```
bd-sigeh-joel-pinto/
├── README.md
├── diagrama_er.png
├── modelo_relacional.md
├── 01_criacao_e_insercao.sql
└── 02_manipulacao.sql
```

## 8. Comandos de manipulação (ficheiro 02)

| Tipo | Quantidade | Descrição |
|---|---|---|
| SELECT simples | 3 | Hospitais activos em Sofala; camas livres; emergências de prioridade alta ou crítica |
| SELECT com JOIN | 2 | Camas com hospital e serviço; stock de medicamentos por hospital |
| UPDATE | 2 | Reservar uma cama; alterar a observação de um pedido |
| DELETE | 1 | Eliminar uma necessidade (tabela filha, respeita as chaves estrangeiras) |
| Teste de integridade | 1 | `INSERT` com `id_hospital` inexistente → erro 1452 |
