# Modelo relacional — SIGEH

Convenção: **PK** chave primária (sublinhada no modelo clássico), *FK* chave estrangeira → tabela(coluna), `UK` valor único, `NN` não nulo.

```
hospitais(id_hospital PK, nome NN, provincia NN, cidade NN, endereco NN, telefone,
          email UK, nivel NN, estado NN)

servicos(id_servico PK, id_hospital FK→hospitais NN, nome NN, descricao, estado NN)

camas(id_cama PK, id_hospital FK→hospitais NN, id_servico FK→servicos NN,
      codigo NN, tipo NN, estado NN, UK(id_hospital, codigo))

medicamentos(id_medicamento PK, nome NN, forma NN, concentracao NN, unidade_medida NN)

stock_medicamentos(id_stock PK, id_hospital FK→hospitais NN, id_medicamento FK→medicamentos NN,
                   quantidade NN, quantidade_reservada NN, validade_lote NN, actualizado_em NN,
                   UK(id_hospital, id_medicamento),
                   CHECK quantidade>=0, CHECK 0<=quantidade_reservada<=quantidade)

bolsas_sangue(id_bolsa PK, id_hospital FK→hospitais NN, grupo_sanguineo NN, factor_rh NN,
              estado NN, data_colheita NN, data_validade NN,
              CHECK data_validade>=data_colheita)

emergencias(id_emergencia PK, codigo UK NN, data_hora NN, prioridade NN, descricao NN,
            estado NN, origem NN)

necessidades(id_necessidade PK, id_emergencia FK→emergencias NN, tipo_recurso NN, descricao NN,
             quantidade NN, prioridade NN, estado NN, CHECK quantidade>0)

pedidos_recepcao(id_pedido PK, id_emergencia FK→emergencias NN, id_hospital FK→hospitais NN,
                 data_pedido NN, estado NN, observacao)

internamentos(id_internamento PK, id_emergencia FK→emergencias NN, id_hospital FK→hospitais NN,
              id_cama FK→camas NN, codigo_paciente NN, data_entrada NN, data_alta (nulo), estado NN,
              CHECK data_alta IS NULL OR data_alta>=data_entrada)

encaminhamentos(id_encaminhamento PK, id_emergencia FK→emergencias NN,
                id_hospital_origem FK→hospitais (nulo), id_hospital_destino FK→hospitais NN,
                data_hora NN, meio_transporte NN, estado NN, observacao)
```

## Domínios (ENUM)

| Tabela.coluna | Valores |
|---|---|
| hospitais.nivel | Central, Provincial, Distrital, Geral |
| hospitais.estado / servicos.estado | ACTIVO, INACTIVO |
| camas.tipo | GERAL, PEDIATRICA, INTENSIVA, MATERNIDADE |
| camas.estado | LIVRE, OCUPADA, RESERVADA, INDISPONIVEL |
| bolsas_sangue.grupo_sanguineo / factor_rh | A, B, AB, O / POSITIVO, NEGATIVO |
| bolsas_sangue.estado | DISPONIVEL, RESERVADA, UTILIZADA, EXPIRADA |
| emergencias.prioridade / necessidades.prioridade | BAIXA, MEDIA, ALTA, CRITICA |
| emergencias.estado | REGISTADA, EM_AVALIACAO, ENCAMINHADA, CONCLUIDA, CANCELADA |
| necessidades.tipo_recurso | CAMA, MEDICAMENTO, SANGUE, SERVICO, EQUIPAMENTO |
| necessidades.estado | PENDENTE, PARCIAL, SATISFEITA, CANCELADA |
| pedidos_recepcao.estado | PENDENTE, ACEITE, RECUSADO, CANCELADO |
| internamentos.estado | ATIVO, ALTA, TRANSFERIDO |
| encaminhamentos.meio_transporte | AMBULANCIA, MEIOS_PROPRIOS, OUTRO |
| encaminhamentos.estado | PROPOSTO, CONFIRMADO, EM_TRANSITO, CONCLUIDO, CANCELADO |

## Relacionamentos, cardinalidade e participação

| Relacionamento | Cardinalidade | Participação |
|---|---|---|
| Hospital **possui** Serviço | 1 : N | Serviço total (obrigatória); Hospital parcial |
| Hospital **tem** Cama | 1 : N | Cama total; Hospital parcial |
| Serviço **agrupa** Cama | 1 : N | Cama total; Serviço parcial |
| Hospital **mantém stock** de Medicamento | N : M → `stock_medicamentos` | parcial em ambos |
| Hospital **guarda** Bolsa de sangue | 1 : N | Bolsa total; Hospital parcial |
| Emergência **exige** Necessidade | 1 : N | Necessidade total (entidade fraca); Emergência parcial |
| Emergência **gera** Pedido de recepção ao Hospital | N : M → `pedidos_recepcao` | parcial em ambos |
| Emergência **origina** Internamento (num Hospital, numa Cama) | 1 : N | Internamento total; Emergência parcial |
| Cama **é ocupada** em Internamento (ao longo do tempo) | 1 : N | Internamento total; Cama parcial |
| Emergência **é encaminhada** de/para Hospitais | N : M → `encaminhamentos` | destino total; origem **opcional** (0..1) |

## Notas de conceção

- **Entidade fraca:** `necessidades` só existe associada a uma emergência (dependência de existência). Na implementação foi-lhe dada uma chave própria `id_necessidade`, mas sem emergência não faz sentido.
- **Entidades associativas** (resolvem relações N:M e guardam atributos próprios): `stock_medicamentos`, `pedidos_recepcao`, `encaminhamentos`.
- **Origem nula:** emergências vindas de comunidades ou localidades não têm hospital de origem.
- **Normalização:** todas as tabelas estão em 3FN. Excepção consciente: `camas.id_hospital` e `servicos.id_hospital` coexistem; convém garantir (na aplicação web ou com trigger) que o serviço de uma cama pertence ao mesmo hospital da cama.
