# Lampião 1 — Bíblia do roteiro

Documento-mãe da história. O jogo segue **à risca** o webcomic **"Lampião"** (Tapas), episódios 1
a 11 (resumo e páginas em `docs/referencias/guia-visual.md`). "Lampião 1" termina onde o
quadrinho parou, no meio da luta com o lobisomem, com a luta tornada jogável e um gancho para o
"Lampião 2". Quando um capítulo, um mapa ou uma ficha contradisser este arquivo, vale este
arquivo; quando este arquivo contradisser o quadrinho, vale o quadrinho. Os demais:

- `01-personagens.md` — quem é quem.
- `02-estrutura.md` — capítulos ↔ episódios, escolhas, medidores, o fim.
- `03-capitulos/` — roteiro cena a cena, com sustos marcados.
- `04-mapas.md` — ponte para o level design (coordenadas, zonas, spawners, peças).
- `05-bestiario.md` — criaturas: IA, fraqueza, som, o que Ela ganha ao comer.
- `MUDANCAS-CAP1.md` — o que muda no cap. 1 já implementado.

## Regras do autor (valem acima de tudo)

1. O protagonista é só **"Lampião"** ou **"Capitão"**. Nenhum texto do jogo usa nome de batismo.
2. O apelido vem do **rifle**: ele atirava tão rápido que o clarão iluminava a noite. **Não existe
   lampião de querosene no jogo.** A luz vem do clarão dos tiros, das fogueiras, da lua e de
   tochas. Atirar ilumina e entrega a posição. (Onde o quadrinho usa o lampião de querosene, no
   E10, o jogo usa um **tição** de fogueira.)
3. **Gore** no tom do quadrinho: sangue preto chapado, silhueta, mutilação, inclusive nas telas de
   carregamento.
4. Nenhum emoji em texto de interface.
5. Fala sertaneja nordestina crível, em português do Brasil.
6. **Seguir a obra:** mesma cronologia, cenas, personagens, falas-chave e viradas dos E1–E11.
   Nada inventado depois do E11. Jogabilidade entra dentro dos episódios sem mudar o que acontece.
7. **Horror em primeiro lugar:** todo capítulo tem vários sustos marcados, com os tipos que o jogo
   já tem: jumpscare, vulto, passos, batida, sussurro, respiracao, apagao (e chao, o corpo-seco
   saindo da terra).

### Sustos: tipo ↔ ferramenta (`common/autoloads/sustos.gd`)

| Tipo na tabela | Chamada | Observação |
|---|---|---|
| jumpscare | `Sustos.jumpscare(face, segundos)` | rostos prontos: `corpo_seco`, `entidade`. Rostos a produzir (do quadrinho, preto e retícula): `maria_veneno` (E1 10), `carroceiro`, `marconi_faca` (E3 15), `ciro_febre` (E5 14), `ciro_transformando` (E8 11), `velho_porta` (cap. 5), `caveira_boi`, `olho_ela` (E9 12) |
| vulto | `Sustos.vulto(distancia, segundos)` | figura de olhos brancos na visão periférica |
| passos | `Sustos.som_atras("passos")` | |
| batida | `Sustos.som_atras("batida")` | |
| sussurro | `Sustos.som_atras("sussurro")` | com legenda entre colchetes quando a fala importa |
| respiracao | `Sustos.som_atras("respiracao")` | |
| apagao | `Sustos.apagar_luzes(raio, segundos)` | o clarão do tiro não apaga |
| chao | spawn de corpo-seco saindo da terra ou do nicho | usa o `spawner` com animação de levantar |

---

## Logline

Traído pelo cozinheiro do bando e degolado pelo Coronel numa caverna de ídolos, Lampião volta a
andar porque uma coisa antiga, faminta, que veio do mar, acordou dentro do pescoço dele. Com o
terço da mulher morta segurando a fera e uma moça grávida de dois revólveres ao lado, ele
atravessa um sertão de lua cheia dando a ela toda carne podre que acha no caminho, até uma vila
de portas fechadas onde um pai de família vira bicho.

## Sinopse (E1–E11)

Nordeste do Brasil, 19XX. O bando de Lampião, "justiceiros errantes, bandidos por necessidade",
assalta a fazenda do Coronel. Maria, a mulher de Lampião, leva um tiro na fuga e mostra o terço:
"Eu sou abençoada, lembra?". Vini, o cozinheiro, leva o bando para uma caverna com pilares e
ídolos e serve uma sopa envenenada: o Coronel pegou a família dele. De madrugada o bando agoniza,
o Coronel chega, e Vini leva Lampião ao fundo da caverna. Lá, Lampião briga com Vini na faca e é
degolado pelo Coronel, que mata Vini em seguida.

Uma voz de mulher diz que esteve "sepultada por séculos" e que o sacrifício foi feito. Do pescoço
do corpo sem cabeça sai **Ela**: um olho enorme, uma boca de dentes, tentáculos cheios de olhos.
Ela come os soldados; o Coronel foge. O terço de Maria brilha, Ela grita, e Lampião acorda com a
cabeça costurada. Maria morre nos braços dele. De manhã ele enterra o bando e jura matar o
Coronel. Ela, no pescoço: "Eu só preciso arranjar mais comida e te deixo descansar em paz."

Na estrada, um casal de velhos pede ajuda: dois homens levaram a filha, **Juliana**. Lampião é
emboscado pelos irmãos **Antônio e Marconi**, que o reconhecem e querem vendê-lo vivo ao Coronel em
Mossoró. Arrastado, ele crava uma faca na cara de Marconi. Juliana, forçada a atirar nele, revela:
"Eu tô grávida!". Ela come os dois irmãos. Lampião devolve Juliana aos pais; ela vai atrás dele.
Numa pedra, um vulto de olhos brancos: "Então é verdade... ela despertou."

Na lua cheia, os dois procuram o esconderijo dos cangaceiros debaixo de uma pedra de topo reto e
acham **Ciro**, um pai de família pobre, acorrentado e ardendo de febre: "Filha...". Levam-no para
a vila, onde ninguém abre a porta e o povo chama ele de monstro. A **Tia Vó Regina** tenta matá-lo
antes da lua; Juliana impede. Na noite seguinte, diante da filha **Helena** e do vulto na janela,
Ciro vira **lobisomem**. Ela morde o bicho e reconhece o gosto: "Eu não acreditava... mas é ele...
ele ainda está aqui." O sangue do lobisomem a deixa doente; Lampião vomita Ela inteira para salvar
Juliana; Juliana, encharcada de sangue, atira com os revólveres dos irmãos; Regina chega com
**balas de prata**: "Isso acaba aqui e agora, Ciro!"

O jogo torna jogável o fim dessa luta e para aí: o lobisomem cai com a prata, o vulto some com
ele, e a pergunta fica para o "Lampião 2".

## Tom

- **Horror de ação sertanejo** com o traço de mangá do quadrinho: silêncio, susto, explosão.
  Preto chapado, sangue preto, silhueta contra a lua.
- **Justiceiro, não santo.** Lampião é bom de coração e ruim de gênio. Mata, xinga e erra.
- **Dupla de casal velho.** Ela e Lampião brigam o tempo todo, como no quadrinho ("Aquieta o
  facho", "É sério, imbecil!"). O humor vem dessa briga, nunca de caricatura do sotaque.
- **Fé que funciona.** O terço de Maria trava Ela de verdade. Prata fere o lobisomem.
- **O povo de porta fechada.** "Vai embora!", "Fora!", "Sai daqui, peste!"

## Temas

1. **Traição e família.** Vini traiu pela família; o Coronel matou a família dele mesmo assim.
   Juliana fugiu da família para não ver os pais morrerem de fome. Ciro se acorrenta para não
   machucar a dele.
2. **Quem é o monstro?** Ela come gente, mas quem degolou foi o Coronel. O lobisomem mata, mas diz
   "Filha...". O povo fecha a porta por medo.
3. **Cabeça e corpo.** A cabeça é de Lampião; o corpo se mexe porque Ela segura. A costura é a
   fronteira, e o terço fica em cima dela.

## Época e lugar

- **Quando:** "Nordeste do Brasil, 19XX", como no quadrinho. Cangaço, volante, coronéis, revólver,
  rifle de ferrolho, cavalo.
- **Onde:** sertão a caminho de Mossoró (onde o Coronel está; o jogo não chega lá).
- **Lua:** cheia em quase toda noite, como no quadrinho. O povo estranha. O jogo não explica.

| Lugar | O que é | Capítulos |
|---|---|---|
| Fazenda do Coronel | casa-grande com capela e cerca de arame farpado | 1 |
| Caverna dos Ídolos | esconderijo do bando; ruína de pilares e ídolos; túmulo dela | 1 |
| Estrada do Riacho Fundo | carroça virada, sítio dos pais de Juliana, choupana | 2 |
| Cacimba da Cruz | onde os irmãos param; cemitério de beira de estrada | 3 |
| Pedra de Topo Reto | esconderijo secreto dos cangaceiros | 4 |
| Vila Boa Vista | vila de Ciro, Helena e Regina | 4 (prólogo), 5, 6, 7 |

Os nomes de lugar são do jogo; o quadrinho não nomeia.

---

## Ela

### O que se sabe (só o que o quadrinho diz)

- Não tem nome. Na interface, "ELA". Lampião a chama de "tu", "demônio", "peste".
- É **feminina** e **antiga**: esteve "sepultada por séculos" na caverna; acordou com "o
  sacrifício" "dentro do receptáculo oferecido" (o corpo de Lampião).
- Vivia **perto do mar**, comia peixe e ostra e "era muito bem alimentada por servos bem mais
  educados" que Lampião.
- "Ainda não estou completa." Precisa comer. Promete deixá-lo "descansar em paz" quando tiver
  comido o bastante.
- O terço de Maria a fez gritar e recolher-se. Ela odeia o terço no pescoço dele.
- O sangue do lobisomem tem gosto ruim para ela, e ela reconhece alguém nele: "é ele... ele ainda
  está aqui". O jogo **não** explica quem.

### Formas (do quadrinho)

1. **Olho no pescoço:** em repouso, um olho preto de pupila em fenda abre na costura, por baixo do
   lenço. Em primeira pessoa, o jogador o vê de relance quando olha para baixo.
2. **Forma liberta** (cap. 1): saindo do coto, olho gigante e venoso, boca de dentes compridos,
   tentáculos pretos cheios de olhinhos brancos.
3. **Tentáculos:** a explosão que empala e ergue (E4).
4. **Boca elástica:** pescoço preto comprido que estica e morde (E9).
5. **Vômito ("TUDO"):** massa preta com tripas brancas (E10).

### Poderes de jogo

| Poder | Em jogo | Custo / regra | Desde |
|---|---|---|---|
| Segurar o corpo | Lampião é frágil por fora (apanha, voa longe), mas levanta | — | cap. 1 |
| **Tentáculos** | empalam e erguem; alcance 5 m | +10 de fome, recarga 1,5 s | cap. 1 (no código: `raizes`) |
| **Comer** | a costura abre e come criatura caída ou cadáver de corpo-seco | fome −30, vida +15 | cap. 1 |
| **Boca elástica** | mordida de 10 m | só no chefe lobisomem | cap. 6 |
| **Vômito** | área de 6 m; mata corpo-seco, prende chefe 5 s | fome vai a 90, vida −30, recarga 120 s | cap. 7 |

### O que Ela não pode

- **Nada com o terço na mão de Lampião:** cala, desliga os poderes, a fome desce.
- **Comer lobisomem:** dá enjoo e desliga os Tentáculos (caps. 6–7).

### Fome (medidor)

| Faixa | Estado | Efeito |
|---|---|---|
| 0–49 | Quieta | normal |
| 50–74 | Inquieta | barriga roncando, sussurros, borda da tela escurece |
| 75–94 | Faminta | visão cinza, mira treme, Tentáculos atacam sozinhos a 3 m (inclusive gente) |
| 95–100 | Tomado | fim de jogo: "Ela cansou de esperar. Agora a comida é você." |

- Sobe com o tempo (no código: 0,8/s; ajustar no teste) e com Tentáculos.
- **Segurar o terço:** desce ~1/s, sem poderes, corpo-seco recua a 4 m.
- **Comer corpo-seco** é o pão de cada dia.

### Vida

Inteireza do corpo. Sobe comendo, devagar perto de fogueira, e com garrafada deixada na janela.

### Marca e Graça (medidores escondidos)

- **Marca** (0–3): gente que Lampião deixou Ela comer nas escolhas (comida roteirizada do
  quadrinho não conta). Cada ponto: Ela fala com mais intimidade, Tentáculos mais grossos, a
  costura sobe um ponto.
- **Graça** (0–3): ajuda ao povo com custo. Cada ponto: mais oferenda na janela; o povo grita
  "Capitão" em vez de "peste".
- Matar morador desarmado: Graça −1.
- Os dois ficam salvos para o "Lampião 2".

---

## Regras do mundo

### Luz

- **Não existe lampião de querosene.** Luz carregável: só **facho** (tocha), por 90 s, no lugar
  da arma, em trechos marcados.
- **Clarão do tiro:** rifle ~14 m, revólver ~8 m, por um instante. Mostra o caminho e mostra o
  jogador a todo inimigo com linha de visão; acorda corpo-seco a 25 m.
- **Fogueira:** luz fixa de 8 m e checkpoint; pode ser apagada; no cap. 7 dá **tição**
  (arremessável, fogo de 3 m).
- **Lua cheia:** luz cinza-azulada em área aberta.
- **Candeeiro e vela:** cenário.
- **Apagão:** susto em que as fogueiras e tochas próximas apagam juntas.

### Fé e prata

- O **terço de Maria** trava Ela e faz recuar corpo-seco. Contra o lobisomem, segura 2 s.
- **Bala de prata** (caixa de Regina, cap. 7) fere o lobisomem.

### Corpo-seco no "Lampião 1"

O quadrinho não tem corpo-seco; o jogo precisa de carniça. Justificativa mínima, sem acrescentar
história: na caverna dos ídolos há corpos secos ajoelhados em nichos, que ficam de pé quando Ela
acorda; desde então, onde Lampião passa, os mortos secos levantam da terra, atraídos pela fome
dela. Ninguém explica por quê.

---

## Mecânicas e a história que justifica cada uma

| Mecânica | Justificativa |
|---|---|
| Rifle | a arma de Lampião, que dá o nome a ele |
| Peixeira | faca de Lampião; silenciosa |
| Revólver | de soldado, no salão dos ídolos (cap. 1); Juliana herda os dos irmãos (cap. 3) |
| Balas de prata | caixa de Regina (cap. 7) |
| Clarão, fogueira, facho, tição | a única luz do sertão |
| Fome, Comer, Tentáculos, Vômito | Ela |
| Terço | de Maria |
| Escolhas morais | pequenas, em cena, sem mudar a história |
| Spawners | nicho, cova, galhada |
| Cavalo | só em cena |

## Linguagem

- Interface em português neutro. Falas em fala sertaneja nordestina, sem exagero de grafia: "num",
  "pra", "home", "tu", "oxe", "valei-me", "cabra", "macaco" (soldado de volante), "bufunfa",
  "rango", "aquieta o facho", "mizera". Palavrão do quadrinho é bem-vindo na boca de quem xinga.
- Falas-chave do quadrinho entram **como estão**.

## Formato narrativo

- **Cartão de capítulo:** fala curta de Lampião, letra branca em fundo preto.
- **Telas de carregamento:** quadro do quadrinho com legenda curta.
- **Folheto de cordel** colecionável, um por capítulo.
- **Cenas curtas** (até 90 s sem devolver o controle).
- **Ponto de vista:** sempre primeira pessoa; trocas curtas de corpo: Ela (cap. 1), Ciro (cap. 4),
  Helena (cap. 6), Juliana (cap. 7).
- **Sustos:** cada capítulo tem uma tabela com tipo (jumpscare, vulto, passos, batida, sussurro,
  respiracao, apagao, chao), zona, gatilho e o que acontece.
