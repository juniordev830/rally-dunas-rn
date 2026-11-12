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
