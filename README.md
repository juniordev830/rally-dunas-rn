# Rally Dunas RN

## Jogo em Godot

**Estado:** primeiro MVP experimental de rally 3D em **Godot 4**, inspirado visualmente nas paisagens de dunas do Rio Grande do Norte (não é reprodução cartográfica real).

### Mecânicas
- Veículo estilizado com aceleração, marcha a ré, atrito e direção arcade.
- Terreno de dunas gerado por funções matemáticas, iluminação de deserto e rochas decorativas.
- Cinco checkpoints sequenciais; o desafio é passar por eles na ordem.
- Câmera perseguidora, velocidade estimada em km/h e cronômetro.

### Controles
- **W / seta para cima:** acelerar.
- **S / seta para baixo:** frear e dar ré.
- **A/D / setas esquerda-direita:** virar.
- **R:** reiniciar a corrida.

### Como executar
1. Instale Godot 4.2+ (versão GDScript).
2. Abra `project.godot` e pressione F5.

### Verificações
```bash
godot --headless --path . --script tests/test_driving_rules.gd
```

A CI também inicia a cena em Godot headless por alguns frames.

### Limitações
Não há física de pneus realista, colisão de rochas, múltiplos carros, áudio, savegame, pista de competição oficial ou mapas geográficos reais. Os visuais são gerados por código e ainda precisam de validação na janela do editor. O projeto é uma demonstração de programação gráfica e simulação.


### Medalhas e tempo por trecho (novo)

A corrida agora informa o tempo gasto desde o checkpoint anterior. Ao completar os cinco checkpoints em ordem, o jogador recebe uma medalha conforme o tempo total: **ouro até 55 segundos**, **prata até 90 segundos** e **bronze acima disso**. Os limites são metas de um jogo, não classificações oficiais de rally.

A classificação e o cálculo de tempo por trecho estão isolados em `scripts/driving_rules.gd`, com testes de valores de fronteira e entradas inválidas. Os tempos reiniciam ao pressionar **R**, sem salvamento permanente de recordes.

### Recorde pessoal salvo entre partidas

Ao concluir os cinco checkpoints, o jogo compara seu tempo com o recorde salvo anteriormente. Se for sua primeira conclusão ou um tempo melhor, o novo recorde é gravado em `user://rally_best_time.txt`, no diretório de dados do Godot para este projeto. O HUD mostra `RECORDE PESSOAL` mesmo depois de reiniciar o jogo.

O tempo só é registrado ao concluir a corrida. Empates, tempos inválidos e tentativas mais lentas não substituem o recorde. Os critérios são testados em `tests/test_driving_rules.gd`.

#### Navegação até os portais

O HUD agora apresenta a **distância ao próximo checkpoint** e indica se ele fica à frente, atrás, à esquerda ou à direita **em relação ao sentido atual do carro**. Assim, o jogador não precisa depender apenas dos pilares coloridos para se orientar.

Ao superar um tempo previamente salvo, a chegada exibe **NOVO RECORDE PESSOAL!**. Uma partida mais lenta mantém o recorde anterior. A orientação entre carro e checkpoint é testada sem exigir renderização 3D.

## Núcleo Python e planejamento

### Primeira pista de teste

Construir um circuito curto com terreno estilizado, veículo demonstrativo, linha de largada e chegada. O primeiro objetivo é completar uma volta com cronômetro estável, sem simular condução real ou percursos protegidos.

### Regras previstas

- Veículo responde a acelerar, frear e esterçar com limites definidos.
- Cronômetro começa na largada e termina na chegada, sem contar voltas não concluídas.
- Sair da pista aplica penalidade configurável ou reinicia checkpoint.
- Checkpoints devem ser percorridos na ordem antes de validar a volta.
- Reiniciar deve restaurar carro, câmera e tempo inicial.

### Critérios de aceitação

1. Jogador completa circuito de teste com controles de teclado.
2. Pular checkpoint não valida chegada.
3. Travar o carro em obstáculo permite recuperação.
4. Cronômetro não avança quando a partida está pausada.
5. O desempenho é medido em hardware definido e sem assets não licenciados.

### Etapas de produção

- [ ] Escolher engine, versão e modelo de controle.
- [ ] Criar domínio de checkpoint e cronometragem com testes.
- [ ] Construir pequeno terreno fictício e veículo provisório.
- [ ] Implementar HUD e reinício de corrida.
- [ ] Capturar gameplay real e escrever instruções de build para PC.

Usar referências visuais autorizadas e evitar representar áreas sensíveis como pistas liberadas para veículos.

### Testes do núcleo Python

Veículo cinemático 2D, passagem obrigatória por checkpoints, cronometragem, pausa e reinício.

O arquivo `core.py` contém a implementação executável em Python 3.11+ e `tests/test_core.py` cobre regras, entradas inválidas e repetibilidade. O núcleo Python roda de forma independente da versão visual.

Para executar a demonstração:

```bash
python core.py
```

Para verificar o comportamento:

```bash
python -m unittest discover -s tests -p 'test_*.py' -v
```

O GitHub Actions executa a suíte em cada PR. A lista de tarefas do roteiro acima descreve o objetivo completo do jogo e não deve ser interpretada como pronto para publicação.
