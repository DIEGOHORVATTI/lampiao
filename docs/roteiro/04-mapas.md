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
| `cocho` | 🆕 | cocho de madeira para gado | sítios, fazenda |
| `jumento` | 🆕 | jumento com cangalha (cenário animado) | caps. 2, 4 |
| `cabra-comum` | 🆕 | cabra do rebanho (animal que anda em grupo) | cap. 5 |

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

## Cap. 2 — `cap02-o-crucifixo` — Sítio Olho-d'Água

### Resumo

| | |
|---|---|
| **Tipo** | sítio de taipa com quintal cercado, roça morta, trilha de serra e um brejo de altitude |
| **Tamanho** | caixa 80 × 136 m; jogável ≈ 6.500 m² |
| **Origem (0, 0)** | porta da frente da casa de Dorinha (a casa abre para o sul) |
| **Alturas** | sítio y = 0; a trilha sobe até o brejo, y = +15 |
| **Rota** | Z1 Casa → Z2 Quintal → Z3 Roça → Z4 Trilha da serra → Z5 Brejo → volta Z3 → Z2 (defesa) → Z1 (reza) |

### ASCII

```
     x: -40 .. 40
 -112 #########################################
 -108 ####
```

No brejo, `#` é `mata-brejo` (parede vegetal densa) e `%` é o `cipo-trancado` que bloqueia o
caminho até a oferenda.

### Zonas e posições

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Casa de Dorinha | `casa-taipa-grande` | x −6..6, z −8..0 | porta (0, 0) |
| Z1 | Quarto de reza (chão bento) | `oratorio`, `vela` ×6, `mobilia-sertao` (esteira, tamborete) | oeste da casa, x −6..−2 | início P (−4, −6); janela oeste (−7, −4) = **!3** |
| Z1 | Sala | `ex-voto`, `bilhete`, `folheto` | x −2..6 | folheto S (4, −4); `candeeiro-parede` |
| Z2 | Depósito | `casa-taipa` | x 10..16, z −8..−2 | `garrafa-querosene` K (13, −4) |
| Z2 | Latada + jumento | `latada`, `jumento` | (8, 6) | **!1** em (9, 8) |
| Z2 | Poço, pilão, canteiro de arruda | `poco`, `mobilia-sertao` (pilão) | (−10, 8), (−6, 10), (−12, 4) | |
| Z2 | Cerca do quintal | `cerca-varas` | retângulo x −18..20, z −12..16 | `porteira` (0, −12) para a roça e (0, 16) para a estrada |
| Z3 | Roça morta | `milho-seco` | x −20..20, z −40..−14 | `espantalho` x (5, −28); cruz de roça (`cruz-torta`) (−12, −38) |
| Z4 | Trilha da serra | `cascalho`, `lajedo`, `paredao` | (0, −40) → (−10, −60) → (5, −78) → (0, −84) | sobe de y 0 a +15 |
| Z5 | Toco da oferenda | `toco` | (0, −84) | |
| Z5 | Cipós trançados | `cipo-trancado` | x −8..8, z −88 | somem com a oferenda |
| Z5 | Olho-d'água | `olho-dagua` | (0, −100) | |
| Z5 | Gameleira | `gameleira` | (−15, −95) | |
| Z5 | Ponto silencioso | `gatilho` | (−5, −96) | **!2** |
| Z5 | Vassourinha (3) | coleta | (−20, −92), (12, −104), (22, −90) | `v` |
| Z5 | Pinhão-roxo (2) | coleta | (−8, −108), (18, −98) | `r` |

### Encontros, itens e segredos

| # | Spawner / posição | Criaturas | Regras |
|---|---|---|---|
| E1 | (−8, −24), (10, −32) | 2 corpos-secos | entre o milho; patrulha curta |
| E2 | (6, −102), (−12, −100); extras `u` (20, −108), (−22, −104) | 2 (+2 sem oferenda) | |
| E3 | `spawner` em `galhada-seca` na roça: (0, −30), (−15, −20) | 6 no total, máx. 3 | vão para a porta (0, 0); não entram no quarto de reza |
| Fulozinha | emissor de som | gira a 15–30 m do jogador em Z4–Z5 | ver bestiário |

Itens: `garrafa-querosene` (13, −4) e (10, −70) na trilha; `lata-querosene` na loca atrás da
gameleira (−18, −97) (segredo, Fulozinha assovia em cima dela se houve oferenda); 2 `garrafada`
na cena final; `folheto` (4, −4).

### Ritmo de luz

Z1 velas e candeeiro (quente) → Z2 só o lampião e o candeeiro na janela da casa como farol → Z3
escuro, milho alto → Z4 subida a céu aberto, estrelas → Z5 brejo escuro e úmido, a neblina
branca reflete o lampião e fecha a visão em 5 m → volta: a janela de Dorinha acesa é o objetivo.

### Peças do cap. 2

`terreno`, `casa-taipa-grande`, `casa-taipa`, `porta-taipa`, `janela-madeira`, `oratorio`, `vela`,
`candeeiro-parede`, `ex-voto`, `mobilia-sertao`, `latada`, `jumento`, `poco`, `cerca-varas`,
`porteira`, `milho-seco`, `espantalho`, `cruz-torta`, `galhada-seca`, `cascalho`, `lajedo`,
`paredao`, `mata-brejo`, `gameleira`, `olho-dagua`, `toco`, `cipo-trancado`, `loca`, `neblina`,
`mandacaru`, `garrafa-querosene`, `lata-querosene`, `garrafada`, `folheto`, `bilhete`,
`spawner`, `gatilho`.

---

## Cap. 3 — `cap03-o-coiteiro` — Sítio Lagoa Rachada

### Resumo

| | |
|---|---|
| **Tipo** | sítio à beira de um açude seco: travessia aberta e perigosa no meio, construções nas bordas |
| **Tamanho** | caixa 132 × 112 m; jogável ≈ 9.000 m² (o açude é a maior parte) |
| **Origem (0, 0)** | centro do açude seco |
| **Alturas** | fundo do açude y = −3 (borda em rampa suave); sítio y = 0; lajedo do coito y = +2 |
| **Rota** | Z1 estrada e cruz → Z2 anjinhos → (Z5 periferia, patrulha) → Z3 açude → Z4 coito → Z5 casa e casa de farinha → saída pela estrada norte |

### ASCII

```
     x: -70 .. 62
  -60                                                                 X
  -56                                                                 :
  -52                                                                 :
  -48                                                                 :
  -44                          ########
```

`~` = `acude-seco`, com placas de `lama-mole` espalhadas. `o` = pontos da rota do Batatão (ele
circula em volta do centro do açude, raio ~20 × 12 m).

### Zonas e posições

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Estrada sul | estrada | eixo z 45, x −70..62 | início P (−68, 45) |
| Z1 | Cruz com ex-voto de Tonho | `cruz-beira-estrada`, `ex-voto`, `bilhete` | (−50, 42) | |
| Z2 | Cemitério dos anjinhos | `cerca-varas`, `cruzinha` ×12 | x −45..−35, z 21..29 | **!1** em (−40, 25) |
| Z3 | Açude seco | `acude-seco`, `lama-mole` | elipse 35 × 22 em (0, 0) | |
| Z3 | Canoa encalhada | `canoa-encalhada` | (5, 3) | cobertura |
| Z3 | Carcaça de boi | `carcaca-boi` | (−12, −6) | marco do meio |
| Z3 | Batatão | rota | (−20, −10), (20, −12), (25, 8), (−25, 10) | **!2** começa em (0, −2) |
| Z3 | Gatilho do Faro | `gatilho` | (−20, −5) | **!3**: corpo-seco parado ao lado |
| Z4 | Lajedo e loca do coito | `lajedo`, `loca`, `galhada-seca` | lajedo x −20..0, z −44..−30; loca (−12, −36) | mosquetão p (−10, −36), `lata-querosene` K (−11, −34), folheto S (−12, −36), Jurema j (−4, −32) |
| Z5 | Casa grande de Liberato | `casa-taipa-grande`, `porta-taipa` | x 34..46, z 14..24; porta (34, 19) | **!4** na porta; candeeiro na janela |
| Z5 | Casa de farinha | `casa-farinha` (`forno-barro` aceso) | x 44..52, z 32..40 | Liberato |
| Z5 | Curral | `curral`, `porteira` | x 19..31, z 33..43; porteira (25, 43) | |
| Z5 | Acampamento da volante | `barraca-lona`, `fogueira` | barraca (16, 32), fogueira (20, 28) | checkpoint; `bilhete` (ordem) |
| Saída | Estrada norte | estrada | eixo x 58, z 45 → −60 | X (58, −58) |

### Encontros

| # | Posição | Inimigos | Regras |
|---|---|---|---|
| E1 | patrulha entre (10, 44) e (22, 46) | 2 soldados | dupla com lanterna; tiro chama E3 |
| E2 | (−8, 5), (10, −8), (15, 10) | 3 corpos-secos | no açude, no escuro |
| E3 | (22, 30), (28, 26) | 2 soldados | em volta da fogueira |
| E4 | estrada (50, 46), (56, 40) + 2 corpos-secos vindos do açude | 2 soldados de reforço | fuga para o norte |

Itens: `garrafa-querosene` (−38, 30) e (30, 15); `cartucheira` no coito e na barraca (16, 32);
`folheto` no coito.

### Ritmo de luz

Z1–Z2 lampião sob céu aberto; Z5 periferia com a fogueira dos soldados ao longe (perigo visível)
→ Z3 açude: o lugar mais aberto e mais escuro, e o Batatão apaga a luz → escuridão total com
Faro → Z4 reacende no coito (alívio) → Z5 a casa de farinha tem a brasa do forno (luz vermelha
baixa) → fuga sob lanternas.

### Peças do cap. 3

`terreno`, `acude-seco`, `lama-mole`, `canoa-encalhada`, `carcaca-boi`, `cruz-beira-estrada`,
`ex-voto`, `cruzinha`, `cerca-varas`, `curral`, `porteira`, `casa-taipa-grande`, `porta-taipa`,
`janela-madeira`, `casa-farinha`, `forno-barro`, `barraca-lona`, `fogueira`, `lajedo`, `loca`,
`galhada-seca`, `mandacaru`, `pedra`, `neblina`, `lata-querosene`, `garrafa-querosene`,
`cartucheira`, `folheto`, `bilhete`, `gatilho`.

---

## Cap. 4 — `cap04-a-feira-das-cabecas` — Santa Luzia do Ermo

### Resumo

| | |
|---|---|
| **Tipo** | vila pequena: ruas estreitas, largo da feira, adro com igreja; muita parede e pouco espaço aberto (furtividade) |
| **Tamanho** | caixa 130 × 112 m; jogável ≈ 8.000 m² (ruas e largos) |
| **Origem (0, 0)** | base do cruzeiro do adro |
| **Alturas** | tudo y = 0; escadaria da igreja sobe até y = +3 (11 degraus); porão da botica y = −2,5 |
| **Rota** | Z1 beco SO → Z2 largo da feira (Zé Mirim) → Z3 Rua do Meio (mendigo, Inácia) → [escolha] Z4 botica e porão → Z5 adro e escadaria → Z6 becos e saída NE |
| **Mesmo mapa** | o cap. 6 usa esta vila com o cemitério aberto a leste da igreja |

### ASCII

```
     x: -60 .. 70
  -50 
  -46                                                            X
  -42                          CCCCCCCCCCC                      .
  -38                          C        !C                    ..
  -34                          C         C                   4
  -30                 GGGGGGG  C         C                  .
  -26                 G     G  C         C                ..
  -22                 G     G  C         C               ..
  -18                 GGGGGGG  C         C            4..
  -14    GGGGG                 CC=======CC           ..
  -10    G   G                   =F=3!F=         GG..GGGGGGGGGGG
   -6    GGGGG              B    3     3         G   GG x GG   G
   -2                GGGGGGR        +            GGGGGGKGGGGGGGG  ::::::
    2                G     G
    6    GGGGG       G     G                   x
   10    G   G       G     G                              GGGGGGG
   14    GGGGG       GGGGGGG                              G  !  G
   18                                                     G     G
   22                      A    A     A    A    GGGGG GGGGGGGGGGG
   26         GGGGGGGGGGG****                   G   G G   G
   30         G   GG    zS*A*   A     A    A    GGGGG GGGGG
   34         GGGGGGGGGGG****
   38 
   42       GGGGG .                         GGGGG     GGGGG
   46       G  1..                          G   G     G   G
   50       1..GG                           GGGGG     GGGGG
   54    ...
   58  P.
   62 
```

### Zonas e posições

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Beco de trás da bodega | trilha entre `casa-caiada` | (−58, 58) → (−35, 42) | P (−58, 58); portas com cruz de cal |
| Z2 | Largo da feira | `barraca-feira` ×8 | x −18..14, z 20..32 | |
| Z2 | Bodega + latada | `bodega`, `latada` | x −34..−22, z 26..34; latada até x −16 | Zé Mirim z (−24, 30); folheto S (−22, 30); `oferenda-janela` (caps. 6+) |
| Z3 | Rua do Meio | `casa-caiada` ×3 | (30, −5), (40, −5), (50, −5) | casa de Inácia (40, −5): `janela-madeira` com `oferenda-janela` (38, −1) |
| Z3 | Mendigo | NPC | (22, 4) | |
| Z3 | Quintal de Inácia | `porta-taipa` | fundos (40, −12) para o beco do cemitério | atalho do beat 9 se `biu=salvo` |
| Z4 | Botica | `botica`, `estante-vidros` | x 44..56, z 10..20 | alçapão (52, 18) para o `porao` 10 × 8 m (y −2,5); **!1** no último degrau |
| Z5 | Adro e cruzeiro | `cruzeiro` | (0, 0) | |
| Z5 | Igreja matriz | `igreja` | x −10..10, z −40..−14; escadaria z −14..−8; torre (8, −38) | **!3** sino |
| Z5 | Tábua das cabeças | `tabua-cabecas` | (0, −11) | **!2**; `candeeiro-parede` em postes (−5, −12), (5, −12), (−5, −9), (5, −9) |
| Z5 | Casa paroquial | `casa-caiada` | x −28..−16, z −30..−18 | |
| Z5 | Quartel da volante | `casa-caiada` | x −30..−18, z 0..12 | `bilhete` (sargento); reforço sai daqui |
| Z5 | Carroça e barril | `carroca`, `barril-polvora` | (−18, −4), (−16, −6) | |
| Z6 | Beco de fuga | trilha | (30, −10) → (45, −25) → (58, −45) | X (58, −46): Damião e o jumento |

### Encontros

| # | Posição | Inimigos | Regras |
|---|---|---|---|
| E1 | (−48, 50), (−42, 46) | 2 corpos-secos | um comendo gato |
| E2 | porão da botica | Papa-figo | apaga as 3 `vela` do porão; jarro de álcool (`barril-polvora` pequeno re-skin) |
| E3 | escadaria (0, −11), (−6, −6), (6, −6) + 2 em ronda | sargento + 4 soldados (ou 2) | candeeiros podem ser apagados a tiro |
| E4 | (35, −18), (50, −35) + 2 corpos-secos | 3 soldados | sino tocando; lanternas nos becos |

Itens: `garrafa-querosene` na bodega e no quartel; `cartucheira` no quartel; lampião reserva
pendurado na escada do porão; `oferenda-janela` de Inácia (se `biu=salvo`).

### Ritmo de luz

Vila escura com frestas de luz nas portas (o povo está acordado) → Z2 lampião de Zé Mirim, o
único acolhimento → Z4 porão: escuro total e fogo (o jarro de álcool) → Z5 o adro é o lugar
mais iluminado do jogo até aqui (quatro candeeiros sobre as cabeças) e por isso o mais
perigoso → Z6 lanternas da volante cortando os becos.

### Peças do cap. 4

`terreno`, `casa-caiada`, `porta-taipa`, `janela-madeira`, `oferenda-janela`, `bodega`, `latada`,
`barraca-feira`, `botica`, `estante-vidros`, `porao`, `vela`, `igreja`, `cruzeiro`, `casa-caiada`
(paroquial, quartel), `tabua-cabecas`, `candeeiro-parede`, `carroca`, `barril-polvora`,
`caixote`, `jumento`, `neblina`, `garrafa-querosene`, `cartucheira`, `lampiao`, `folheto`,
`bilhete`, `spawner`, `gatilho`.

---

## Cap. 5 e Cap. 7 — `cap05-a-cabra` e `cap07-sexta-feira` — Sítio Pau-Ferro

Os dois capítulos usam o mesmo mapa. No cap. 7 a parede do quarto já foi remendada com varas
(a mesma peça `parede-taipa-quebravel`, agora intacta) e há três montes de lenha.

### Resumo

| | |
|---|---|
| **Tipo** | sítio: casa de taipa com terreiro, curral e espojadouro, cemiteriozinho da família, encruzilhada e a casa do vizinho |
| **Tamanho** | caixa 130 × 76 m; jogável ≈ 7.000 m² |
| **Origem (0, 0)** | porta da frente da casa de Damião (abre para o sul) |
| **Alturas** | tudo y = 0 |
| **Rota cap. 5** | Z1 casa (ceia) → Z2 terreiro (vê a cabra em Z4) → Z1 porta (escolha) → defesa Z1/Z2 → Z3 curral |
| **Rota cap. 7** | Z2 latada → Z3 espojadouro → Z4 encruzilhada → Z5 cemiteriozinho → Z3 curral → Z1/Z2 casa → Z3 espojadouro |

### ASCII

```
     x: -60 .. 70
  -40                                              .
  -36                         =============        .
  -32                    e    = R         =====    .              Y
  -28                  eeeee  =           ==  =    .
  -24                    e    =           =====    .
  -20                        F=           =        .      Y
  -16                         ======|======        .
  -12                                              .
   -8                           HHHPHHHHH          .
   -4                           %       H          .
    0      Y                    HHHH|HHHH          .
    4                                              .
    8           =++++=         O       T           .         HHHHHH
   12           =++++=              F              .         H    H
   16           ======                             .         H    H
   20                                              F         HHHHHH
   24 :::::::::::::::::::::::::::::::::::::::::::::x::::::::::::::::::::
   28                                              .
   32                                              .
   36                                              .
```

### Zonas e posições

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Casa de Damião | `casa-taipa-grande` | x −8..8, z −10..0; porta (0, 0) | sala (centro), cozinha (leste, `janela-madeira` em (8, −5)), quarto (oeste) |
| Z1 | Parede do quarto | `parede-taipa-quebravel` | (−8, −5) | cap. 5: cede na 3ª investida |
| Z1 | Cama das crianças, talha, oratório | `mobilia-sertao`, `oratorio`, `ex-voto` (cachorrinho) | quarto e sala | P (−2, −6); desenho a carvão na parede do quarto |
| Z2 | Terreiro e latada | `latada` (esteio) | (6, 6) | cap. 7: Damião amarrado aqui |
| Z2 | Poço | `poco` | (−10, 8) | cobertura |
| Z2 | Fogueira do terreiro | `fogueira` (cap. 7: monte de lenha) | (0, 12) | checkpoint |
| Z3 | Curral | `curral`, `porteira` | x −12..12, z −36..−16; porteira (0, −16) | 12 `cabra-comum`; carroça R (−8, −30); corrente no mourão |
| Z3 | Chiqueiro | `chiqueiro` | x 14..20, z −30..−22 | |
| Z3 | Espojadouro | `espojadouro` | (−22, −28), raio 5 | `bilhete` riscado no chão; fim da luta do cap. 7 |
| Z3 | Fogueira do curral | `fogueira` | (−14, −20) | |
| Z4 | Estrada | estrada | eixo z 25, x −60..70 | |
| Z4 | Encruzilhada | estrada + trilha N-S x 30 | (30, 25) | `cruz-beira-estrada`; fogueira (30, 20) |
| Z4 | Casa de Seu Quincas | `casa-taipa` (com telhado onde a cabra sobe) | x 50..60, z 10..20 | !1 do cap. 5 |
| Z5 | Cemiteriozinho do Pau-Ferro | `cerca-varas`, `cruz` ×6 | x −40..−30, z 6..16 | cova de Lia (−34, 10); folheto do cap. 7 no oco de uma cruz |

### Encontros

| Cap | # | Posição | Inimigos | Regras |
|---|---|---|---|---|
| 5 | E1 | telhado da casa (0, −5) | cabra, investida 1 | |
| 5 | E2 | `spawner` em `galhada-seca` (20, 10) e (−20, 14) | 2 corpos-secos | entre investidas |
| 5 | E3 | janela (8, −5), parede (−8, −5) | cabra, investidas 2 e 3 | |
| 5 | E4 | curral | cabra no rebanho de 12 | |
| 7 | E1 | encruzilhada (30, 25) | 3 corpos-secos | comida antes do chefe |
| 7 | E2–E4 | circuito espojadouro → (30, 25) → (−34, 10) → curral | Lobisomem | fogueiras (0, 12), (−14, −20), (30, 20): raio de 6 m seguro |

Itens: `garrafa-querosene` no depósito da cozinha e na encruzilhada; `cartucheira` (cap. 5,
oferenda de Quincas) na soleira; `garrafada` no oratório.

### Ritmo de luz

Cap. 5: casa acesa (candeeiro na mesa) = abrigo → terreiro escuro com a casa do vizinho acesa ao
longe → a luz da casa vira alvo (fogo da cabra) → curral escuro, olhos refletindo.
Cap. 7: três fogueiras como ilhas de luz num sítio escuro; o uivo apaga uma. A janela de Rosinha
é a luz que o jogador tem que defender.

### Peças dos caps. 5 e 7

`terreno`, `casa-taipa-grande`, `parede-taipa-quebravel`, `porta-taipa`, `janela-madeira`,
`mobilia-sertao`, `oratorio`, `ex-voto`, `latada`, `poco`, `curral`, `porteira`, `chiqueiro`,
`carroca`, `cabra-comum`, `espojadouro`, `cerca-varas`, `cruz`, `cruz-beira-estrada`,
`casa-taipa`, `galhada-seca`, `mandacaru`, `fogueira`, `candeeiro-parede`, `neblina`,
`garrafa-querosene`, `cartucheira`, `garrafada`, `folheto`, `bilhete`, `spawner`, `gatilho`.

---

## Cap. 6 — `cap06-a-mula` — Igreja e cemitério de Santa Luzia

### Resumo

| | |
|---|---|
| **Tipo** | a mesma vila do cap. 4, agora com o cemitério aberto; o circuito da Mula contorna a igreja |
| **Tamanho** | jogável ≈ 6.000 m² (só o lado leste da vila e o adro; o resto fica trancado) |
| **Origem (0, 0)** | base do cruzeiro do adro (igual ao cap. 4) |
| **Rota** | Z1 estrada leste → Z5 rua da igreja → Z2 portão do cemitério (padre) → cova → Z3 adro (luz fixa) → circuito → (opcional) Z4 sacristia → Z2 enterro |

### ASCII

```
     x: -60 .. 70
  -50 
  -46                                      MMMMMMMMMMMMMMMMMMM   .
  -42                          CCCCCCCCCCC M  +  +  +  +  !T M  .
  -38                          C        !C M                 M..
  -34                          C         CsM! +  +  + G+  +  M
  -30                 GGGGGGG  C         C M                .M
  -26                 G     G  C         C o  +  + o+  +  +. o
  -22                 G     G  C         C M  +  +  +  + .+  M
  -18                 GGGGGGB  C         C M  + G+  +  +. +  M
  -14    GGGGG                 CC=======CC M         ..      M
  -10    G   G                   =======   MMMMMMMMMMMMMMMMMMMGG   o
   -6    GGGGG                                   G   GG   GG   G
   -2                GGGGGGG        +            GGGGGGGGGGGGGGG  ::::P:
    2                G     G                                          X
    6    GGGGG       G     G        o
   10    G   G       G     G                              GGGGGGG
   14    GGGGG       GGGGGGG                              G     G
   18                                                     G     G
   22                      A   1A   o A  1 A    GGGGG GGoGGGGGGGG
   26         GGGGGGGGGGG****       1           G   G G   G
   30         G   GG     **A*   A     A    A    GGGGG GGGGG
   34         GGGGGGGGGGG****
   38 
   42       GGGGG .                         GGGGG     GGGGG
   46       G  ...                          G   G     G   G
   50       ...GG                           GGGGG     GGGGG
   54    ...
   58  ..
   62 
```

`o` = pontos do circuito da Mula, nesta ordem: (0, 20) → (0, 5) → em volta do cruzeiro → (14,
−26) portão → (30, −26) → (50, −26) portão dos fundos → (62, −10) → (40, 22) → (0, 20).

### Zonas e posições

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Estrada leste | estrada | (70, 0) → (40, 0) | P (68, 0); casa de Quincas na beira, fora do recorte |
| Z2 | Cemitério | `muro-caiado` | x 14..50, z −45..−10 | `portao-cemiterio` oeste (14, −26) e fundos (50, −26) |
| Z2 | Cruzes | `cruz` ×20 | grade x 20..44, z −40..−16 | chão bento em toda a área do muro |
| Z2 | Túmulos de alvenaria | `cova-rasa` (variação alvenaria) | Valadares (30, −28); outros (24, −20), (36, −34) | servem para atordoar a Mula |
| Z2 | Lugar da cova | `cova-aberta` (3 estágios) | (44, −40) | juazeiro T (46, −42); pá encostada no muro (48, −44); **!1** na 1ª etapa |
| Z3 | Adro | `cruzeiro`, `fogueira` (luz fixa do adro) | (0, 0); fogueira (0, 6) | checkpoint; o cruzeiro atordoa a Mula |
| Z3 | Barril da volante | `barril-polvora` | (−16, −18) | ao lado da casa paroquial |
| Z4 | Sacristia | interior da `igreja` | s (12, −32), porta lateral | `bilhete` ×3; batina **!4** |
| Z4 | Torre | `igreja` | (8, −38) | **!2** corda do sino |
| Z5 | Rua da igreja | `casa-caiada` | z 20..30 | `oferenda-janela` na bodega (Graça) |
| — | Tutorial de esconder | `gatilho` | (20, −30) | **!3** |

### Encontros

| # | Posição | Inimigos | Regras |
|---|---|---|---|
| E1 | (10, 20), (−10, 22), (0, 26) | 3 corpos-secos | antes do portão |
| E2 | circuito `o` | Mula-sem-cabeça | volta a cada ~50 s; muda para ir direto à cova após a 2ª etapa |
| E3 | fora do muro (52, −40), (10, −44) | 2 corpos-secos | só se fome > 50 na 3ª etapa |

### Ritmo de luz

Vila escura → o portão do cemitério com a vela do padre → dentro do muro o branco da cal reflete
o lampião (enxerga-se mais, mas a vida cai) → a Mula traz a própria luz (fogo do pescoço),
anunciada pelo sino → o adro com a fogueira é o respiro → no enterro, os candeeiros de Dorinha e
Damião.

### Peças do cap. 6

As do cap. 4, mais: `muro-caiado`, `portao-cemiterio`, `cruz`, `cova-rasa` (alvenaria),
`cova-aberta`, `juazeiro`, `fogueira`, `barril-polvora`, `oratorio` (sacristia),
`mobilia-sertao` (mesa, armário).

---

## Cap. 8 — `cap08-a-caipora` — Tabuleiro das Almas

### Resumo

| | |
|---|---|
| **Tipo** | caatinga fechada com clareiras ligadas por trilhas (labirinto leve), ruína, lajedo e estrada |
| **Tamanho** | caixa 166 × 112 m; jogável ≈ 7.500 m² (o resto é `galhada-seca` impenetrável) |
| **Origem (0, 0)** | a clareira central, com a carcaça de boi (a clareira da "dobra") |
| **Alturas** | caatinga y = 0; barracão numa elevação y = +4; vala y = +2; lajedo y = +1 |
| **Rota** | Z1 entrada e toco → Z2 clareiras (C1 → C2 → C3) → Z3 tapera e cacimba → Z4 barracão e vala → Z5 lajedo (emboscada) → Z6 estrada e caminhão |
| **Direção** | a estrada (x 82) segue para o **norte** (−z); a partir de z −64 a direção vira um corredor de estrada de 8 × 220 m até a porteira da Jatobá, que faz a transição para o cap. 9 |

### ASCII

```
     x: -70 .. 96
  -64 ****************************************************************************:*X*****
  -60 ********************************************  ~~~~~~~~~~~~~~~~~ ************:*******
  -56 ********************************************  ~~~~~~~~!~~~~~~~~ ************:*******
  -52 ********************************************  ~~~~~~~~~~~~~~~~~ ************:*******
  -48 ********************************************  ~~~~~~~~~~~~~~~~~ ************:*4*****
  -44 ******************************************** MMMMMMMMMMMMMMMM   ************:*******
  -40 ******************************************** M    S         M   ************:*******
  -36 ******************************************** MMMMMMMMMMMMMMMM   ************:*******
  -32 ************************   *****************        x.          ************:*4*****
  -28 *********************     g   *********************.**.*********************:*******
  -24 *********************   KH.   ******************...****..*******************:*******
  -20 **********************     .x******************.*********.******************:*******
  -16 *****************************.**************...***********.****3      3 ****:*******
  -12 ******************************.*********   .  *************.*           3  *:*******
   -8 *******************************..** ****..2   **************.               :*******
   -4 *******************************  ..  ...********************     B          :*******
    0 ******************************    .x!    ******************.. ! 3      B   *:*******
    4 *******************************...   ....**************....***        O   **:*V*****
    8 ****************************...**** *****...***  ***...**********O3**3******:*******
   12 ******************** ****...****************..1.....************************:*******
   16 ****************      ...*******************    .   ************************:*******
   20 ***************    ...    *******************      *************************:*******
   24 ****************...  1   ***************************************************:*******
   28 *************...**** *******************************************************:*******
   32 *******  *...***************************************************************:*******
   36 ****    x.  ****************************************************************:*******
   40 **** P  . ! ****************************************************************:*******
   44 *******  *******************************************************************:*******
   48 ****************************************************************************:*******
```

### Zonas e posições

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Entrada | trilha, `cruz-beira-estrada` caída | P (−60, 40) | **!1** em (−50, 38) |
| Z1 | Toco da Caipora | `toco` | (−55, 36) | fumo de volta se `oferenda=sim` |
| Z2 | Clareira C1 | `lajedo`, bichos (preá, mocó) | (−30, 20), r 10 | |
| Z2 | Clareira C2 (dobra) | `carcaca-boi`, `lajedo` | (0, 0), r 10; carcaça (0, 2) | **!2** em (2, 0): as saídas norte e leste levam de volta para cá |
| Z2 | Clareira C3 | bodes soltos | (25, 15), r 9 | |
| Z3 | Tapera | `casa-taipa` (sem teto, `tapera`) | (−20, −25) | fumo, K, garrafada g, `bilhete` na parede |
| Z3 | Toco perto da tapera | `toco` | (−15, −20) | |
| Z3 | Cacimba | `cacimba` | (15, −10) | vara de caititus |
| Z4 | Ruína do barracão | `barracao` (ruína) | x 20..50, z −45..−35 | arco x (35, −34); `bilhete` (placa); livro e folheto S (30, −40) |
| Z4 | Vala | `cova-rasa` em fileira (pedrinhas) | x 22..54, z −60..−48 | **!3** (Faro) |
| Z5 | Lajedo da emboscada | `lajedo`, `pedra` ×6 | centro (65, −5), r 16 | barris B (60, −5), (72, 2); tenente atrás da pedra (74, −12); **!4** (54, −2) |
| Z6 | Estrada e caminhão | estrada, `caminhao` | eixo x 82; caminhão (86, 5) | X (86, −62) |

### Encontros

| # | Posição | Inimigos | Regras |
|---|---|---|---|
| E1 | (−28, 22), (22, 12) | 2 corpos-secos | a única carniça |
| E2 | cacimba (14, −8) | 4–6 caititus | só se passar do limite de caça |
| E3 | (56, −14), (62, 8), (70, −16), (58, 0), (68, 6) + tenente (74, −12) | 5 soldados + tenente | 2 barris; Benedito na pedra alta (80, −20) |
| E4 | estrada (86, −30), (86, −50) e no corredor | 4 corpos-secos | atropelar |

Bichos (lanche, medidor de caça): 4 preás em C1, 3 mocós no lajedo C1, 2 bodes em C3, os
caititus da cacimba.

### Ritmo de luz

Tudo escuro e fechado; a galhada devolve a luz do lampião como parede cinza a 3 m. Clareiras =
um pouco de céu. O barracão é o único lugar sem som de bicho. O lajedo é aberto e limpo, e
por isso tem emboscada. A estrada: faróis do caminhão (opcionais).

### Peças do cap. 8

`terreno`, `galhada-seca`, `macambira`, `xique-xique`, `facheiro`, `mandacaru`, `lajedo`,
`pedra`, `carcaca-boi`, `toco`, `cruz-beira-estrada`, `casa-taipa` (tapera), `cacimba`,
`barracao` (ruína), `cova-rasa` (vala), `barril-polvora`, `caixote`, `caminhao`, `urubu`,
`neblina`, `garrafa-querosene`, `garrafada`, `cartucheira`, `folheto`, `bilhete`, `spawner`,
`gatilho`.

---

## Cap. 9 — `cap09-o-coronel` — Fazenda Jatobá

### Resumo

| | |
|---|---|
| **Tipo** | sede de fazenda cercada: terreiro aberto, casa-grande, barracão, capela com cripta, barragem |
| **Tamanho** | cerca de 160 × 100 m + estrada de chegada + barragem; jogável ≈ 13.000 m², o maior mapa (é o último) |
| **Origem (0, 0)** | centro do terreiro |
| **Alturas** | terreiro y = 0; alpendre y = +1; cripta y = −4; barragem (crista) y = +6; açude y = +4 |
| **Rota** | Z1 porteira (ou Z5 cerca dos fundos com Liberato) → Z2 barracão (Tonho, pólvora) → Z4 barragem → Z2 alpendre (coronel) → Z3 capela e cripta → Z3 nave → Z4 barragem (detonar, final) |

### ASCII

```
     x: -70 .. 90
  -80                                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -76                                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -72                                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -68                                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -64                                                   ~~~~~MMMM3MxMMMXMMMxMM3MMM~~~~~
  -60                                                               .
  -56                                                                .             x
  -52                                                                 .
  -48                                                                  .
  -44                                                                   .
  -40 =======================================================================|=========
  -36 =                                                                   .           =
  -32 =                        GGGGGGGGGGGGGGGGGGGGG                       ..         =
  -28 =                        G                   G                                  =
  -24 =                        G  4             4  G    CCCCCCC                       =
  -20 =         GGGGGGGGGGG    G                   G    C  x  C                       =
  -16 =         G       S G    GGGGGGGGGGGGGGGGGGGGG    | !5  C                       =
  -12 =         G         G    ======F===p===F======    C     C                       =
   -8 |  l      G         G                             CCCCCCC                       =
   -4 =         G         G                                                           =
    0 =         G      2  G                                                           =
    4 =         G         G                                                           =
    8 =         G    2    G                   c                                       =
   12 =         G         G         O                                                 =
   16 =         G !       GHHHH                                                       =
   20 =         GGGGGGGGGGGH  H                                                       =
   24 =                    HBHH                 R                                     =
   28 =                                                                               =
   32 =                           1             1                                     =
   36 =                                                                               =
   40 =                                                                               =
   44 =                                                                               =
   48 =                               1                                               =
   52 =                                     1                                         =
   56 =                                                                               =
   60 ===============================MMMM|MMMM=========================================
   64                                    :
   68                                    :
   72                                    :
   76                                    :
   80                                    :
   84                                    :
   88                                    :
   92                                    :
   96                                    V
  100                                    :
```

### Zonas e posições

| Zona | Elemento | Peça | Posição (x, z) | Notas |
|---|---|---|---|---|
| Z1 | Estrada de chegada | estrada | x 0, z 100 → 60 | P (0, 98), caminhão V (0, 94) |
| Z1 | Porteira em arco | `porteira`, `muro-caiado` (arco), `candeeiro-parede` ×2 | (0, 60) | o caminhão arrebenta |
| — | Cerca da fazenda | `cerca-varas` (alta) | retângulo x −70..90, z −40..60 | |
| Z5 | Cerca dos fundos | `porteira` pequena | (−70, −10) | Liberato l (−64, −10) |
| Z2 | Terreiro | `poco`, `cocho`, `carroca` | poço (−10, 12), cocho c (10, 10), carroça R (15, 25) | coberturas do E4 |
| Z2 | Casa-grande | `casa-grande` | x −20..20, z −32..−16; alpendre z −14..−10 | metralhadora p (0, −12); lampiões F (−8, −12), (8, −12); escritório (telegrama) |
| Z2 | Barracão | `barracao`, `saco-farinha` (pilhas) | x −50..−30, z −20..20 | livro S (−34, −16); quarto de castigo com `tronco` (−46, 16) **!1** |
| Z2 | Depósito de pólvora | `casa-taipa` | x −28..−22, z 16..24 | 2 `barril-polvora` (−25, 22) |
| Z3 | Capela | `capela` | x 30..42, z −24..−6; porta (30, −15) | chão bento; altar x (36, −20) |
| Z3 | Cripta | `cripta` (10 × 14 m, y −4) | sob a capela | alçapão atrás do altar; **!2** no 3º degrau; barril (36, −14); 4 argolas de corrente nas paredes |
| Z4 | Porteira dos fundos | `porteira` | (72, −40) | trilha até a barragem |
| Z4 | Barragem | `barragem` | crista z −62, x 40..80 | comportas x (52, −62), (68, −62); passarela; placa |
| Z4 | Casinha da manivela | `casa-taipa` | (84, −58) | detonador do pavio |
| Z4 | Açude | água | z < −64 | a única água do jogo |
| Z4 | Leito seco | `acude-seco` (leito) | de (60, −60) para leste, saindo do mapa | por onde a água desce |

### Encontros

| # | Posição | Inimigos | Regras |
|---|---|---|---|
| E1 | (−6, 50), (6, 52), (−14, 30), (14, 30), (0, 48), (8, 52) + 1 | 4 capangas + 3 soldados | pela frente; pelos fundos só 2 em ronda |
| E2 | (−40, 10), (−36, 0) | 2 capangas | barulho do tronco |
| E3 | (48, −62), (74, −62) | 2 capangas | na passarela |
| E4 | alpendre (0, −12); janelas (−14, −22), (14, −22) | coronel + metralhadora + capangas restantes | arcos de 6 s, 2 s de recarga |
| E5 | cripta | Coronel Velho + corpos-secos de 6 nichos (máx. 3) | 3 fases |

Itens: oferendas da Graça na carroceria do caminhão; `cartucheira` no depósito e no alpendre;
`garrafa-querosene` no barracão e na capela; `garrafada` no quarto de castigo.

### Ritmo de luz

A fazenda é o lugar mais iluminado do jogo (lampiões na porteira, no alpendre e nas janelas) e por
isso o mais hostil → o barracão é escuro e cheio de comida → a capela tem velas e chão bento →
a cripta é o escuro mais fundo do jogo, e lá o Encosto está mais forte → a barragem: céu
aberto, água e, no final, o primeiro fio de luz (lua no final B, dia nos outros).

### Peças do cap. 9

`terreno`, `cerca-varas`, `porteira`, `muro-caiado`, `candeeiro-parede`, `casa-grande`,
`janela-madeira`, `mobilia-sertao`, `barracao`, `saco-farinha`, `tronco`, `casa-taipa`,
`barril-polvora`, `poco`, `cocho`, `carroca`, `capela`, `oratorio`, `vela`, `cripta`, `barragem`,
`comporta`, `acude-seco`, `caminhao`, `fogueira`, `neblina`, `cartucheira`, `garrafa-querosene`,
`garrafada`, `folheto`, `bilhete`, `spawner`, `gatilho`.

---

## Peças: lista consolidada e prioridade de produção

Ordem sugerida: o que entra em mais capítulos vem primeiro.

| Prioridade | Peças |
|---|---|
| **Já existem (9)** | `terreno`, `mandacaru`, `casa-taipa`, `cerca-varas`, `cruz`, `pedra`, `arvore-seca`, `poco`, `lampiao` |
| **Reaproveitar do template (6)** | `porta-taipa` / `porteira` / `portao-cemiterio` (door), `barril-polvora` (exploding_barrel), `caminhao` (jeep), `cartucheira` (ammo_refil), `spawner` |
| **1 — em quase todos** | `neblina`, `galhada-seca`, `fogueira`, `candeeiro-parede`, `garrafa-querosene`, `lata-querosene`, `cova-rasa`, `folheto`, `bilhete`, `gatilho`, `casa-taipa-grande`, `janela-madeira`, `mobilia-sertao`, `xique-xique`, `lajedo`, `caixote`, `carroca` |
| **2 — dois ou mais capítulos** | `paredao`, `loca`, `cascalho`, `cruz-beira-estrada`, `cruz-torta`, `ex-voto`, `oratorio`, `vela`, `barraca-lona`, `fogueira-apagada`, `latada`, `curral`, `toco`, `acude-seco`, `carcaca-boi`, `casa-caiada`, `igreja`, `cruzeiro`, `muro-caiado`, `muro-pedra`, `cova-aberta`, `juazeiro`, `garrafada`, `oferenda-janela`, `barracao`, `espojadouro`, `jumento`, `urubu` |
| **3 — um capítulo só** | `corpo-bando`, `milho-seco`, `espantalho`, `mata-brejo`, `gameleira`, `cipo-trancado`, `olho-dagua`, `lama-mole`, `canoa-encalhada`, `cruzinha`, `casa-farinha`, `forno-barro`, `bodega`, `botica`, `porao`, `estante-vidros`, `barraca-feira`, `tabua-cabecas`, `parede-taipa-quebravel`, `chiqueiro`, `cabra-comum`, `macambira`, `facheiro`, `cacimba`, `casa-grande`, `capela`, `cripta`, `tronco`, `saco-farinha`, `barragem`, `comporta`, `cocho` |

