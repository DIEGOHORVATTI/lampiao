# Mapas: ponte para o level design

Um mapa por capítulo. Os mapas são pequenos e densos, porque precisam rodar no celular: a
área jogável fica entre 6 mil e 12 mil m², e o resto é borda bloqueada (paredão, cerca ou
caatinga fechada com neblina). A neblina e a escuridão escondem o fim do mapa, e nenhum
mapa precisa de horizonte.

## Convenções

- **Coordenadas** em metros, no padrão do Godot: **x = leste (+) / oeste (−)**, **z = sul (+) /
  norte (−)**, **y = altura**. A origem (0, 0) de cada mapa está indicada na seção dele.
- Coordenadas são **aproximadas** (±2 m). Elas valem mais que o ASCII. O ASCII mostra a
  forma, as coordenadas dão a posição.
- **ASCII:** 1 coluna = 2 m em x; 1 linha = 4 m em z. A coluna da esquerda mostra o z da linha.
- **Zonas** (Z1, Z2...) batem com as zonas citadas nos arquivos de `03-capitulos/`.
- **Encontros** (E1...) e **sustos** (!1...) batem com as tabelas dos capítulos.
- **Luz fixa** (fogueira, candeeiro, vela) = zona de respiro e **ponto de controle**.

## Legenda ASCII (igual em todos os mapas)

```
P  início do jogador            X  saída / fim do capítulo
#  paredão / rocha / borda      :  estrada de terra
.  trilha                       =  cerca de varas
M  muro (pedra ou caiado)       |  portão / porteira / porta
T  árvore seca / juazeiro       Y  mandacaru / facheiro
O  pedra grande (cobertura)     ~  açude seco / lama
A  barraca de lona              R  carroça
V  caminhão da volante          H  casa de taipa
G  casa caiada / casa-grande    C  capela / igreja
+  cruz                         F  fogueira (luz fixa)
f  fogueira apagada             c  caixote
L  lampião (pickup)             K  querosene (garrafa ou lata)
p  pistola / arma               m  munição (cartucheira)
g  garrafada                    B  barril de pólvora
b  corpo do bando               j  Jurema (alma)
S  segredo / folheto            !  susto
1..9  encontro (número = E#)    u  cova extra (só cenário)
x  marco narrativo              ^  borda bloqueada após evento
*  galhada / milho seco / caatinga fechada (esconde agachado; fora da trilha, é borda)
%  elemento que muda (cipó trançado, parede de taipa que quebra)
o  ponto de rota ou circuito de criatura      e  espojadouro
v  vassourinha (coleta)         r  pinhão-roxo (coleta)
z  Zé Mirim                     l  Liberato
s  sacristia
```

---

## Catálogo de peças

Vocabulário único para todos os mapas. Os nomes em `código` são os ids. ✅ = já existe em
`world/sertao/props.gd` (nome da função entre parênteses). 🆕 = peça a criar. ♻️ = existe no
template com outro nome.

### Natureza

| Peça | Status | Descrição | Uso |
|---|---|---|---|
| `terreno` | ✅ (`terreno`) | chão de caatinga, terra ocre com cascalho | base de todo mapa |
| `mandacaru` | ✅ (`mandacaru`) | cacto alto de braços, 2–5 m | marco visual, cobertura fina |
| `arvore-seca` | ✅ (`arvore_seca`) | árvore sem folha (baraúna, umburana) | marco, silhueta contra o céu |
| `pedra` | ✅ (`pedra`) | pedra solta de 0,5–2,5 m | cobertura, borda |
| `paredao` | 🆕 | módulo de rocha vertical 10 × 12 m, face rugosa | paredes de grota, bordas |
| `lajedo` | 🆕 | laje de pedra plana e baixa, 6–15 m | chão de pedra, coito, emboscada |
| `loca` | 🆕 | abrigo de pedra baixo (1,2 m), só agachado | segredo, coito |
| `cascalho` | 🆕 | faixa de pedrisco solto, 3 m de largura | trilhas em rampa |
| `xique-xique` | 🆕 | cacto rasteiro em touceira, 1 m | cobertura baixa, dano leve ao encostar |
| `facheiro` | 🆕 | cacto colunar fino, 4–6 m | marco vertical |
| `macambira` | 🆕 | bromélia espinhosa em touceira | borda baixa |
| `galhada-seca` | 🆕 | moita de galhos cinzas, 1,5 m | esconderijo (agachado some) |
| `juazeiro` | 🆕 | árvore de copa verde-escura, a única verde da caatinga | marco, latada natural |
| `gameleira` | 🆕 | árvore grande de brejo, raízes aéreas | cap. 2 |
| `mata-brejo` | 🆕 | módulo de mata úmida (samambaia, cipó, folhagem) | parede vegetal do brejo |
| `cipo-trancado` | 🆕 | parede de cipós trançados, removível | bloqueio da Fulozinha |
| `olho-dagua` | 🆕 | fio d'água numa pedra com poça | marco do brejo |
| `toco` | 🆕 | toco de árvore com oferendas | oferenda (cap. 2 e 8) |
| `acude-seco` | 🆕 | placas de lama rachada, 3 × 3 m | chão de açude |
| `lama-mole` | 🆕 | placa que afunda e faz barulho | ruído, ritmo |
| `carcaca-boi` | 🆕 | esqueleto de boi | marco, cobertura baixa |
| `milho-seco` | 🆕 | módulo de roça morta, 4 × 4 m, 1,6 m de altura | esconde agachado, faz barulho |
| `espojadouro` | 🆕 | terreiro de poeira fina com marcas de rolar | cap. 5 e 7 |
| `neblina` | 🆕 | volume de neblina baixa (0–1,5 m) | todo mapa; esconde borda |

### Construções e cenário humano

| Peça | Status | Descrição | Uso |
|---|---|---|---|
| `casa-taipa` | ✅ (`casa_taipa`) | casa de taipa de 1 cômodo | sítios, vila |
| `casa-taipa-grande` | 🆕 | taipa de 3 cômodos com interior, telhado de telha | Dorinha, Liberato, Damião |
| `casa-caiada` | 🆕 | casa de vila, parede branca, porta e duas janelas | vila |
| `casa-grande` | 🆕 | sede de fazenda com alpendre de colunas | cap. 9 |
| `parede-taipa-quebravel` | 🆕 | trecho de parede de taipa que racha e cede | cap. 5 |
| `porta-taipa` | ♻️ (`door.tscn`) | porta de tábua com tranca; abre ao chegar perto se destrancada | todas as casas |
| `janela-madeira` | 🆕 | janela de duas folhas que abre e bate; parapeito para oferenda | vila, sítios |
| `latada` | 🆕 | pergolado de varas com palha | bodega, quintal |
| `cerca-varas` | ✅ (`cerca_varas`) | cerca de varas tortas | sítios, cemitério |
| `curral` | 🆕 | cerca-varas fechada, alta (1,8 m), com porteira | sítios |
| `porteira` | ♻️ (`door.tscn`) | porteira de madeira de 4 m | curral, fazenda |
| `chiqueiro` | 🆕 | cercadinho baixo de varas e tábuas | sítios |
| `muro-pedra` | 🆕 | muro de pedra seca, 1,2 m | cemitérios de beira de estrada |
| `muro-caiado` | 🆕 | muro branco, 2 m | cemitério da vila, fazenda |
| `portao-cemiterio` | ♻️ (`door.tscn`) | portão de ferro ou de tábua | cemitérios |
| `cruz` | ✅ (`cruz`) | cruz de madeira de túmulo | cemitérios |
| `cruz-torta` | 🆕 | variação de `cruz`, inclinada, com entalhe | enjeitados |
| `cruz-beira-estrada` | 🆕 | `cruz` alta com fitas, retrato e ex-votos pendurados | marco de estrada |
| `cruzinha` | 🆕 | cruz pequena pintada de branco e azul | cemitério de anjinhos |
| `cruzeiro` | 🆕 | cruz grande de adro sobre base de pedra, 5 m | vila, fazenda |
| `cova-rasa` | 🆕 | monte de terra com ou sem cruz; **spawner** de corpo-seco | todos |
| `cova-aberta` | 🆕 | buraco de cova com terra ao lado | enterro, spawner |
| `capela` | 🆕 | capela pequena de uma nave, interior | cap. 9 |
| `igreja` | 🆕 | matriz com torre de sino e escadaria de 11 degraus | cap. 4 e 6 |
| `cripta` | 🆕 | porão de pedra sob capela, nichos | cap. 9 |
| `oratorio` | 🆕 | nicho de madeira com santos e velas | interiores |
| `ex-voto` | 🆕 | peças de madeira/cera penduradas (cabeça, perna, peito, cachorro) | cruzes, oratórios |
| `bodega` | 🆕 | casa-caiada com balcão, prateleiras e latada | vila |
| `botica` | 🆕 | casa-caiada com balcão de remédio + quarto + alçapão | cap. 4 |
| `porao` | 🆕 | porão de pedra baixo (2,1 m de pé-direito) | botica, fazenda |
| `barraca-feira` | 🆕 | barraca de pau e palha | vila |
| `casa-farinha` | 🆕 | galpão aberto: `forno-barro`, roda de ralar, prensa de fuso, cochos | cap. 3 |
| `barracao` | 🆕 | armazém comprido de alvenaria (o barracão do coronel) | cap. 8 (ruína), 9 |
| `tronco` | 🆕 | tronco de castigo com argolas | cap. 9 |
| `barragem` | 🆕 | muro de contenção de pedra e cal, 40 m, com `comporta` | cap. 9 |
| `comporta` | 🆕 | portão de ferro com manivela na barragem | cap. 9 |
| `poco` | ✅ (`poco`) | poço com sarilho | sítios |
| `cacimba` | 🆕 | buraco d'água raso cercado de pedra | caatinga |
| `canoa-encalhada` | 🆕 | canoa de madeira no meio do açude seco | cap. 3 |
| `espantalho` | 🆕 | espantalho de chapéu de palha | roça |
| `barraca-lona` | 🆕 | barraca de lona da volante ou do bando, 4 × 3 m | cap. 1, 3, 8 |
| `carroca` | 🆕 | carroça de duas rodas (pode estar tombada) | todos |
| `caixote` | 🆕 | caixote de madeira de munição | todos |
| `saco-farinha` | 🆕 | saco de estopa cheio | barracão, bodega |
| `tabua-cabecas` | 🆕 | tábua sobre dois caixotes com 7 cabeças etiquetadas | cap. 4 |
| `mobilia-sertao` | 🆕 | kit: mesa de tábua, tamborete, rede, esteira, cama, talha, pilão, fogão de lenha | interiores |
| `estante-vidros` | 🆕 | estante com vidros cobertos de pano | botica |
| `corpo-bando` | 🆕 | cadáver sem cabeça com roupa de cangaceiro (6 variações) | cap. 1 |
| `urubu` | 🆕 | urubus pousados que levantam em revoada | cap. 1, 8 |

### Luz, itens e interativos

| Peça | Status | Descrição | Uso |
|---|---|---|---|
| `lampiao` | ✅ (`lampiao`) | lampião de querosene (o do jogador; pickup quando apagado) | todos |
| `fogueira` | 🆕 | fogueira acesa: luz fixa de 8 m, **checkpoint** | todos |
| `fogueira-apagada` | 🆕 | brasa e cinza, sem luz | cenário |
| `candeeiro-parede` | 🆕 | candeeiro pendurado: luz fixa de 5 m; pode ser **esvaziado** para o lampião (+15%) | interiores, vila |
| `vela` | 🆕 | vela de oratório: luz de 2 m | interiores |
| `garrafa-querosene` | 🆕 | pickup +25% de querosene | todos |
| `lata-querosene` | 🆕 | pickup +50% (cap. 1: a lata da cabeça) | todos |
| `cartucheira` | ♻️ (`ammo_refil.tscn`) | munição de pistola e rifle | todos |
| `garrafada` | 🆕 | garrafa de remédio de raiz: cura | a partir do cap. 2 |
| `barril-polvora` | ♻️ (`exploding_barrel.tscn`) | barril de pólvora da volante | caps. 4, 8, 9 |
| `caminhao` | ♻️ (`jeep.tscn`) | caminhão Ford da volante, carroceria de tábua | caps. 1, 8, 9 |
| `folheto` | 🆕 | folheto de cordel no chão ou num bornal (colecionável) | um por capítulo |
| `bilhete` | 🆕 | papel legível (texto de ambiente) | todos |
| `oferenda-janela` | 🆕 | itens no parapeito de uma `janela-madeira` (cuia, querosene, garrafada, munição) | Graça |
| `spawner` | ♻️ (`spawner.tscn`) | ponto de surgimento, sempre escondido numa `cova-rasa`, `galhada-seca` ou vala | todos |
| `gatilho` | 🆕 | área invisível que dispara susto, fala ou cena | todos |

---

## Cap. 1 — `cap01-a-cabeca` — Grota da Baraúna

### Resumo

| | |
|---|---|
| **Tipo** | platô de caatinga com encruzilhada + grota estreita de pedra (linear) |
| **Tamanho** | caixa total 88 × 210 m; área jogável ≈ 7.500 m² |
| **Origem (0, 0)** | a fogueira do acampamento da volante |
| **Alturas** | platô y = 0; fundo da grota y = −12; trilhas em rampa entre os dois |
| **Rota** | Z1 Acampamento → Z2 Cemiteriozinho → Z3 Trilha do paredão → Z4 Grota → Z5 Saída sul |
| **Prólogo** | a Z4 de madrugada, com chuvisco e soldados na borda do paredão |

### ASCII (1 col = 2 m em x, 1 linha = 4 m em z)

```
     x: -30              0                   40   58
  -40                ^
  -36                :
  -32                :
  -28                :
  -24                : T
  -20 ::::::::::::::::::::::::::::::::::::::::::::
  -16                       Y
  -12      Y         V
   -8          c        A                   !
   -4           KL       c               K==1===
    0              P F             MMMMMMMM    =Y
    4               !     R        | + + +M  u =
    8         p                    M + + +M  + =
   12       Y                 Y    MMMMMMMM 2  =
   16             Y                    2      u=
   20                                ...
   24                               ..
   28                              ..
   32                            ...
   36                          ..T
   40                         ..K
   44                       ...
   48                     ...
   52                    ..
   56 ########           .   #####################
   60 ########               #####################
   64 ########               #####################
   68 ########               #####################
   72 ########               #####################
   76 ########    A          #####################
   80 ########     b         #####################
   84 ########          A    #####################
   88 ########       fS      #####################
   92 ########    3      b   #####################
   96 ########     3         #####################
  100 ########  b    x   O   #####################
  104 ########            j  #####################
  108 ########               #####################
  112 ####              3    #####################
  116 #### S         !       #####################
  120 ########               #####################
  124 ########               #####################
  128 ########       .       #####################
  132 ######### 4    ..      #####################
  136 ##########      O   4   ####################
  140 ##########       .       ###################
  144 ###########  O   ..        #################
  148 ###########       ..        ################
  152                    ..
  156                     ..
  160                      .
  164 :::::::::::::::::::::.+:::::::::::::::::::::
  168                        X
```

O platô (z −40 a 20) é aberto, mas a borda é bloqueada por caatinga fechada (`galhada-seca`
densa + `neblina`) a uns 25 m do acampamento e do cemitério. Do z 152 ao 168 é a rampa de
saída; fora da trilha, `pedra` e `xique-xique` fecham.

### Zonas e posições

**Z1 — Acampamento da volante na Encruzilhada** (x −25..20, z −25..20, y 0)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Fogueira do acampamento | `fogueira` | (0, 0) | luz 8 m; vai morrendo em 3 min (luz cai para 4 m); checkpoint |
| Lata de Lampião / início | `lata-querosene` + P | (−3, 3) | o jogador começa no chão, de lado, aqui; a lata enche o lampião até 70% |
| Lampião apagado | `lampiao` (pickup) | (−7, −1) | tutorial de luz |
| Barraca do tenente | `barraca-lona` | (−9, −4) | abertura para leste; dentro: `bilhete` ×2 em `caixote` (−10, −3), `garrafa-querosene` (−10, −4) |
| Barraca dos soldados | `barraca-lona` | (7, −6) | vazia, cobertor, marmita |
| Caixotes | `caixote` | (−12, −7), (−11, −9), (9, −1) | cobertura |
| Caminhão (sai no início) | `caminhao` | (0, −10) → foge para (0, −40) | some ao chegar a z −40; depois o acesso norte fica bloqueado por `pedra` em (0, −35) |
| Sentinela morta + pistola | `p` | (−13, 9) | parabélum + 2 pentes |
| Carroça tombada (Benedito) | `carroca` | (11, 7) | escolha moral do beat 5 |
| Encruzilhada | `estrada` | eixo z −18 (x −40..58) e eixo x 0 (z −40..−18) | estradas de terra de 4 m |
| A baraúna | `arvore-seca` | (5, −21) | a árvore que dá nome ao lugar; silhueta |
| Mandacarus | `mandacaru` | (−20, −12), (−18, 12), (15, −14), (18, 15), (−6, 17) | |
| Pedras de borda | `pedra` | (−22, 0), (20, 2) | |
| Gatilho cena da lata / !1 | `gatilho` | raio 3 em (−3, 3) | cena de abertura |
| Gatilho Benedito | `gatilho` | raio 4 em (11, 7) | |

**Z2 — Cemiteriozinho e os enjeitados** (x 25..55, z −10..25, y 0)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Muro do cemiteriozinho | `muro-pedra` | retângulo x 28..42 × z 0..12 | altura 1,2 m |
| Portão (aberto) | `portao-cemiterio` | (28, 6) | lado oeste |
| Cruzes de dentro | `cruz` | grade x 32/36/40 × z 4/8 (6 cruzes) | chão bento simples: corpo-seco não entra |
| Cerca dos enjeitados | `cerca-varas` | (42, −4) → (52, −4) e (52, −4) → (52, 16) | o canto onde fica o !2 |
| Gatilho !2 | `gatilho` | caixa x 44..48, z −6..−2 | braço seco atravessa a cerca |
| Cova E1 (roteirizada) | `cova-rasa` + `spawner` | (46, −1) | 1 corpo-seco; tutorial de Raízes e Boca |
| Covas E2 | `cova-rasa` + `spawner` | (46, 13) e (36, 16) | 1 corpo-seco cada, em sequência (a 2ª acorda com tiro ou após 40 s) |
| Covas de cenário | `cova-rasa` | (49, 6), (50, 18) | sem spawner |
| Cruz "AQUI A TERRA NÃO QUIS" | `cruz-torta` | (49, 9) | `bilhete` (inscrição) |
| Querosene | `garrafa-querosene` | (40, −3) | do lado de fora do muro |
| Mandacaru / xique-xique | `mandacaru`, `xique-xique` | (54, 0); (44, 20) | |

**Z3 — Trilha do paredão** (rampa de (36, 20) a (8, 56); y 0 → −12)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Trilha de descida | `cascalho` | (36, 20) → (28, 32) → (18, 44) → (8, 56) | 3 m de largura; y 0 → −3 → −7 → −12 |
| Paredes da trilha | `paredao`, `pedra` | dos dois lados | trilha estreita, sem saída lateral |
| Árvore seca | `arvore-seca` | (24, 38) | marco no meio da descida |
| Querosene | `garrafa-querosene` | (22, 40) | |

**Z4 — Grota da Baraúna** (fundo x −14..14, z 56..130, y −12)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Paredões | `paredao` | x = −15 e x = +15, z 56..130 | 10–14 m de altura; no prólogo, soldados na borda (y +2), x ±16, z 78..110 |
| Metralhadora (prólogo) | cenário | (16, 95) borda leste | só som e clarão |
| Barraca rasgada A | `barraca-lona` | (−6, 78) | com `esteira` (−6, 80): onde Lampião acorda no prólogo |
| Barraca rasgada B | `barraca-lona` | (6, 84) | |
| Fogueira do bando | `fogueira-apagada` | (0, 88) | fumaça no prólogo |
| Corpo de Cansanção | `corpo-bando` | (−4, 80) | boca da barraca A; urubus |
| Corpo de Sabiá + folheto | `corpo-bando` + `folheto` | (3, 90) | folheto no bornal |
| Corpo de Gavião | `corpo-bando` | (8, 94) | |
| Corpo de Fumaça | `corpo-bando` | (−3, 97) | **!3**: urubus + corpo-seco comendo (E3a) |
| Corpo de Pé-de-Serra | `corpo-bando` + `bilhete` | (−9, 102) | bilhete para a mãe |
| Corpo de Jurema | `corpo-bando` (pequeno) | (10, 106) | atrás da pedra |
| Pedra grande | `pedra` | (9, 102) | "Fica atrás da pedra, menino!" |
| Onde Lampião caiu | marco (lama escura) | (1, 100) | ponto roteirizado do tiro no prólogo |
| Urubus | `urubu` ×6 | sobre (−3, 97) e (−4, 80) | revoada no !3 |
| Corpos-secos E3b, E3c | patrulha | entre (−6, 92) e (6, 112) | |
| Jurema / !4 | `gatilho` + alma | aparece em (0, 118) | anda para o sul e para na loca |
| Loca do segredo S2 | `loca` + `lata-querosene` | entrada (−14, 116), fundo (−20, 118) | só agachado; Jurema assovia na entrada |

**Z5 — Saída sul e a cruz** (z 130..170; y −12 → 0)

| Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|
| Trilha de subida | `cascalho` | (0, 130) → (6, 145) → (12, 158) → (14, 165) | y −12 → −6 → −1 → 0 |
| Cova spawner E4a | `cova-aberta` + `spawner` | (−9, 134) | |
| Cova spawner E4b | `cova-aberta` + `spawner` | (11, 139) | 5 corpos-secos no total entre as duas, máx. 3 vivos |
| Pedras de cobertura | `pedra` | (3, 138), (−4, 146) | |
| Estrada | estrada | eixo z 165, x −30..58 | |
| Cruz de beira de estrada | `cruz-beira-estrada` + `ex-voto` (cabecinhas) | (15, 166) | `bilhete` do ex-voto; **X** fim do capítulo, gatilho raio 3 |
| Candeeiro de Dorinha | cena | entra pela estrada em (35, 166) indo para oeste | só na cena final |

### Encontros e spawners

| # | Zona | Spawner / posição | Criaturas | Regras |
|---|---|---|---|---|
| E1 | Z2 | cova (46, −1) | 1 corpo-seco | roteirizado no !2; não avança enquanto o tutorial não aparece |
| E2 | Z2 | covas (46, 13), (36, 16) | 2 corpos-secos | o 2º acorda com tiro ou 40 s depois do 1º |
| E3 | Z4 | (−3, 97) + patrulha (−6, 92)↔(6, 112) | 3 corpos-secos | um comendo (parado até a luz chegar), dois patrulhando |
| E4 | Z5 | covas (−9, 134), (11, 139) | 5 corpos-secos, máx. 3 vivos | intervalo de 6 s; para quando o jogador passa de z 155 |

### Itens

| Item | Posição | |
|---|---|---|
| `lata-querosene` (a da cabeça) | (−3, 3) | enche até 70% |
| `garrafa-querosene` | (−10, −4), (40, −3), (22, 40) | +25% cada |
| `lata-querosene` (segredo S2) | (−20, 118) | +50% |
| pistola + 2 pentes | (−13, 9) | |
| `folheto` | (3, 90) | "A Peleja do Capitão com a Volante de Mata Grande" |
| `bilhete` | (−10, −3) ×2, (49, 9), (−9, 102), (15, 166) | relação das cabeças, telegrama, cruz dos enjeitados, Pé-de-Serra, ex-voto |

### Ritmo de luz e escuridão

| Trecho | Luz | Sensação |
|---|---|---|
| Z1 | fogueira (morrendo) + lampião | caos, depois quietude; última luz "de gente" |
| Z2 | só o lampião; muro branco reflete um pouco | primeiro silêncio (os grilos param) |
| Z3 | só o lampião; trilha estreita | descida, aperto |
| Z4 | escuro total fora do lampião; neblina no chão | luto; o momento mais escuro do capítulo |
| Z5 | o céu clareia aos poucos (azul-escuro → cinza) | pressa; a luz do dia é ao mesmo tempo salvação e queda |

### Peças usadas no cap. 1

`terreno`, `mandacaru`, `arvore-seca`, `pedra`, `paredao`, `loca`, `cascalho`, `xique-xique`,
`galhada-seca`, `neblina`, `muro-pedra`, `portao-cemiterio`, `cruz`, `cruz-torta`,
`cruz-beira-estrada`, `ex-voto`, `cerca-varas`, `cova-rasa`, `cova-aberta`, `barraca-lona`,
`carroca`, `caixote`, `mobilia-sertao` (esteira), `corpo-bando`, `urubu`, `fogueira`,
`fogueira-apagada`, `lampiao`, `lata-querosene`, `garrafa-querosene`, `folheto`, `bilhete`,
`caminhao`, `spawner`, `gatilho`.

**Faltam para o cap. 1** (além das 9 existentes): `paredao`, `loca`, `cascalho`, `xique-xique`,
`galhada-seca`, `neblina`, `muro-pedra`, `cruz-torta`, `cruz-beira-estrada`, `ex-voto`,
`cova-rasa`, `cova-aberta`, `barraca-lona`, `carroca`, `caixote`, `esteira`, `corpo-bando`,
`urubu`, `fogueira`, `fogueira-apagada`, `lata-querosene`, `garrafa-querosene`, `folheto`,
`bilhete`, `gatilho`. O `caminhao` reaproveita o `jeep.tscn`, e o `spawner` usa o
`spawner.tscn`.

---

<!-- CAPS-2-9 -->
