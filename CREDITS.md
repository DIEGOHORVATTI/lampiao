# Créditos

**Lampião** é um jogo feito por fãs, baseado no quadrinho brasileiro
[**Lampião**](https://tapas.io/series/Lampiao/info), de **Heitor Amatsu** (arte e roteiro) e
**Carlos Eduardo** (roteiro). A renda do jogo existe para ajudar a financiar a continuação da
história e incentivar o quadrinho brasileiro. Leia o original no Tapas.

## Base técnica

- Template [GodotFPS-Template](https://github.com/bukkbeek/GodotFPS-Template) por bukkbeek (MIT):
  modelos 3D e animações dos braços, armas e efeitos.
- Animações dos mortos-vivos: [Mesh2Motion](https://mesh2motion.org/).
- Personagens humanos e animações: [Universal Animation Library 1 e 2](https://quaternius.com) por
  Quaternius (CC0).
- Corpos, rostos e roupas: Universal Base Characters e Modular Character Outfits - Fantasy por
  Quaternius (CC0).
- Armas em primeira pessoa (rifle de ferrolho, revólver, peixeira), mangas do casaco e textura de
  madeira: geradas proceduralmente no próprio projeto (`resources/weapons/forge.gd`), sem assets
  de terceiros. Mãos com dedos, mangas do casaco e punho da camisa também são geradas ali
  (`coat_arms_model.gd`), amarradas ao esqueleto e às animações do template.
- Clarão do tiro (estrela com contorno de nanquim) e fumaça: texturas desenhadas por script no
  próprio projeto.
- Disparo do rifle (`resources/sfx/weapons/rifle_shot.wav`): sintetizado no próprio projeto
  (`rifle_shot.py`), sem amostras de terceiros.
- Efeitos sonoros do template: [Pixabay](https://pixabay.com/).
- Ícones: [game-icons.net](https://game-icons.net) (CC BY 3.0), autores em
  `resources/ui/icons/CREDITS.md`.
- Fontes: [Rye](https://fonts.google.com/specimen/Rye) por Sorkin Type Co (títulos e botões) e
  [Alegreya](https://github.com/huertatipografica/Alegreya) por Huerta Tipográfica (texto), ambas
  sob a SIL Open Font License 1.1 (`resources/fonts/Rye-OFL.txt`, `resources/fonts/Alegreya-OFL.txt`).
- Arte do menu e das telas de carregamento: ilustrações originais feitas para este jogo a partir do
  visual do quadrinho, sem reproduzir quadros dele. Couro, molduras de xilogravura e medalhões da
  interface: gerados no próprio projeto.
- Motor: [Godot Engine](https://godotengine.org/) (MIT).
