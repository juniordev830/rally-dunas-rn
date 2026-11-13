# Rally Dunas RN

Jogo de rally 3D **em planejamento**, com ambientação fictícia inspirada nas dunas e paisagens do Rio Grande do Norte.

> **Estado atual:** apenas README e licença; não há veículo controlável, pistas, cenas, física ou build jogável.

## Primeira pista de teste

Construir um circuito curto com terreno estilizado, veículo demonstrativo, linha de largada e chegada. O primeiro objetivo é completar uma volta com cronômetro estável, sem simular condução real ou percursos protegidos.

## Regras previstas

- Veículo responde a acelerar, frear e esterçar com limites definidos.
- Cronômetro começa na largada e termina na chegada, sem contar voltas não concluídas.
- Sair da pista aplica penalidade configurável ou reinicia checkpoint.
- Checkpoints devem ser percorridos na ordem antes de validar a volta.
- Reiniciar deve restaurar carro, câmera e tempo inicial.

## Critérios de aceitação

1. Jogador completa circuito de teste com controles de teclado.
2. Pular checkpoint não valida chegada.
3. Travar o carro em obstáculo permite recuperação.
4. Cronômetro não avança quando a partida está pausada.
5. O desempenho é medido em hardware definido e sem assets não licenciados.

## Etapas de produção

- [ ] Escolher engine, versão e modelo de controle.
- [ ] Criar domínio de checkpoint e cronometragem com testes.
- [ ] Construir pequeno terreno fictício e veículo provisório.
- [ ] Implementar HUD e reinício de corrida.
- [ ] Capturar gameplay real e escrever instruções de build para PC.

Usar referências visuais autorizadas e evitar representar áreas sensíveis como pistas liberadas para veículos.

## Primeiro incremento de código (em revisão)

Veículo cinemático 2D, passagem obrigatória por checkpoints, cronometragem, pausa e reinício.

O arquivo `core.py` contém a implementação executável em Python 3.11+ e `tests/test_core.py` cobre regras, entradas inválidas e repetibilidade. Não há engine 3D, UI gráfica, asset ou build final nesta entrega; o protótipo é de **domínio/testes**.

Para executar a demonstração:

```bash
python core.py
```

Para verificar o comportamento:

```bash
python -m unittest discover -s tests -p 'test_*.py' -v
```

O GitHub Actions executa a suíte em cada PR. A lista de tarefas do roteiro acima descreve o objetivo completo do jogo e não deve ser interpretada como pronto para publicação.
