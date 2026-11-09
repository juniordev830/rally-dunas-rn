# Protótipo de física do Rally Dunas RN

Este módulo Python simula aceleração, resistência, direção e deslocamento em diferentes superfícies, sem dependências externas.

## Executar
```bash
python simulation.py
python -m unittest discover -s tests -v
```

## Integração futura
Conectar os valores de `Car` ao controlador do veículo no motor 3D. A física é simplificada e não substitui colisões, suspensão ou dinâmica realista de pneus. Use passos fixos de até 0,1 segundo para simulação estável.
