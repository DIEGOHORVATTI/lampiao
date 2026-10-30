# Bestiário

Cada ficha traz: **origem folclórica** (a lenda real, de onde vem), **versão no jogo**, **IA**
nos termos do template (patrulhar → perceber → perseguir → atacar), **fraqueza**, **som
característico** e **o que o Encosto ganha** ao comer.

## Como ler a IA

O inimigo base do template (`common/enemy/enemy.gd`) faz: parado/patrulha → vê o jogador
dentro de `vision_range` → persegue por `chase_time` → ataca dentro de `attack_range`. As
fichas dão valores sugeridos para esses `@export` e marcam com **🆕** o comportamento que
precisa ser programado além do template.

Referência de força: o corpo-seco é a unidade (GDD: morre com 3 tiros de pistola).
"Vida 3T" = aguenta 3 tiros de pistola. Rifle = 2 tiros de pistola. Peixeira = 1 tiro, mas
silenciosa. Raízes = 1,5 tiro (2,25 no escuro).

## Regras gerais

- **Profanas** (a cruz faz recuar a 4 m; chão bento queima): Corpo-Seco, Coronel Velho,
  Batatão, Papa-figo (só depois de revelado), Cabra-cabriola, Mula-sem-cabeça, alma penada.
- **Da mata** (a cruz não faz nada; só oferenda): Comadre Fulozinha, Caipora.
- **Sina** (a cruz segura pela metade, o Encosto não come): Lobisomem.
- **Gente** (volante, capangas): a cruz não faz nada; a Boca só nas escolhas.

## Tabela rápida

| Criatura | Caps. | Vida | Velocidade | Visão | Pode comer? | Fome | Ganho |
|---|---|---|---|---|---|---|---|
| Corpo-Seco | 1–9 | 3T | lenta | 10 m (luz: 16 m) | sim | −30 | vida +15 |
| Comadre Fulozinha | 2 | — | — | — | não | — | — |
| Batatão | 3 | — | média | atraído por luz | não | — | — |
| Papa-figo | 4 | 10T | média, emboscada | 6 m no escuro | sim (gente) | zera | Boca Grande; Marca +1 |
| Cabra-cabriola | 5 | 14T | rápida em investida | 14 m | sim | −60 | Olho de Brasa |
| Mula-sem-cabeça | 6 | atordoável | muito rápida | luz e brilho a 25 m | sim (gente) | zera | Brasa; Marca +1 |
| Lobisomem | 7 | 24T (chefe) | muito rápida | 20 m, faro | **não** (vomita) | — | — |
| Caipora | 8 | — | — | onipresente | não | — | — |
| Caititu | 8 | 2T | rápida em vara | 8 m | sim (bicho) | −15 | atrai a Caipora |
| Coronel Velho | 9 | 40T (chefe) | lenta, alcance longo | 12 m | sim | zera e **fica cheio** | Fartura (final) |
| Soldado da volante | 1, 3, 4, 8, 9 | 2T | normal | cone de lanterna 14 m | só na escolha | — | — |
| Capanga | 9 | 2T | normal | 12 m | não | — | — |

---

## Corpo-Seco

**Origem folclórica.** Lenda do interior do Sudeste e do Centro-Oeste (Vale do Paraíba
paulista e mineiro, Goiás), contada também em outras partes do interior do país. Um homem
tão ruim em vida (a versão mais comum diz que ele batia na própria mãe) que, quando morreu,
nem Deus nem o Diabo quiseram a alma dele, e **a terra cuspiu o corpo**. O corpo seca e não
apodrece: pele de couro grudada no osso. Fica encostado em tronco de árvore ou na beira da
estrada e ataca quem passa, às vezes chupando o sangue. O jogo leva a lenda para o sertão,
como acontece com toda lenda de interior: ela anda com quem conta.

**No jogo.** Os enjeitados: gente enterrada fora do muro do cemitério porque a terra não quis.
Desde que a lua sumiu eles levantam. São a **carniça** do pacto: o alimento básico do
Encosto, presentes em todo capítulo. Pele de couro escuro rachado, sem lábio (os dentes
sempre à mostra), olhos com um brilho vermelho pequeno, **visível de longe na neblina**
(é como o jogador sabe onde eles estão). Usam o modelo `undead` do template.

**IA.**
- Patrulhar: parado perto da cova ou andando devagar num trecho curto. Alguns ficam
  **agachados comendo** (cadáver, bicho) e só reagem à luz ou ao barulho.
- Perceber: `vision_range` 10 m; 16 m se o jogador estiver com o lampião de pavio alto. 🆕
  Ouvem tiro a 25 m.
- Perseguir: `move_speed` 1.0, `chase_time` 8 s; chamam os outros com um estalo (🆕 alerta em
  grupo a 12 m).
- Atacar: `attack_range` 1.8 m, agarrão + mordida, `attack_damage` 12.
- `can_open_doors`: não. Não atravessa muro de cemitério nem chão bento.

**Fraqueza.** Fogo (o lampião atirado mata na hora); cruz (recuam a 4 m); chão bento. Tiro na
cabeça conta em dobro.

**Som.** Estalo de couro seco dobrando, como sola velha; respiração que é só ar passando
por garganta seca; quando alertam, um estalo de dentes. Quando eles se aproximam, os grilos
param.

**O Encosto ganha.** Fome −30, vida +15. Nenhum poder. "Carniça num enche, só engana."

### Variação: Coronel Velho Valadares (chefe final, cap. 9)

**Origem.** Um corpo-seco de verdade, no sentido mais exato da lenda: o coronel que deixou 312
retirantes morrerem na vala atrás do barracão na seca de 1877, vendendo farinha a peso de
ouro. Morreu em 1911, a terra não quis o corpo, e o filho guardou o pai na cripta da capela,
acorrentado, alimentado com bode e, quando faltava bode, com retirante.

**No jogo.** Três metros de altura curvado, magro como galho, a pele grudada nas correntes
que ele arrebentou, a roupa de coronel de 1877 em farrapo, anéis nos dedos secos. Braços longos
demais. Na cripta, cercado de nichos com os ossos dos "remédios".

**IA (chefe, três fases).**
1. **Acorrentado:** ataca com os braços a até 5 m (varredura); o jogador precisa quebrar as
   quatro correntes com tiro (cada uma que cai solta um corpo-seco de um nicho).
2. **Solto:** anda devagar (`move_speed` 0.8), mas **arremessa** pedra e osso (🆕 ataque à
   distância) e chama corpos-secos (spawner nos nichos, máx. 3).
3. **Com fome:** quando a vida cai a 30%, ele tenta comer os corpos-secos que chamou para se
   curar (🆕). O jogador tem que matar os corpos-secos antes ou usar a cruz para afastar os
   dois.

**Fraqueza.** Fogo (barril de pólvora no meio da cripta); cruz faz recuar, mas só por 3 s.
Só é destruído pela **Boca**: tiro e faca derrubam, mas ele levanta de novo depois de 10 s,
até o Encosto comer.

**Som.** Correntes; uma voz de velho que só repete preço ("um conto o saco... um conto o
saco..."); as vozes do coro do Encosto respondendo em uníssono quando ele fala.

**O Encosto ganha.** Fome a zero e **travada em zero** até o fim do capítulo ("Fartura"). As
Raízes dobram de tamanho. É a única vez no jogo em que o Encosto fica cheio, e mesmo assim
ele cobra o trato.

---

## Comadre Fulozinha

**Origem folclórica.** Pernambuco, sobretudo a Zona da Mata e o agreste, conhecida também em
partes da Paraíba e de Alagoas como "Cumade Fulozinha" ou "Florzinha". Uma caboclinha de
cabelo preto muito comprido que é **dona da mata** e protege os bichos. Trança a crina e o rabo
dos cavalos durante a noite. Persegue caçador e quem desrespeita o mato, dá surra de
urtiga ou de cipó e faz o vivente se perder. Anuncia a chegada com **assovio**: dizem que
quando o assovio é alto ela está longe, e quando é baixinho ela está perto. É agradada com
**oferenda** deixada no mato: fumo, mel, mingau, papa de milho.

**No jogo.** Nunca aparece inteira. No máximo uma mecha de cabelo preto passando entre as
folhas, a dois metros do lampião, e pegadas pequenas de pé descalço na lama do olho-d'água.
Não é inimiga: é **dona**. Não pode ser ferida, não pode ser comida, e a cruz não faz nada
contra ela.

**IA** 🆕 (sistema de presença, não inimigo):
- Patrulhar: um emissor de som invisível que gira em volta do jogador a 15–30 m (assovio
  alto) e às vezes se aproxima a 1 m (assovio baixinho, binaural).
- Com oferenda: o emissor vai para o próximo ponto de coleta e fica lá até o jogador chegar.
- Sem oferenda: a cada 40 s, uma surra (dano 10, empurrão de câmera); duas passagens de
  `cipo-trancado` trocam de lugar quando o jogador não está olhando.
- Raízes contra ela: acertam o ar e voltam com uma trança de cipó na ponta.

**Fraqueza.** Nenhuma. Só a oferenda.

**Som.** Assovio de duas notas, subindo, sem melodia certa; folha mexendo sem vento; um riso
curto de menina, uma vez só no capítulo.

**O Encosto ganha.** Nada. "Isso aí num é comida, garoto. É dona."

---

## Batatão

**Origem folclórica.** Nome nordestino do fogo-fátuo, o mesmo bicho que no Sul e no Sudeste
se chama Boitatá e em outros lugares se chama fogo-corredor. É uma bola de fogo que vaga de
noite por brejo, açude e cemitério. Na crença do povo é alma penando (de pagão, de quem
morreu devendo promessa, de quem mudou marco de terra). Persegue quem corre dela e some se a
pessoa ficar parada, rezar ou se deitar no chão. A explicação da ciência é gás de matéria
podre que pega fogo sozinho, e combina com o açude seco cheio de bicho morto.

**No jogo.** Uma bola de fogo do tamanho de uma cabeça, sem corpo, chiando. De longe parece
lanterna de soldado. **Bebe luz**: perto dele o querosene do jogador some.

**IA** 🆕:
- Patrulhar: vaga devagar sobre o açude seco, numa rota de pontos.
- Perceber: atraído por luz (pavio alto a 20 m) e por movimento rápido (correr a 15 m).
  Pavio baixo e andar agachado: não percebe.
- Perseguir: acompanha quem corre na mesma velocidade; para quando o jogador para.
- "Atacar": a 3 m, drena 5% de querosene por segundo e puxa a chama. Na primeira vez,
  roteirizado, apaga o lampião.
- A cruz faz ele recuar 8 m e voltar a vagar.

**Fraqueza.** Ficar parado, pavio baixo, cruz. Não morre.

**Som.** Chiado de chama em vento, crepitar; quando bebe a luz, um som de sucção e o pavio
do jogador assoviando.

**O Encosto ganha.** Nada. "Fogo num enche barriga."

---

## Papa-figo

**Origem folclórica.** Lenda urbana do Recife, também contada no interior de Pernambuco e na
Bahia, parente do "homem do saco". Um homem rico, doente de um mal sem cura, que acredita
que só fígado de criança vai salvar ele. Sai disfarçado de velho mendigo, com um saco nas
costas, oferecendo doce e brinquedo, ou manda empregados fazerem o serviço. Servia para as
mães segurarem os filhos dentro de casa de noite. Nas versões antigas a doença é a lepra. O
jogo não dá nome à doença, para não pôr estigma em doença real.

**No jogo.** O Doutor Gaudêncio, boticário de Santa Luzia, cunhado do coronel. De dia é
doutor. De noite é mendigo pedindo esmola. No porão, sem disfarce, é um homem que já virou
bicho: pele descascando, barriga inchada, dedos compridos demais, mais dente do que boca.
Ainda é **gente**, e por isso comer ele soma Marca.

**IA.**
- Patrulhar (disfarçado, beat 3 do cap. 4): NPC que pede esmola; não ataca.
- Perceber (no porão): 🆕 **só no escuro**. Com o lampião alto a menos de 4 m ele recua
  (`vision_range` 6 m, mas evita o cone de luz).
- Perseguir: 🆕 **apaga velas** do porão (interage com `vela`), contorna estantes e se aproxima
  pelas costas.
- Atacar: 🆕 agarrão (dano 15) que **tira o lampião da mão** do jogador (o lampião cai aceso a 2
  m); mordida no agarrado.
- `move_speed` 1.4, `max_health` 10T.

**Fraqueza.** Luz (recua); fogo (o lampião atirado no jarro de álcool resolve a luta).

**Som.** Tosse molhada; o saco de estopa arrastando no chão; voz pedindo esmola mesmo no
porão ("uma esmolinha...").

**O Encosto ganha.** Fome zerada, vida cheia, **Marca +1**, poder **Boca Grande**: a Boca
alcança 3 m e puxa a criatura caída até o jogador. "Gosto de remédio. Mas é gente."

---

## Cabra-cabriola

**Origem folclórica.** Nordeste, registrada no folclore de Pernambuco e contada também na
Paraíba, em Alagoas e no Rio Grande do Norte. Uma cabra monstruosa que solta **fogo pelos
olhos, pelas ventas e pela boca** e entra nas casas de noite para comer criança, sobretudo
menino desobediente. Era o bicho-papão das mães sertanejas: "Dorme, menino, senão a
cabra-cabriola vem."

**No jogo.** Do tamanho de um jumento, pelo preto queimado, chifres torcidos para trás,
brasa no lugar dos olhos. Anda nos telhados. Bale com voz de bebê chorando. Vai **atrás das
crianças** antes de ir atrás do jogador.

**IA.**
- Patrulhar: 🆕 escolhe uma casa com criança e circula por telhado, janela e parede.
- Perceber: `vision_range` 14 m; 🆕 prioridade de alvo: criança NPC > jogador.
- Perseguir: 🆕 **investidas** em três fases (telhado → janela → parede), recua depois de
  levar dano equivalente a 4T em cada uma; 20–30 s de intervalo.
- Atacar: chifrada (dano 20, derruba); 🆕 **sopro de fogo** em cone de 4 m pela janela ou buraco
  (dano contínuo, acende cortina e palha); quebra `parede-taipa-quebravel`.
- No curral: 🆕 **se mistura ao rebanho** (12 `cabra-comum`) e anda com ele; só o Faro
  mostra qual é ela.
- `max_health` 14T; `can_open_doors`: sim (arromba).

**Fraqueza.** Tiro nos olhos (dano dobrado e ela recua); cruz (recua); água jogada (apaga o
sopro por 5 s).

**Som.** Balido que vira choro de bebê; casco no telhado; telha quebrando; o sopro como fole de
ferreiro.

**O Encosto ganha.** Fome −60, vida +40, poder **Olho de Brasa**: o Faro enxerga através de
parede de taipa e de madeira. "Ah. Isso sim. Isso é comida."

---

## Mula-sem-cabeça

**Origem folclórica.** Lenda de origem ibérica que se espalhou pelo Brasil todo desde a
Colônia. A mulher que tem um caso com padre vira, na noite de **quinta para sexta-feira**,
uma mula sem cabeça que corre por **sete freguesias** antes do galo cantar, soltando fogo pelo
pescoço, com cascos de ferro que ferem quem encontra. Leva um **freio de ferro**: quem
conseguir arrancar o freio quebra a sina, e ela volta a ser mulher, nua e envergonhada, até
morrer. Furar com alfinete até tirar sangue também quebra o encanto. Quem cruzar com ela
deve se deitar de bruços e **esconder unha, dente e olho**, tudo o que brilha, porque ela
vai atrás do brilho.

**No jogo.** Rosália, a mulher escondida do Padre Anselmo. A mula corre o circuito da vila:
adro, cemitério, rua da igreja e estrada. É uma mula preta e magra, com o pescoço aberto
soltando fogo como tocha, um freio de ferro preso a um pedaço de rédea que bate no peito.

**IA** 🆕 (perseguidora de circuito):
- Patrulhar: corre um **circuito fixo** de pontos em volta da igreja e do cemitério (uma volta
  a cada ~50 s), anunciada pelo sino que bate sozinho.
- Perceber: atraída por **luz e brilho** a 25 m (pavio alto, tiro, arma refletindo). Esconder:
  **agachar + pavio baixo + olhar para o chão** (a mira abaixo do horizonte) = invisível
  mesmo a 2 m.
- Perseguir: muito rápida (`move_speed` 4.0), mas vira mal: passa direto e faz curva larga.
- Atacar: atropelo com casco (dano 30, derruba); fogo do pescoço deixa rastro em chamas por 4
  s; derruba lápide e cruz pelo caminho.
- **Atordoar:** fazê-la bater no `cruzeiro` do adro, num túmulo de alvenaria ou num
  `barril-polvora` (atraindo com o lampião levantado no último segundo e saindo da frente). Atordoada
  por 6 s, aparece a escolha.

**Fraqueza.** Bater em pedra; a cruz faz ela desviar do jogador; o freio.

**Som.** Galope de ferro em pedra; o chacoalhar do freio; um relincho que é quase grito de
mulher; o sino da matriz batendo sozinho.

**O Encosto ganha.** (se comida) Fome zerada, **Marca +1**, poder **Brasa**: as Raízes deixam
fogo no alvo (dano contínuo, assusta corpo-seco). "Mula é carne boa, garoto."

---

## Lobisomem

**Origem folclórica.** Vem da Europa (o *lykánthropos* grego, o *lobisomem* português), mas no
Brasil ganhou regras próprias. A sina cai sobre o **sétimo filho homem depois de seis
mulheres**; em várias versões, ela se evita se o irmão ou a irmã mais velha for padrinho ou
madrinha do caçula. Na **sexta-feira à meia-noite** o homem vai a uma **encruzilhada** ou a um
**espojadouro** (onde jumento e cavalo rolam na poeira), rola no chão e vira bicho. Corre
sete cemitérios, sete vilas ou sete encruzilhadas, come bicho e às vezes gente, e volta ao
mesmo lugar antes do galo cantar para virar homem de novo. Como no Brasil não há lobo, o
lobisomem do sertão é descrito como **cachorro enorme**, às vezes com orelhas grandes
balançando, às vezes com jeito de porco. Cura: **ferir o bicho até tirar sangue**, com faca ou
qualquer coisa de ponta, sem matar, e quem feriu **não pode contar a ninguém**, senão a sina
passa para ele. Bala de prata ou benta mata.

**No jogo.** Damião, o vaqueiro. O bicho é um cachorro do tamanho de um bezerro, sarnento, de
orelhas compridas, patas traseiras dobradas ao contrário, coberto da poeira do espojadouro,
com os olhos de Damião. Muito rápido, foge para o escuro, volta pelos lados.

**IA (chefe)** 🆕:
- Patrulhar: corre o circuito da sina (espojadouro → encruzilhada → cemiteriozinho → curral),
  e o jogador segue os rastros.
- Perceber: `vision_range` 20 m e 🆕 **faro**: acha o jogador escondido em 10 s se ele não se
  mexer; evita **fogueira** acesa (raio 6 m).
- Perseguir: **ataca e some** (🆕 hit-and-run): investida, mordida, volta para o escuro e
  circula fora da luz por 8–12 s; depois vem por outro lado.
- Atacar: mordida (dano 20), investida que derruba (dano 25), uivo que apaga as fogueiras num
  raio de 10 m (🆕 uma vez por fase).
- Fases: 100–60% caça; 60–25% vai atrás de Rosinha na casa (o jogador tem que chegar antes);
  25%: cai, e aparece a escolha.
- A cruz: segura o bicho parado por 3 s (ele gane e treme), não o faz fugir.

**Fraqueza.** Fogo (as fogueiras do sítio, que o jogador acende ou mantém); tiro de rifle na
investida (o tiro no momento do salto atordoa).

**Som.** Uivo que começa como choro de homem; farejar alto; corrente de cachorro arrastando
(ele leva a corrente do curral); os cachorros do sítio param de latir quando ele chega.

**O Encosto ganha.** **Nada.** Se o jogador tentar a Boca, o Encosto morde e **vomita**:
"Isso tem gosto de mim, garoto. Esse aí também tá encostado. Bicho num come bicho do mesmo
couro." Curar dá Graça; matar não dá nada a ninguém.

---

## Caipora

**Origem folclórica.** De origem tupi (*caa-pora*, "o que mora no mato"). Protetora dos
bichos, parente do Curupira; no Nordeste costuma ser descrita como uma caboclinha ou um
caboclinho de pele escura, às vezes de um pé só, **montado num caititu** (porco-do-mato).
Gosta de **fumo** e de cachaça. Castiga quem caça além da precisão, quem mata fêmea prenha
ou filhote, quem caça em dia santo: faz o caçador se perder, espanta a caça e dá surra. Por
isso, no Nordeste, "andar com a caipora" quer dizer andar com azar. Agrada-se com fumo
deixado num toco ou num galho.

**No jogo.** Nunca vista de frente: um vulto pequeno montado num porco, de relance, sempre no
limite do lampião; pegadas de criança ao lado de rastro de caititu. A dona do Tabuleiro
das Almas. Sabe o que o jogador fez no brejo (`oferenda`) porque as donas da mata se
conhecem.

**IA** 🆕 (sistema de presença + vara de caititus):
- **Medidor de caça** (escondido): cada bicho morto no tabuleiro (preá, mocó, bode solto,
  caititu) soma 1. Os bichos servem de lanche para o Encosto (fome −15).
- Com `oferenda=sim`: tolera 2 bichos. Com `oferenda=nao`: tolera 0, e o assovio começa
  hostil desde a entrada.
- Passou do limite: 🆕 **o caminho se dobra** (a saída de uma clareira leva de volta ao mesmo
  lajedo, até três vezes), **vara de caititus** (4–6) investe, e surras de vara (dano 10).
- Fumo deixado num `toco` zera o medidor e libera o caminho (há fumo numa tapera do mapa).
- A cruz não faz nada.

**Fraqueza.** Nenhuma. Respeito e fumo.

**Som.** Assovio fino de três notas; **dente de caititu batendo** (o estalo que a queixada faz
de verdade quando ameaça); risada curta; casco miúdo correndo em volta, no escuro.

**O Encosto ganha.** Nada dela. Dos bichos, só lanche: "Preá é tira-gosto, garoto. Eu quero
almoço."

### Caititu (vara da Caipora)

Porco-do-mato. Vida 2T, `move_speed` 3.0, investida em grupo (dano 8 cada), foge depois de
uma investida e volta. Pode ser comido (fome −15), mas cada um conta no medidor de caça.

---

## Alma penada

**Origem folclórica.** Crença católica popular espalhada pelo Brasil: a alma que não descansa
porque deixou promessa sem pagar, dívida, segredo, ou porque o corpo não teve enterro
cristão. Aparece a parentes e conhecidos, pede reza, missa ou que se cumpra o que ficou
pendente.

**No jogo.** Jurema, o menino do bando, sem enterro porque a cabeça foi levada. Não é inimigo
e não faz dano. Aparece na borda da luz, some quando a luz passa por ele, e assovia "Mulher
Rendeira" para guiar a segredos e caminhos. A cruz não o afasta (ele é alma boa), mas o
Encosto se cala quando ele está perto.

**Som.** Assovio de "Mulher Rendeira"; passo descalço sem peso; quando fala, a voz vem do
lugar certo, mas sem eco nenhum.

**O Encosto ganha.** Nada. O Encosto nunca tenta.

---

## Gente

### Soldado da volante

**Origem.** As volantes eram tropas policiais estaduais que caçavam cangaceiros pelo sertão,
muitas vezes formadas por sertanejos com contas a acertar com os bandos e tão violentas
quanto eles. Cangaceiro chamava soldado de "macaco".

**No jogo.** Farda cáqui encardida, chapéu de aba larga, fuzil Mauser. Andam em dupla, com
lanterna.

**IA** 🆕 (inimigo de tiro):
- Patrulhar: rota em dupla com lanterna (🆕 **cone de visão** de 14 m na direção da lanterna;
  fora do cone, 4 m).
- Perceber: vê o lampião aceso do jogador a 25 m; ouve tiro a 30 m.
- Perseguir: avança até ter linha de tiro, procura cobertura.
- Atacar: 🆕 **tiro de fuzil** a distância (dano 15, cadência lenta); coronhada a 1,5 m.
- Vida 2T. Lanterna pode ser acertada (o soldado fica cego por 5 s).
- Morto não pode ser comido. Faminto (fome 75+), as Raízes podem atacar soldado vivo.

**Som.** Bota em pedra, metal de fuzil, conversa baixa, assovio de sinal entre duplas.

### Capanga do coronel (cap. 9)

Jagunço de fazenda: chapéu de couro, espingarda de dois canos ou facão. Igual ao soldado, mas
`vision_range` 12 m, espingarda com dano 25 a menos de 8 m e quase nada de longe. Alguns
só de facão (corpo a corpo, `move_speed` 1.6).

---

## O Encosto (referência)

Não é inimigo: é o "segundo jogador" dentro de Lampião. Regras completas em `00-biblia.md`.
O povo o chama de "o que tá com ele", "o cão", "o **cramunhão**" (nome nordestino do diabo)
ou "o coisa-ruim", mas ele não é o Diabo. É a fome de 1877.

| Poder | De onde vem |
|---|---|
| Raízes, Boca, Faro | desde o cap. 1 e 3 |
| Boca Grande | Papa-figo comido |
| Olho de Brasa | Cabra-cabriola comida |
| Brasa | Mula comida |
| Voz | Tenente comido (cap. 8): o Encosto imita a voz do tenente e manda soldados e capangas para longe |
| Fartura | Coronel Velho comido (cap. 9) |

Cada ponto de **Marca** acrescenta uma voz ao coro do Encosto (Benedito, Liberato, o
boticário, Rosália, o tenente, o coronel).
