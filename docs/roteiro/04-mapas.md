# Mapas: ponte para o level design

Um mapa por capítulo do "Lampião 1" (caps. 1 a 7; os caps. 5, 6 e 7 dividem o mesmo mapa da vila). Os mapas são
pequenos e densos porque rodam no celular: a área jogável fica entre 3 mil e 10 mil m², e o
resto é borda bloqueada (paredão, caatinga fechada, muro, rio). A escuridão esconde o fim do
mapa; nenhum mapa precisa de horizonte.

## Convenções

- **Coordenadas** em metros, no padrão do Godot: **x = leste (+) / oeste (−)**, **z = sul (+) /
  norte (−)**, **y = altura**. A origem (0, 0) de cada mapa está indicada na seção dele.
- Coordenadas são **aproximadas** (±2 m) e valem mais que o ASCII. O ASCII mostra a forma; as
  coordenadas dão a posição.
- **ASCII:** 1 coluna = 2 m em x; 1 linha = 4 m em z. A coluna da esquerda mostra o z da
  linha. Os desenhos foram gerados a partir das coordenadas das tabelas.
- **Zonas** (Z1, Z2...) batem com as zonas citadas em `03-capitulos/`.
- **Encontros** (E#), **sustos** (!#) e **gatilhos** (g#) batem com as tabelas dos capítulos. Cada
  susto tem um tipo (jumpscare, vulto, passos, batida, sussurro, respiracao, apagao, chao); o
  `gatilho` do mapa dispara a ferramenta de susto correspondente.
- **Luz.** Não existe luz carregada pelo jogador. A luz vem de: **lua cheia** (sempre, em área
  aberta; nunca dentro de caverna ou casa), **clarão do tiro** (rifle: raio 14 m por 0,15 s;
  pistola: 8 m por 0,1 s; revela o jogador a todo inimigo que tenha linha de visão),
  **fogueira** (luz fixa 8 m, **checkpoint**), **candeeiro de parede** e **vela** (cenário,
  luz fixa fraca), **facho** (tocha de NPC; o jogador pode carregar um facho por 90 s no lugar
  da arma) e **tição** (brasa tirada de fogueira, arremessável: bomba de fogo de 3 m, uso único).

## Legenda ASCII (igual em todos os mapas)

```
P  início do jogador            X  saída / fim do capítulo
#  rocha / paredão / borda      :  estrada de terra
.  trilha / chão de caverna     =  cerca de varas
w  cerca de arame farpado       |  porta / porteira / portão / janela
M  muro (pedra ou caiado)       H  casa de taipa
G  casa-grande / sobrado        C  capela / igreja
T  árvore seca / juazeiro       Y  mandacaru / xique-xique
O  pedra grande (cobertura)     ~  lama / açude / água
F  fogueira acesa (checkpoint)  *  caatinga fechada / galhada (borda; agachado esconde)
I  ídolo / totem entalhado      N  nicho com corpo seco (spawner)
Q  claraboia (coluna de lua)    h  cavalo
$  dinheiro                     R  carroça
c  caixote / móvel / barraca    p  arma / munição (pickup)
t  facho / tição (pickup)       +  cruz / cova
b  corpo (cadáver de cenário)   n  NPC vivo
S  segredo / folheto            !  susto
0..9  encontro (E#)             x  marco narrativo
^  bloqueio que fecha após evento   %  bloqueio que abre após evento
o  ponto de rota de criatura    g  gatilho de cena
D  duelo / chefe
```

---

## Catálogo de peças

Vocabulário único para todos os mapas. ✅ = já existe em `world/sertao/props.gd` (função entre
parênteses). 🆕 = peça a criar. ♻️ = existe no template com outro nome. ❌ = sai do jogo.

### Natureza

| Peça | Status | Descrição | Uso |
|---|---|---|---|
| `terreno` / `terreno-relevo` | ✅ (`terreno`, `terreno_relevo`) | chão de caatinga ocre com cascalho | todos |
| `mandacaru` | ✅ (`mandacaru`) | cacto alto de braços, 2–5 m | todos |
| `xique-xique` | ✅ (`xique_xique`) | cacto rasteiro em touceira | todos |
| `arvore-seca` | ✅ (`arvore_seca`) | árvore sem folha | todos |
| `pedra` | ✅ (`pedra`) | pedra solta 0,5–2,5 m | cobertura, borda |
| `paredao` | ✅ (`paredao`) | módulo de rocha vertical | caverna, bordas |
| `lajedo` | 🆕 | laje de pedra plana e baixa, 6–15 m | caps. 1, 4 |
| `pedra-topo-reto` | 🆕 | rocha de 12 × 12 × 6 m com topo plano e loca embaixo | cap. 4 |
| `loca` | 🆕 | abrigo de pedra baixo, entra agachado | cap. 4 |
| `galhada-seca` | 🆕 | moita cinza 1,5 m; agachado some | todos |
| `caatinga-fechada` | 🆕 | módulo de borda (galhada densa + espinho) | todos |
| `juazeiro` | 🆕 | a única árvore verde | caps. 2, 3 |
| `caveira-cavalo` | 🆕 | ossada de cavalo | cap. 2 |

### Caverna dos Ídolos (cap. 1)

| Peça | Status | Descrição |
|---|---|---|
| `caverna-modulo` | 🆕 | módulos de túnel (reto, curva, rampa) de 3 m e de 2 m de largura, teto 3–4 m |
| `salao-caverna` | 🆕 | salão de 28 × 32 m, teto 12 m, com `claraboia` |
| `claraboia` | 🆕 | buraco no teto com coluna de luz de lua (cone, raio 3 m) |
| `arco-pedra` | 🆕 | boca da caverna com pilares lavrados tortos |
| `totem-idolo` | 🆕 | pilar de 3–4 m com rosto de boca aberta e dentes; olhos que acendem (emissão branca) |
| `laje-sepultura` | 🆕 | laje entalhada 6 × 4 m, rachada no meio; recebe sangue (decal) |
| `nicho-corpo-seco` | 🆕 | nicho cavado na parede com corpo seco ajoelhado; **spawner** |
| `caldeirao` | 🆕 | caldeirão de ferro sobre pedras, com sopa |
| `monte-moedas` | 🆕 | moedas espalhadas sobre pedra, sacos de estopa |
| `desmoronamento` | 🆕 | pilha de pedras que cai e fecha túnel (anima em 1 s) |

### Construções e cenário humano

| Peça | Status | Descrição | Uso |
|---|---|---|---|
| `casa-taipa` | ✅ (`casa_taipa`) | taipa de 1 cômodo | sítios, vila |
| `casa-taipa-interior` | 🆕 | taipa de 2–3 cômodos com interior, janela de tábua | caps. 2, 5–7 |
| `parede-taipa-quebravel` | 🆕 | trecho de parede que o lobisomem arrebenta | cap. 6 |
| `casa-grande` | 🆕 | sede de fazenda com interior (sala do cofre, corredor, cozinha) | cap. 1 |
| `casa-caiada` | 🆕 | casa de vila, branca, rachada | caps. 5–7 |
| `capela` | 🆕 | capela de uma nave | caps. 1, 5–7 |
| `choupana` | 🆕 | casinha de palha e vara | cap. 2 |
| `cerca-varas` | ✅ (`cerca_varas`) | cerca de varas | todos |
| `cerca-arame` | 🆕 | arame farpado com mourões grossos | cap. 1 |
| `porteira` / `porta` | ♻️ (`door.tscn`) | porta e porteira | todos |
| `janela-tabua` | 🆕 | janela de tábua com veneziana; parapeito para oferenda | vila |
| `muro-pedra` | ✅ (`muro_pedra`) | muro de pedra seca 1,2 m | caps. 3, 5 |
| `cruz` / `cova` | ✅ (`cruz`, `cova`) | cruz de túmulo, monte de terra; **spawner** quando marcado | todos |
| `cruz-exvoto` | ✅ (`cruz_exvoto`) | cruz de beira de estrada com ex-votos | cap. 3 |
| `cova-cavavel` | 🆕 | marca no chão que vira cova aberta e depois cova fechada | cap. 1 |
| `poco` | ✅ (`poco`) | poço com sarilho | cap. 2 |
| `cacimba` | 🆕 | buraco d'água cercado de pedra | cap. 3 |
| `carroca` | ✅ (`carroca_tombada`) | carroça (tombada ou de pé) | caps. 2, 3 |
| `caixote` | ✅ (`caixote`) | caixote de madeira | todos |
| `barraca-lona` | ✅ (`barraca_lona`) | barraca | — (não usada no Lampião 1) |
| `espantalho` | 🆕 | espantalho de roupa preso em mandacaru | cap. 7 (flashback) |
| `corpo` | ✅ (`corpo`) | cadáver; variações: cangaceiro, soldado, carroceiro | todos |
| `mobilia-sertao` | 🆕 | mesa, tamborete, cama, criado-mudo, santinho, fogão de lenha | interiores |
| `urubu` | 🆕 | urubus pousados que levantam em revoada | caps. 1, 2 |
| `cavalo` | 🆕 | cavalo parado (cenário animado; amarrado ou solto) | caps. 1–4 |

### Luz, itens e interativos

| Peça | Status | Descrição | Uso |
|---|---|---|---|
| `lampiao` | ❌ (`lampiao`) | **sai do jogo**: não existe lampião de querosene | — |
| `garrafa-querosene` / `lata-querosene` | ❌ | saem do jogo | — |
| `fogueira` | ✅ (`fogueira`, `lit`) | acesa: luz 8 m, checkpoint; pode ser **apagada** (interação 1 s) | todos |
| `candeeiro-parede` | 🆕 | luz fixa de cenário 5 m; não é pickup | interiores |
| `vela` | 🆕 | luz 2 m | interiores |
| `facho` | 🆕 | tocha de pau com breu: NPC carrega; jogador pode carregar 90 s | caps. 1, 3, 4, 5 |
| `ticao` | 🆕 | pickup tirado de fogueira acesa; arremessável, fogo de 3 m | cap. 7 |
| `cartucheira` | ♻️ (`ammo_refil.tscn`) | munição de rifle e de revólver | todos |
| `caixa-balas-prata` | 🆕 | caixa escura com lua crescente; 6 balas de prata | cap. 7 |
| `folheto` | 🆕 | folheto de cordel (colecionável, um por capítulo) | todos |
| `bilhete` | 🆕 | papel legível | todos |
| `oferenda-janela` | 🆕 | coisa deixada no parapeito (água, farinha, bala, linha) | Graça |
| `spawner` | ♻️ (`spawner.tscn`) | sempre escondido em `nicho`, `cova` ou `galhada-seca` | todos |
| `gatilho` | ♻️ (`world/gatilho.gd`) | área invisível de cena, susto ou fala | todos |
| `interagivel` | ♻️ (`world/interagivel.gd`) | ponto de "USAR" com texto | todos |

---

## Cap. 1 — `cap01-o-sacrificio` — Fazenda do Coronel e Caverna dos Ídolos

### Resumo

| | |
|---|---|
| **Tipo** | duas áreas desligadas na mesma cena: a Fazenda (prólogo) e a Caverna com o lajedo de fora; a ligação é um corte (cena a cavalo) |
| **Tamanho** | Fazenda: caixa 80 × 72 m, jogável ≈ 2.800 m². Caverna + lajedo: caixa 70 × 136 m, jogável ≈ 3.900 m² |
| **Origem (0, 0)** | a fogueira do bando, logo dentro da boca da caverna |
| **Alturas** | lajedo e salão da boca y = 0; galeria desce até y = −6; Salão dos Ídolos y = −6 (teto y = +6); fenda sobe de y = −6 até y = 0 na saída |
| **Rota** | Z1 Fazenda → (corte) → Z6 lajedo (só passagem) → Z2 Salão da boca → Z3 Galeria → Z4 Salão dos Ídolos → Z5 Fenda → Z6 Lajedo (enterro) |
| **Lua** | cheia, a leste; entra na Z1, na Z6 e na claraboia da Z4. Z2 e Z3 só têm fogueira, facho e clarão |

### ASCII da Fazenda (Z1)

```
 -252 *****************************************
 -248 *         0         0        0          *
 -244 *                                       *
 -240 *                                       *
 -236 *           G$G|GGGGGGGGG|GGG CCCCCC    *
 -232 *           G.....G...G.....G CCCCCC    *
 -228 *           G..P..G...G..n..G CCCCCC 0  *
 -224 *           G.....G...GGGGGGG CCCCCC    *
 -220 *           G.....G...GGGGGGG CCCCCC    *
 -216 *           GGGGGGGG|GGGGGGGG           *
 -212 *    T                        !      0  *
 -208 *                                       *
 -204 *       c        g     O                *
 -200 *  Y                                  0 *
 -196 *                                 0     *
 -192 *                                       *
 -188 wwwwwwwwwww|wwwwwwwwwwwwwwwwwwwwwwwwwwwww
 -184 * X      h h h                     Y    *
 -180 *           n                           *
```

`0` = soldados do E0. A cerca de arame (`w`) corre em z −188. A borda (`*`) é caatinga fechada.

### ASCII da Caverna e do lajedo (Z2–Z6)

```
  -40 ************************************
  -36 *                                  *
  -32 *    +T   X          S             *
  -28 *                        Y         *
  -24 *       + + +                      *
  -20 *  Y                               *
  -16 *          h     h    O            *
  -12 *   O                              *
   -8 *           |||||||             .  *
   -4 #########.......n.....##########g###
    0 #########......F...n..##########.###
    4 #########...........$.##########.###
    8 #########..n.P....n...##########.###
   12 #########.............#########..###
   16 #########.I.......^...#########.####
   20 ##################.############.####
   24 #################1#N##########n.####
   28 ################..############.#####
   32 ##############.N##############.#####
   36 ############!.################.#####
   40 #############..##############.4#####
   44 ##############.#N############.######
   48 #############N^.#############.######
   52 ###############.#############.######
   56 ################.###########!#######
   60 ########...............#####g#######
   64 ########..I.2.....2.I..####4########
   68 ########.......D.......####.########
   72 ########N..2p..Q...2..N##..#########
   76 ########.I...........I....##########
   80 ########......xxxp.....t############
   84 ########N.............N#############
   88 ########..I....3....I..#############
   92 ########...............#############
   96 ####################################
```

O desenho mostra o chão. Tudo que é `#` é rocha (paredão de caverna ou subsolo). As linhas
z −36 a −8 são o lajedo de fora, aberto para o céu. A boca da caverna (`|||`) fica em z −8.

### Zonas e posições

**Z1 — Fazenda do Coronel** (x −40..40, z −252..−180, y 0)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Casa-grande | `casa-grande` | x −16..16, z −236..−216 | frente para o norte (z −236); interior visitável |
| Sala do cofre / início | interior + P | sala x −14..−6, z −234..−226; P (−10, −230) | cofre `caixote` (−14, −234); livro-caixa `bilhete` na mesa (−8, −232) |
| Janela da sala | `janela-tabua` | (−10, −236) | o jogador atira daqui no tutorial |
| Sala da frente | interior | x 6..14, z −234..−226 | porta da frente (10, −236): Benedito entra e se deita em (10, −230) |
| Corredor | interior | x −2..2, z −234..−218 | liga as salas à porta dos fundos |
| Cozinha | interior | x −14..−6, z −224..−218 | fogão de lenha, janela sul (−10, −216) |
| Porta dos fundos | `porta` | (0, −216) | gatilho de saída da casa |
| Capela | `capela` | x 20..30, z −236..−220 | o soldado do g1 sai da quina sudoeste (20, −214) |
| Terreiro de trás | aberto | z −216..−190 | `pedra` (6, −206), `caixote` (−24, −204), `arvore-seca` (−30, −212) |
| Gatilho g1 (Maria ferida) | `gatilho` | caixa x −10..−2, z −210..−202 | cena do tiro em Maria |
| Cerca de arame | `cerca-arame` | linha z −188, x −40..40 | porteira (−18, −188) |
| Cavalos e Vini | `cavalo` ×3 + NPC | cavalos (−22, −184), (−18, −184), (−14, −184); Vini (−16, −182) | gatilho de fim: raio 3 em (−18, −186) |
| Soldados E0 | NPC atirador | (−20, −248), (0, −248), (18, −248) na frente; (34, −228), (34, −212) pela capela; (28, −196), (36, −200) atrás da cerca leste | ver Encontros |
| Candeeiros | `candeeiro-parede` | sala (−14, −228), corredor (0, −224), cozinha (−14, −220) | luz de cenário |
| Saída X | — | (−36, −184) | só decorativo: o gatilho de fim é nos cavalos |

**Z2 — Salão da boca e acampamento do bando** (x −12..12, z −8..16, y 0, teto 6 m)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Boca da caverna | `arco-pedra` | x −6..6, z −8 | pilares lavrados tortos |
| Fogueira do bando | `fogueira` + `caldeirao` | (0, 0) | checkpoint; pode ser apagada no beat 4 |
| Manta de Lampião / P do beat 3 | `mobilia-sertao` (esteira) | (−4, 6) | começo do beat 3 e do beat 4 |
| Maria | NPC | (−8, 8) | deitada; depois corpo para a cena 12 |
| Baraúna | NPC | (6, 8) | |
| Xexéu + moedas + folheto | NPC, `monte-moedas`, `folheto` | Xexéu (8, 2); moedas (10, 4) | folheto no bornal de Xexéu |
| Vini (vigia) | NPC | (2, −4) | some antes do beat 4 |
| Ídolo do pressentimento | `totem-idolo` | (−10, 14) | interação "Olhar" |
| Cavalos (lado de fora) | `cavalo` ×2 visíveis | (−8, −16), (4, −16) | disparam no beat 4 |
| Entrada da galeria | `caverna-modulo` | (6, 16) | |
| Desmoronamento 1 | `desmoronamento` | (6, 18) | gatilho g2 (raio 2 em (6, 20)): fecha **em parte** (os soldados passam um por vez) |
| Soldados E1a | NPC | entram pela boca (0, −8) | 2 soldados |

**Z3 — Galeria** (trilha de 3 m de (6, 16) a (0, 60); y 0 → −6)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Trilha | `caverna-modulo` | (6, 16) → (4, 26) → (−4, 36) → (−2, 46) → (2, 56) → (0, 60) | rampa contínua |
| Nichos | `nicho-corpo-seco` | (8, 24), (0, 30), (−6, 36), (2, 44), (−4, 50) | sem spawner na ida; o de (−6, 36) é o **!4** |
| Gatilho !4 | `gatilho` | raio 3 em (−4, 36) | dispara quando o facho de Vini passa |
| Soldados E1b | NPC | chegam em (4, 26) vindos de trás | 2 soldados |
| Desmoronamento 2 | `desmoronamento` | (−1, 48) | cai depois do E1b: fecha a galeria de vez (`^`) |
| Gatilho do sussurro | `gatilho` | raio 3 em (−2, 46) | "[...fome...]" |
| Vini (rota) | NPC com `facho` | segue a trilha 4 m à frente; espera o jogador se ele ficar a mais de 8 m | |

**Z4 — Salão dos Ídolos** (x −14..14, z 60..92, y −6, teto y +6)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Claraboia | `claraboia` | (0, 74), raio 3 | coluna de lua; único ponto claro fixo |
| Laje rachada | `laje-sepultura` | centro (0, 80), 6 × 4 m | decal de sangue de Vini; inscrição (interação "Olhar") |
| Totens | `totem-idolo` ×6 | (−10, 64), (10, 64), (−12, 76), (12, 76), (−10, 88), (10, 88) | olhos acendem um a um na cena 7 |
| Nichos do salão | `nicho-corpo-seco` + `spawner` | (−14, 70), (14, 70), (−14, 84), (14, 84) | E3: 3 corpos-secos (sorteio de 3 dos 4) |
| Duelo com Vini | D | Lampião (0, 66), Vini (0, 72) | |
| Onde a cabeça cai | marco | (−2, 66) | câmera da cena 7 |
| Soldados E2 (Modo Ela) | NPC | (−6, 62), (6, 62), (−8, 72), (8, 72) | o Coronel entra e foge por (0, 60) |
| Benedito foge | rota | (8, 72) → (14, 80) → fenda | |
| Revólver + balas | `p` | (−6, 70) | pickup da cena 9 |
| Rifle + pente | `p` | (4, 78) | perto do corpo de Vini (2, 78) |
| Gatilho g3 (!7) | `gatilho` | caixa x −4..4, z 76..84 | só depois da cena 9 |
| Saída para a fenda | `caverna-modulo` (2 m) | (14, 80) | corrente de ar (partículas de poeira indo para leste) |

**Z5 — A Fenda** (trilha de 2 m de (14, 80) a (34, −4); y −6 → 0)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Trilha | `caverna-modulo` (2 m, rampa) | (14, 80) → (22, 72) → (26, 60) → (28, 46) → (30, 32) → (32, 18) → (34, 6) → (34, −4) | |
| Facho largado | `facho` (pickup) | (16, 78) | ilumina 5 m por 90 s |
| Gatilho g4 (terço) | `gatilho` | raio 3 em (26, 60) | tutorial do terço, se a fome ainda não passou de 75 |
| Nichos-spawner E4 | `nicho-corpo-seco` + `spawner` | (24, 66), (29, 40) | 5 corpos-secos, máx. 3 vivos, intervalo 6 s |
| Nicho do !9 | `nicho-corpo-seco` | (27, 54) | o corpo aparece fora do nicho quando a luz volta |
| Nicho de Benedito | NPC + `pedra` | (31, 24) | gatilho da escolha: raio 3 |
| Saída da fenda | `gatilho` | (34, −4) | começa a cena 12 (luz cinza-azulada) |

**Z6 — Lajedo de fora** (x −28..38, z −36..−8, y 0)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Lajedo | `lajedo` | quase todo o retângulo | marcas de casco e cartuchos vazios em (10, −14) |
| Pedras | `pedra` | (14, −14), (−22, −12) | |
| Mandacarus | `mandacaru` | (−24, −20), (20, −28) | |
| Covas | `cova-cavavel` ×3 | (−14, −24), (−10, −24), (−6, −24) | Maria, Baraúna, Xexéu |
| Cova de Vini | `cova-cavavel` | (−20, −30) | opcional |
| Árvore seca | `arvore-seca` | (−18, −34) | silhueta do quadrinho (E1 36) |
| Fim X | marco | (−10, −30), olhando para leste | o sol nasce a leste (+x) |
| Segredo S | `cartucheira` | (12, −30) | munição de rifle esquecida pela volante |

### Encontros e spawners

| # | Zona | Spawner / posição | Criaturas | Regras |
|---|---|---|---|---|
| E0 | Z1 | pontos fixos (tabela Z1) | 7 soldados | atiram de onde estão; avançam 4 m a cada 10 s; o jogador não precisa matar ninguém |
| E1a | Z2 | boca (0, −8) | 2 soldados | só entram depois do diálogo do Coronel |
| E1b | Z3 | (4, 26) | 2 soldados | passam pelo desmoronamento 1 um por vez |
| D | Z4 | (0, 72) | Vini | 2 golpes de peixeira; coronhada 15 de dano |
| E2 | Z4 | (−6, 62), (6, 62), (−8, 72), (8, 72) | 4 soldados | Modo Ela: tiros não ferem; morrem com 1 Tentáculo |
| E3 | Z4 | nichos (−14, 70), (14, 70), (−14, 84), (14, 84) | 3 corpos-secos | acordam juntos no !7 |
| E4 | Z5 | nichos (24, 66), (29, 40) | 5 corpos-secos, máx. 3 vivos | param ao chegar à escolha de Benedito |

### Itens

| Item | Posição | |
|---|---|---|
| saco de moedas (objetivo) | cofre (−14, −234) | vai para as costas; some no beat 3 |
| rifle + 3 pentes | com o jogador desde o início | vazio no duelo |
| revólver + 12 balas | (−6, 70) | |
| rifle (de volta) + 1 pente | (4, 78) | |
| facho | (16, 78) | |
| cartucheira | (12, −30) | segredo |
| terço | dado por Maria no beat 3 | vai para o pulso; no fim, para o pescoço |
| folheto | Xexéu (8, 2) | "O Rifle que Alumiava a Noite" |
| bilhetes | livro-caixa (−8, −232); bolso de Vini (2, 78) | |

### Ritmo de luz e escuridão

| Trecho | Luz | Sensação |
|---|---|---|
| Z1 | lua cheia, candeeiros dentro da casa, clarões de muitos tiros | ação, barulho; aprende que tiro ilumina e entrega |
| Corte a cavalo | lua | respiro |
| Z2 (beat 3) | fogueira | calor, a última noite em família |
| Z2 (beat 4) | fogueira, depois só clarões (se apagar) | pânico, veneno |
| Z3 | facho de Vini, 4 m | aperto; depender da luz de outro |
| Z4 | coluna de lua no meio, resto preto | o salão é um palco |
| Z5 | escuro total; facho opcional, clarões | o pior trecho; o terço vira luz de outro tipo |
| Z6 | cinza-azulado, depois sol | luto e juramento |

### Peças usadas no cap. 1

Existentes: `terreno`, `terreno_relevo`, `mandacaru`, `xique_xique`, `arvore_seca`, `pedra`,
`paredao`, `fogueira`, `caixote`, `corpo`, `cova`, `cruz`.
Template: `porta` (`door.tscn`), `cartucheira` (`ammo_refil.tscn`), `spawner`, `gatilho`,
`interagivel`.
**A criar (prioridade do cap. 1):** `casa-grande` (com interior), `capela` (fachada), `cerca-arame`,
`candeeiro-parede`, `janela-tabua`, `cavalo`, `arco-pedra`, `caverna-modulo`, `salao-caverna`,
`claraboia`, `totem-idolo`, `laje-sepultura`, `nicho-corpo-seco`, `caldeirao`, `monte-moedas`,
`desmoronamento`, `facho`, `lajedo`, `cova-cavavel`, `folheto`, `bilhete`.
**Sai do cap. 1 atual:** `lampiao`, `lata-querosene`, `garrafa-querosene`, `barraca-lona`,
`carroca_tombada`, `muro_pedra`, `cruz_exvoto`, `caminhao` (jeep).

---

## Cap. 2 — `cap02-emboscada` — Estrada do Riacho Fundo

| | |
|---|---|
| **Tipo** | estrada linear → sítio → trilha de caatinga → choupana |
| **Tamanho** | caixa 100 × 180 m; jogável ≈ 6.500 m² |
| **Origem (0, 0)** | a carroça virada |
| **Rota** | Z1 Estrada (pôr do sol) → Z2 Carroça → Z3 Sítio dos velhos → Z4 Caatinga do rastro (noite) → Z5 Choupana |

```
  -80 ********************:******************************
  -76 *********           :                   ***********
  -72 *********           P                   ***********
  -68 *********           :                   ***********
  -64 *********           :                   ***********
  -60 *********    T      :                   ***********
  -56 *********           :                   ***********
  -52 *********           :                   ***********
  -48 *********         x :                   ***********
  -44 *********           :                   ***********
  -40 *********           :                   ***********
  -36 *********           :  1                ***********
  -32 *********           :                   ***********
  -28 *********           :                   ***********
  -24 *********           :                   ***********
  -20 *********       1   :                   ***********
  -16 *********           :       Y           ***********
  -12 *********           :                   ***********
   -8 *********           :   h               ***********
   -4 *********           :                   ***********
    0 *********           R b                 ***********
    4 *********         b :::     ===========           *
    8 *********              ::::::HHHnHnH  =           *
   12 *********                    HHHHHHH o=           *
   16 *********                    HHHHHHS  =           *
   20 *********                    HHHHHHH  =           *
   24 *********                   ====.======           *
   28 **************                ..                  *
   32 **************              ..                    *
   36 **************            ..     *******          *
   40 **************          ..       *******          *
   44 **************        ...        *******          *
   48 *********     2    ...           *******          *
   52 *********       ...              *******          *
   56 *********      ..                *******          *
   60 *********   2   .                *******          *
   64 ***************  .       2                        *
   68 ***************   .                               *
   72 ***************    .                              *
   76 ***************     .                             *
   80 *********           gn                            *
   84 *********         HHHHH   T                       *
   88 *********     O  FHHHHH                           *
   92 *********         HHHHH                           *
   96 *********           X                             *
  100 ***************************************************
```

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Início | P | (0, −72) | sol baixo a oeste |
| Z1 | Caveira de cavalo + urubus | `caveira-cavalo`, `urubu` | (−4, −50) | conversa sobre o mar começa aqui |
| Z1 | Corpos-secos E1 | `galhada-seca` + `spawner` | (−8, −20), (6, −36) | 1 cada, de tocaia na galhada |
| Z2 | Carroça virada | `carroca` | (0, 0) | |
| Z2 | Carroceiro morto | `corpo` | (3, 2) | escolha 1 (Marca) |
| Z2 | Cavalo morto | `corpo` (cavalo) | (−4, 4) | comer: fome −40 |
| Z2 | Cavalo vivo | `cavalo` | (8, −6) | interação "Acalmar" |
| Z3 | Casa dos velhos | `casa-taipa-interior` | x 18..30, z 8..20 | Dona Socorro na porta (24, 8); Seu Tonho (28, 6) |
| Z3 | Cerca e poço | `cerca-varas`, `poco` | cerca em volta; poço (34, 12) | |
| Z3 | Segredo | `folheto` | (30, 18) | "A Moça que Fugiu com o Cão" |
| Z4 | Trilha do rastro | trilha | (24, 24) → (10, 40) → (−10, 56) → (0, 76) | pegadas de cavalo visíveis só no clarão e na lua |
| Z4 | Cemiteriozinho e corpos-secos E2 | `cruz`, `cova` + `spawner` | (−12, 48), (10, 62), (−16, 60) | saem do chão um de cada vez; o tiro acorda o próximo |
| Z5 | Choupana | `choupana` | x −4..4, z 84..92 | |
| Z5 | Fogueira | `fogueira` | (−6, 86) | a verdadeira (checkpoint) |
| Z5 | Juliana | NPC | (2, 80) | sentada |
| Z5 | Antônio / Marconi | NPC | Antônio atrás da `pedra` (−12, 90); Marconi atrás do `juazeiro` (12, 84) | |
| Z5 | Gatilho da emboscada | `gatilho` | raio 4 em (0, 80) | |

Peças: `terreno`, `mandacaru`, `arvore-seca`, `caatinga-fechada`, `galhada-seca`, `caveira-cavalo`,
`urubu`, `carroca`, `cruz`, `corpo`, `cavalo`, `casa-taipa-interior`, `cerca-varas`, `poco`, `cova`,
`choupana`, `fogueira`, `juazeiro`, `pedra`, `spawner`, `gatilho`, `folheto`.

---

## Cap. 3 — `cap03-juliana` — A Cacimba da Cruz

| | |
|---|---|
| **Tipo** | arena pequena: acampamento dos irmãos, cacimba e cemitério de beira de estrada |
| **Tamanho** | caixa 80 × 100 m; jogável ≈ 4.500 m² |
| **Origem (0, 0)** | a cacimba |
| **Rota** | (cena do arrasto) → Z1 Juazeiro (amarrado) → Z2 Acampamento → Z3 Cemitério → Z2 confronto → (corte) sítio dos velhos (reusa a Z3 do cap. 2) → Z4 Estrada (o Vulto) |

```
  -40 *****************************************
  -36 *                                  x    *
  -32 *                                       *
  -28 :::::X:::::::::::::::::::::::::::::::::::
  -24 *                                       *
  -20 *         +                             *
  -16 *                                       *
  -12 *                                       *
   -8 *       Y                     S         *
   -4 *                      hph              *
    0 *                   ~                   *
    4 *                P        O             *
    8 *                T  F                   *
   12 *                  n n                  *
   16 *            O        n    MMMMMMMMM    *
   20 *                   g      M       M 3  *
   24 *              *           | + + + M    *
   28 *                          M       M    *
   32 *                          MMMMMMMMM 3  *
   36 *                               3       *
   40 *                                       *
   44 *                                       *
   48 *                                       *
   52 *                                       *
   56 *                                       *
   60 *****************************************
```

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Lampião amarrado / P | `juazeiro` + P | (−6, 6) / (−6, 4) | segure para alcançar a peixeira da bota |
| Z2 | Cacimba | `cacimba` | (0, 0) | os cavalos bebem |
| Z2 | Cavalos + rifle | `cavalo` ×2, `p` | (6, −4), (10, −4); rifle (8, −4) | furtividade para pegar o rifle |
| Z2 | Fogueira dos irmãos | `fogueira` | (0, 8) | checkpoint; dá para apagar |
| Z2 | Antônio, Marconi, Juliana | NPC | (2, 12), (−2, 12), (4, 16) | |
| Z2 | Gatilho do confronto | `gatilho` | raio 3 em (0, 20) | |
| Z3 | Cemitério de beira de estrada | `muro-pedra` x 14..30, z 16..32; portão (14, 24) | | 3 `cruz` dentro |
| Z3 | Covas dos enjeitados E3 | `cova` + `spawner` | (34, 20), (34, 30), (24, 36) | corpos-secos atacam todo mundo |
| Z3 | Segredo | `cartucheira` | (20, −8) | |
| Z4 | Cruz da estrada | `cruz-exvoto` | (−20, −20) | |
| Z4 | Estrada | estrada | z −28 | saída X (−30, −28) |
| Z4 | O Vulto | marco | em cima de `pedra` (30, −36) | cena final |

Peças: `juazeiro`, `cacimba`, `cavalo`, `fogueira`, `muro-pedra`, `cruz`, `cova`, `cruz-exvoto`,
`pedra`, `galhada-seca`, `mandacaru`, `spawner`, `gatilho`.

---

## Cap. 4 — `cap04-painho` — A mata e a Pedra de Topo Reto

| | |
|---|---|
| **Tipo** | prólogo na vila (reusa o mapa da vila, ver cap. 5) + trilha de caatinga funda até uma rocha com loca |
| **Tamanho** | caixa 120 × 140 m; jogável ≈ 5.500 m² |
| **Origem (0, 0)** | o centro da Pedra de Topo Reto |
| **Rota** | prólogo Ciro (vila) → Z1 Chegada a cavalo → Z2 A mata → Z3 A Pedra e a loca → Z4 Volta (escolta) |

```
 -100 *************************************************************
  -96 **************                               ****************
  -92 **************               .P h  F         ****************
  -88 **************           ....                ****************
  -84 **************   2    ....                   ****************
  -80 **************      ..                       ****************
  -76 **************     .                         ****************
  -72 ************** ****.****************  3      ****************
  -68 ************** ***.*****************         ****************
  -64 ************** ***.*****************         ****************
  -60 ************** **.****************** 2       ****************
  -56 ************** ***.*****************         ****************
  -52 ************** !**..****************         ****************
  -48 ************** ****.****************         ****************
  -44 ************** *****..**************         ****************
  -40 ************** ******...************      3  ****************
  -36 ************** ********...**********         ****************
  -32 ************** **********...********         ****************
  -28 ************** ************....*****         ****************
  -24 **************                ...            ****************
  -20 ************** 3                 ...         ****************
  -16 **************                   ...         ****************
  -12 **************                 ...           ****************
   -8 **************                |.             ****************
   -4 **************             OOOOOOO           ****************
    0 **************             O.S..$O           ****************
    4 **************             Op..n.O           ****************
    8 **************             OOOOOOO           ****************
   12 **************    T                          ****************
   16 **************                               ****************
   20 **************                          X    ****************
   24 **************                               ****************
   28 **************                               ****************
   32 **************                               ****************
   36 **************                               ****************
   40 *************************************************************
```

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Início, cavalos, fogueira | P, `cavalo`, `fogueira` | P (0, −92); cavalos (4, −92); fogueira (10, −90) | Juliana acende a fogueira (checkpoint) |
| Z2 | A mata | `caatinga-fechada` mais alta, `galhada-seca` | x −30..10, z −72..−28 | trilha estreita em zigue-zague; corrente arrastada no chão |
| Z2 | Gatilho do apagão (!3) | `gatilho` | (−20, −44) | o facho de Juliana apaga |
| Z2 | Susto !4 (vulto) | `gatilho` | (−30, −50) | dois olhos brancos na galhada ao olhar para trás |
| Z3 | Pedra de Topo Reto | `pedra-topo-reto` | x −6..6, z −4..8 | entrada da loca (0, −8), agachado |
| Z3 | Ciro acorrentado | NPC | (2, 4) | |
| Z3 | Munição, dinheiro, folheto | `cartucheira`, `$`, `folheto` | (−4, 4), (4, 0), (−2, 0) | o coito do bando |
| Z4 | Corpos-secos E2/E3 | `cova` / `galhada-seca` + `spawner` | E2: (−26, −84), (14, −60); E3: (−30, −20), (24, −40), (16, −72) | E3 só na volta, com Ciro no cavalo |
| Z4 | Saída X | — | (20, 20) | estrada para a vila |

Peças: `pedra-topo-reto`, `loca`, `caatinga-fechada`, `galhada-seca`,
`cavalo`, `fogueira`, `cova`, `corrente` (🆕, cenário), `cartucheira`, `folheto`, `spawner`, `gatilho`.

---

## Caps. 5, 6 e 7 — Vila Boa Vista (mapa compartilhado)

| | |
|---|---|
| **Tipo** | vila de uma rua com largo, capela e cemitério |
| **Tamanho** | caixa 120 × 72 m; jogável ≈ 6.000 m² |
| **Origem (0, 0)** | a porta da casa de Ciro, na rua |
| **Usado em** | prólogo do cap. 4 (Ciro em casa), cap. 5 (a chegada e a multidão), cap. 6 (a transformação e a caça), cap. 7 (a luta no largo) |

```
  -28 *************************************************************
  -24 *                                                           *
  -20 *     Y                       g              o              *
  -16 *       HHHHH   HHHHH   HHHHHHHHH  HHHHHHHHHH   HHHHH       *
  -12 *       HHHHH   HHHHH   HHHHHHxH!  HHHHHHHHHH   HHHHH     n *
   -8 *       HHHHH   HHHHH   HHHHHHHHH  HHnHHHHHHH   HHHHH       *
   -4 *                           HH|HH                           *
    0 ::P::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    4 *                         g       g                         *
    8 *       HHHHH   HHHHHcHH                HHHHH   HHHHH       *
   12 *       HHHHH   HHHHHHHH                HHHHH   HHHHH       *
   16 *       HHHHH   HHHHHHHH                HHHHH   HHHHH       *
   20 *              o              F                         T   *
   24 *                                             MMMMMMMMMM    *
   28 *                          CCCCCCC            MM 3    MM    *
   32 *                          CCCCCCC            MM      MM    *
   36 *                          CCCCCCC            MM    3 MM    *
   40 *                                             MMMM3MMMMM    *
   44 *************************************************************
```

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Entrada da vila / P | estrada | (−56, 0) | cap. 5 começa aqui |
| Rua | estrada | z 0, x −60..60 | |
| Casa de Ciro | `casa-taipa-interior` | x −4..4, z −16..−4; porta (0, −4); quarto (0, −12) | janela do quarto (4, −12): o Vulto aparece aqui (cap. 6) |
| Parede quebrável | `parede-taipa-quebravel` | lado sul do quarto, (0, −6) | o lobisomem arrebenta no cap. 6 |
| Casa de Dona Cândida | `casa-taipa-interior` | x 10..18, z −16..−8; janela (14, −8) | oferenda da linha |
| Demais casas | `casa-taipa` | norte: x −40, −24, 24, 40 (z −16..−8); sul: x −40, −24, 24, 40 (z 8..16) | cada porta tem fala de "vai embora" (cap. 5) |
| Bodega | `casa-caiada` | x −22..−14, z 8..16 | telhado acessível: Juliana atira daqui (cap. 6), y +4 |
| Largo e cruzeiro | `cruz`, aberto | cruzeiro (0, 22); fogueira do largo (0, 18) | checkpoint; fonte de **tição** (cap. 7) |
| Capela | `capela` | x −6..6, z 28..36 | |
| Cemitério | `muro-pedra`, `cova` + `spawner` | muro x 32..50, z 24..40; covas (38, 30), (44, 34), (40, 40) | corpos-secos dos caps. 5–7 |
| Casa de Regina | `casa-taipa` | ponta leste da rua: NPC em (56, −12) | ela chega por aqui; a janela da caixa de prata (cap. 7) |
| Gatilhos da multidão | `gatilho` | (−8, 4), (8, 4) | a multidão ocupa a rua entre eles |
| Gatilho da janela | `gatilho` | (0, −20) | cap. 6 |
| Rotas | `o` | moradores fogem por (−30, 20) e (30, −20) | cap. 6 |

Peças: `casa-taipa`, `casa-taipa-interior`, `parede-taipa-quebravel`, `casa-caiada`, `janela-tabua`,
`capela`, `cruz`, `muro-pedra`, `cova`, `fogueira`, `candeeiro-parede`, `vela`, `mobilia-sertao`,
`ticao`, `caixa-balas-prata`, `oferenda-janela`, `boneca` (🆕), `mandacaru`, `arvore-seca`, `spawner`, `gatilho`.

**Área extra do cap. 7 (flashback de Juliana):** caixa separada em x 200..240, z −20..20: roça
seca com 5 `espantalho` presos em `mandacaru` a 10, 15, 20, 25 e 30 m de um tamborete em
(200, 0). O pai de Juliana sentado ao lado.

---

## Peças: prioridade de produção

| Prioridade | Peças |
|---|---|
| **Já existem** | `terreno`, `terreno_relevo`, `mandacaru`, `xique_xique`, `arvore_seca`, `pedra`, `paredao`, `casa_taipa`, `cerca_varas`, `cruz`, `cova`, `fogueira`, `caixote`, `corpo`, `poco`, `muro_pedra`, `cruz_exvoto`, `carroca_tombada` |
| **Sai do jogo** | `lampiao` (e qualquer pickup de querosene) |
| **1 — cap. 1** | `casa-grande`, `capela`, `cerca-arame`, `candeeiro-parede`, `janela-tabua`, `cavalo`, `arco-pedra`, `caverna-modulo`, `salao-caverna`, `claraboia`, `totem-idolo`, `laje-sepultura`, `nicho-corpo-seco`, `caldeirao`, `monte-moedas`, `desmoronamento`, `facho`, `lajedo`, `cova-cavavel`, `folheto`, `bilhete` |
| **2 — vários capítulos** | `galhada-seca`, `caatinga-fechada`, `casa-taipa-interior`, `mobilia-sertao`, `juazeiro`, `urubu`, `vela`, `casa-caiada`, `oferenda-janela` |
| **3 — um capítulo** | `choupana`, `caveira-cavalo`, `cacimba`, `pedra-topo-reto`, `loca`, `corrente`, `parede-taipa-quebravel`, `ticao`, `caixa-balas-prata`, `espantalho`, `boneca` |
