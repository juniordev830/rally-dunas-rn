# Engenharia reversa e estudo — Rally Dunas RN

## Objetivo e fluxo

Rally em dunas fictícias com checkpoints e tempo de prova. rally.gd constrói o relevo, a rota e os checkpoints. car.gd controla o veículo e driving_rules.gd calcula velocidade, splits e medalhas.

**Tecnologias identificadas** · GDScript, Python, Godot.

**Revisão de referência** · `860d7570d51e`.

## Mapa do código

| Caminho | Papel de leitura | Símbolos selecionados |
| --- | --- | --- |
| [core.py](../core.py) | Implementação | `number`, `Vehicle`, `Vehicle.drive`, `Rally`, `Rally.reset`, `Rally.start`, `Rally.pause`, `Rally.tick`, `Rally.checkpoint` |
| [scripts/car.gd](../scripts/car.gd) | Implementação | `_ready`, `_part`, `_physics_process` |
| [scripts/driving_rules.gd](../scripts/driving_rules.gd) | Implementação | `next_speed`, `reached_checkpoint`, `speed_kmh`, `medal_for_time`, `split_seconds`, `valid_record_time`, `beats_record`, `checkpoint_direction` |
| [scripts/rally.gd](../scripts/rally.gd) | Implementação | `_ready`, `_height`, `_create_environment`, `_create_terrain`, `_add_prop`, `_create_landmarks`, `_create_checkpoints`, `_process`, `_refresh_hud` |
| [scenes/main.tscn](../scenes/main.tscn) | Cena Godot versionada | — |

## Configuração e referências

Ambiente e dependências: [project.godot](../project.godot).

## Roteiro de estudo e desenvolvimento

1. Comece pelo fluxo descrito acima e localize seus pontos de entrada no mapa. Acompanhe uma entrada válida até a transformação ou a resposta.
2. Abra um teste relacionado ao fluxo e descreva qual regra ele protege. Compare o tratamento esperado para entradas válidas, inválidas e nos limites.
3. Ao adicionar uma regra, determine qual módulo controla o dado e cubra o caso nesse nível. Em seguida, confira o efeito no comando, na API ou na interface de entrada.

**Pergunta de entrevista**

Como testaria que um checkpoint visitado fora da ordem não antecipa a chegada?

## Testes versionados

Arquivos para começar a leitura dos cenários de teste: [tests/test_core.py](../tests/test_core.py), [tests/test_driving_rules.gd](../tests/test_driving_rules.gd).

Os comandos e versões de runtime usados no CI ficam em [.github/workflows/ci.yml](../.github/workflows/ci.yml), [.github/workflows/godot-rally.yml](../.github/workflows/godot-rally.yml).

[Voltar ao README](../README.md).
