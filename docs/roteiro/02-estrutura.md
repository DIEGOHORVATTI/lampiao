# Estrutura

Nove capítulos, uma noite cada, de 12 a 20 minutos (total ~2h20 na primeira jogada).
Três atos. Cada capítulo apresenta uma criatura nova e reaproveita os corpos-secos como
"carniça" de base, que o jogador precisa comer para manter a fome sob controle.

| Ato | Nome | Capítulos | Pergunta do ato |
|---|---|---|---|
| I | **A Cabeça** | 1–3 | O que eu virei, e quem me vendeu? |
| II | **O Povo** | 4–7 | Vale a pena proteger quem me nega água? |
| III | **O Trato** | 8–9 | Quando a vingança acaba, o que sobra de mim? |

## Visão geral

| # | Capítulo | Noite | Local | Criatura principal | Duração |
|---|---|---|---|---|---|
| 1 | `cap01-a-cabeca` | qui 28/07 | Grota da Baraúna e Encruzilhada | Corpo-Seco | 15–18 min |
| 2 | `cap02-o-crucifixo` | sex 29/07 | Sítio Olho-d'Água e brejo da serra | Comadre Fulozinha | 14–16 min |
| 3 | `cap03-o-coiteiro` | sáb 30/07 | Sítio Lagoa Rachada | Batatão | 14–16 min |
| 4 | `cap04-a-feira-das-cabecas` | dom 31/07 | Vila de Santa Luzia do Ermo | Papa-figo | 18–20 min |
| 5 | `cap05-a-cabra` | qua 03/08 | Sítio Pau-Ferro | Cabra-cabriola | 14–16 min |
| 6 | `cap06-a-mula` | qui 04/08 | Igreja e cemitério de Santa Luzia | Mula-sem-cabeça | 15–17 min |
| 7 | `cap07-sexta-feira` | sex 05/08 | Sítio Pau-Ferro, encruzilhada e cemiteriozinho | Lobisomem (chefe) | 14–16 min |
| 8 | `cap08-a-caipora` | sáb 06/08 | Tabuleiro das Almas | Caipora | 16–18 min |
| 9 | `cap09-o-coronel` | dom 07/08 | Fazenda Jatobá | Coronel Velho (corpo-seco ancião) | 18–20 min |

Entre os caps. 4 e 5 passam dois dias (segunda e terça): Lampião fica escondido no Sítio
Pau-Ferro com as cabeças num bornal, e Dorinha trata a costura.

## Progressão de mecânicas

| Cap | Ganha | Aprende |
|---|---|---|
| 1 | peixeira, lampião, pistola; Raízes, Boca | luz, querosene, fome, comer, furtividade |
| 2 | **crucifixo**, garrafada | segurar a cruz, oferenda, chão bento |
| 3 | **rifle** (mosquetão), Faro | pavio baixo (Batatão), mirar longe |
| 4 | — | furtividade com volante, perseguição, atirar o lampião |
| 5 | — | defender casa, porta de taipa, criança como alvo |
| 6 | — | esconder o que brilha (Mula), sino, chão consagrado longo |
| 7 | — | chefe que foge para o escuro, fogueiras como zona segura, ferir sem matar |
| 8 | **caminhão** | caça e Caipora (comer tem preço), emboscada humana, dirigir |
| 9 | **metralhadora** (uso único), barril de pólvora | tudo junto; luta final de vontade (crucifixo contra possessão) |

---

## Escolhas morais e medidores

Medidores escondidos (ver bíblia): **Marca** (gente comida pelo Encosto) e **Graça** (ajuda ao
povo que negou ajuda).

| Cap | Escolha | Opção | Efeito | Consequência visível |
|---|---|---|---|---|
| 1 | Soldado Benedito, ferido debaixo de uma carroça | **Poupar** (guardar a peixeira) | `benedito=poupado` | cap. 8: ele grita o aviso da emboscada e a primeira rajada não acerta |
| | | **Dar ao Encosto** (Boca) | Marca +1, `benedito=comido` | primeira voz no coro; a fome do cap. 1 zera |
| 2 | Comadre Fulozinha bloqueia o brejo | **Dar o fumo** (o último rolo de fumo de Lampião, no toco) | `oferenda=sim` | ela guia com assovio; cap. 8: a Caipora já sabe e deixa passar |
| | | **Forçar passagem** | `oferenda=nao` | ela embaralha o caminho e dá surra de cipó (dano); cap. 8: Caipora hostil desde o início |
| 3 | Liberato na casa de farinha | **Perdoar** (guardar a arma e virar as costas) | Graça +1, `liberato=perdoado` | cap. 9: ele abre a cerca dos fundos da fazenda e acha Tonho |
| | | **Dar ao Encosto** | Marca +1, `liberato=comido` | Zulmira grita o resto do capítulo; o coro ganha a voz dele |
| | | **Bala** | `liberato=morto` | Zulmira amaldiçoa; volante chega mais rápido |
| 4 | Inácia (fechou a porta) perde o filho para o Papa-figo | **Ir atrás do Biu** | Graça +1, `biu=salvo` | primeira oferenda na janela (querosene) |
| | | **Seguir para as cabeças** | `biu=perdido` | o choro de Inácia continua ao fundo até o fim do capítulo; o cordel conta |
| 4 | Papa-figo caído | **Dar ao Encosto** | Marca +1, poder "Boca Grande" | — |
| | | **Bala / deixar** | — | os moradores acham o corpo de manhã (cordel) |
| 5 | Vizinhos que negaram ajuda pedem abrigo da cabra | **Abrir a porta** | Graça +1, `vizinhos=abrigados` | mais gente para proteger, defesa mais difícil |
| | | **Deixar trancada** | `vizinhos=fora` | a cabra pega um dos meninos lá fora (só som); Dona Nena nunca mais fala |
| 6 | Mula-sem-cabeça atordoada | **Tirar o freio** | Graça +1, `rosalia=livre` | Rosália vive; dá o freio a Lampião; o padre confessa |
| | | **Dar ao Encosto** | Marca +1, poder "Brasa" | o padre enlouquece no adro |
| 7 | Lobisomem caído | **Sangrar com a peixeira** (segurando a cruz) | Graça +1, `damiao=curado` | Damião vive e não lembra; Lampião guarda segredo |
| | | **Atirar** | `damiao=morto` | Rosinha órfã; vai morar com Dorinha |
| 8 | Tenente Laurindo ferido | **Deixar ir** | `tenente=poupado` | ele tira a farda e deixa os anéis e o chapéu de Lampião numa pedra |
| | | **Dar ao Encosto** | Marca +1, poder "Voz" | — |
| | | **Bala** | `tenente=morto` | — |
| 9 | Tonho no tronco do barracão | **Soltar** (desvio opcional) | Graça +1, `tonho=livre` | se Liberato perdoado, encontro pai e filho |
| 9 | Coronel Teotônio rendido | **Dar ao Encosto** | Marca +1 | — |
| | | **Bala** | — | — |
| | | **Deixar pro povo** (só se Graça ≥ 3 até aqui) | — | o povo chega com candeeiros e leva o coronel até a barragem aberta |

Máximo de Marca: 6. Máximo de Graça: 6.

### Regra de ouro das escolhas

1. O jogo nunca diz "bom" ou "mau". O aviso de botão descreve a **ação** ("Guardar a peixeira",
   "Deixar ele comer").
2. Toda escolha de Marca tem **vantagem mecânica real** (fome zera, poder novo). Toda escolha
   de Graça tem **custo real** (mais tempo, mais risco, nenhum agradecimento na hora).
3. O povo nunca agradece em palavras. A Graça aparece em coisa deixada na janela, em porta
   entreaberta, em cordel.

---

## Finais

Calculados ao fim do cap. 9, depois da escolha do coronel:

```
se Marca ≥ 4                     → FINAL C  "A Fome"
senão se Graça ≤ 2               → FINAL D  "A Cabeça"
senão se Marca ≥ 2               → FINAL A  "O Mal Necessário"
senão (Marca ≤ 1, Graça ≥ 3)     → escolha na cova: FINAL B "Descanso" ou FINAL A
```

### Final A — "O Mal Necessário"

Lampião segura o crucifixo contra a costura e diz ao Encosto que a vingança não acabou:
"Enquanto tiver coronel nesse sertão, minha vingança num acaba." O Encosto ri, porque é
uma brecha honesta. Lampião sai da fazenda pela barragem arrombada, com a água descendo para
a ribeira. Epílogo: cruzes de beira de estrada com ex-votos para "o Capitão"; o povo deixa
carniça na encruzilhada para "o que anda com ele". Última fala:
**Encosto:** "Tô com fome, garoto." **Lampião:** "Espera um pouco."

### Final B — "Descanso"

O povo chega à fazenda com candeeiros. No cemitério de Santa Luzia, ao lado da cova das
cabeças, Dorinha reza. Lampião tira o cordão e põe o crucifixo dentro da boca da costura;
o Encosto fica preso no corpo morto, debaixo de uma cruz que Damião (ou Liberato) prega no
chão. Jurema estende a mão: "O senhor veio." / "Me atrasei um pouco." A lua volta, fina, no
céu. Zé Mirim canta a excelência.

### Final C — "A Fome"

O crucifixo queima na mão e cai. O Encosto toma o corpo. A câmera continua em primeira
pessoa, mas o jogador não controla mais: as raízes andam sozinhas para a vila, as portas se
fecham uma a uma, e a última é a de Zé Mirim. Cordel: "Lampião virou o Cão / e o Cão virou
Lampião."

### Final D — "A Cabeça"

Ninguém vem. O Encosto, cheio do Coronel Velho, declara o trato cumprido e **sai** do corpo:
"Vingança feita, garoto. Eu num fico em casa vazia." A costura se abre e a cabeça cai na
lama da barragem. De manhã a volante chega. Corte: 1938, uma vitrine de museu em Salvador,
uma etiqueta com o nome dele. Último plano: no reflexo do vidro, um soldado jovem sorri com
a boca grande demais. A fome mudou de casa.

### Variações dentro dos finais (cordel do epílogo)

O cordel de Zé Mirim cita: Rosinha (com o pai ou com Dorinha), Biu, Rosália e o padre,
Liberato e Tonho, o tenente (vivo e sem farda, ou nome em cruz) e Benedito.

---

## Os capítulos

### Ato I — A Cabeça

#### `cap01-a-cabeca` — Grota da Baraúna

- **Objetivo:** recuperar a cabeça, sair vivo da Encruzilhada, voltar à grota e alcançar a
  estrada antes do dia.
- **Criatura:** Corpo-Seco (os enjeitados do cemitério fora do muro).
- **Ensina:** olhar, andar, peixeira, luz/querosene, fome, Raízes, Boca.
- **Virada:** a volante foge no caminhão levando as outras seis latas. O corpo de Lampião
  chegou, a cabeça foi costurada, e o jogador descobre que agora come assombração.
- **Escolha:** Benedito.
- **Termina:** a luz do dia nasce, Lampião cai junto a uma cruz de beira de estrada, e um
  candeeiro se aproxima: Dona Dorinha.

#### `cap02-o-crucifixo` — Sítio Olho-d'Água

- **Objetivo:** buscar vassourinha e pinhão-roxo no brejo da serra para Dorinha "fechar o
  corpo" dele; defender a casa.
- **Criatura:** Comadre Fulozinha (e corpos-secos atraídos pelo cheiro).
- **Ensina:** crucifixo, chão bento (o quarto de reza), oferenda.
- **Virada:** na reza, o Encosto reconhece Dorinha ("Doralice. Tu ficou velha.") e revela que
  ela já o arrancou de um homem, que morreu.
- **Escolha:** oferenda a Fulozinha.
- **Termina:** Dorinha diz quem vendeu o bando: Liberato, que teve o filho levado pelo
  coronel. "Vai. Mas num deixa ele comer gente, Virgulino. Gente engorda ele."

#### `cap03-o-coiteiro` — Sítio Lagoa Rachada

- **Objetivo:** pegar o mosquetão no coito, cruzar o açude seco e achar Liberato.
- **Criatura:** Batatão (bebe a luz do lampião); patrulha da volante.
- **Ensina:** pavio baixo, rifle, Faro, inimigo humano com arma de fogo.
- **Virada:** Liberato conta que vendeu o bando pelo filho e que as cabeças vão ser expostas
  na escadaria da igreja de Santa Luzia no domingo de feira. Conta também o boato: "A lata
  do senhor voltou vazia. O tenente mandou arranjar outra cabeça."
- **Escolha:** Liberato.
- **Termina:** Lampião na estrada para a vila. O Encosto: "Vila tem muita gente, garoto.
  Muita."

### Ato II — O Povo

#### `cap04-a-feira-das-cabecas` — Vila de Santa Luzia do Ermo

- **Objetivo:** recuperar as cabeças da escadaria da igreja, guardadas pela volante.
- **Criatura:** Papa-figo (o boticário disfarçado de mendigo).
- **Ensina:** furtividade em espaço urbano, porta trancada como ambiente, perseguição.
- **Virada:** a cabeça exposta como "Lampião" é de um retirante, Expedito. O tenente matou um
  inocente para não perder a recompensa. Entre os homens e as assombrações, já não dá para
  separar.
- **Escolhas:** ir atrás do Biu; comer o Papa-figo.
- **Termina:** com o bornal das sete cabeças nas costas, Lampião sai pelo beco e Damião
  aparece com um jumento: "Dona Dorinha mandou. Lá em casa o senhor descansa."

#### `cap05-a-cabra` — Sítio Pau-Ferro

- **Objetivo:** defender a casa de Damião e Rosinha da cabra-cabriola até ela se mostrar e
  matá-la no curral.
- **Criatura:** Cabra-cabriola.
- **Ensina:** defesa de casa de taipa (paredes que racham, porta que cede, telhado), proteger
  NPC.
- **Virada:** os vizinhos que negaram água a Lampião na estrada correm para a casa de
  Damião pedindo abrigo. Depois da luta, Rosinha comenta que "painho fica doente toda sexta".
- **Escolha:** abrir a porta aos vizinhos.
- **Termina:** Damião, olhando o céu sem lua: "Sexta tá chegando, Capitão. Se eu ficar
  esquisito, o senhor tranca a menina."

#### `cap06-a-mula` — Igreja e cemitério de Santa Luzia

- **Objetivo:** enterrar as sete cabeças em chão bento, na quinta-feira à noite.
- **Criatura:** Mula-sem-cabeça (Rosália, a mulher do padre).
- **Ensina:** esconder o que brilha (pavio baixo, agachar, de cara para o chão), chão
  consagrado prolongado (custo de vida), perseguição pelo som.
- **Virada:** o livro de óbitos da sacristia registra 43 retirantes "sem nome" na vala do
  açude Jatobá, e uma carta do coronel ao padre diz: "Pregue que ele é o Cão." O padre é
  pago para chamar Lampião de demônio.
- **Escolha:** tirar o freio ou deixar o Encosto comer a Mula.
- **Termina:** o enterro, com Zé Mirim cantando excelência. Jurema não entra na cova: "Inda
  não, Capitão. Eu espero o senhor."

#### `cap07-sexta-feira` — Sítio Pau-Ferro

- **Objetivo:** seguir Damião transformado pelo espojadouro, pela encruzilhada e pelo
  cemiteriozinho do sítio, e detê-lo antes do dia sem deixar Rosinha morrer.
- **Criatura:** Lobisomem (chefe).
- **Ensina:** chefe que foge para o escuro, fogueiras como refúgio, ferir sem matar.
- **Virada:** o Encosto morde o lobisomem e vomita. "Isso tem gosto de mim, garoto. Esse aí
  também tá encostado." O Encosto não pode comer a sina de outro.
- **Escolha:** sangrar (curar) ou atirar.
- **Termina:** amanhece fraco. Damião vivo e nu no espojadouro, sem lembrar, ou o corpo e
  Rosinha chorando na porta. O Encosto: "Agora o coronel, garoto. Tô cansado de esperar."

### Ato III — O Trato

#### `cap08-a-caipora` — Tabuleiro das Almas

- **Objetivo:** atravessar a caatinga funda até a estrada da Fazenda Jatobá sem se perder,
  com pouca carniça e muita fome; sobreviver à emboscada da volante; tomar o caminhão.
- **Criatura:** Caipora (e a vara de caititus).
- **Ensina:** caça tem preço (comer bicho atrai a Caipora), dirigir o caminhão.
- **Virada:** na ruína do barracão de 1877 o Encosto lembra de onde veio. Um recado de Dorinha
  no bornal confirma: "Ele é a fome dos que morreram ali." E o Encosto entende que o Coronel
  Velho ainda está "em casa".
- **Escolha:** o tenente.
- **Termina:** Lampião ao volante do caminhão da volante, faróis apagados, rumo à porteira da
  Jatobá.

#### `cap09-o-coronel` — Fazenda Jatobá

- **Objetivo:** entrar na fazenda, (opcional) soltar Tonho, minar a barragem, descer à cripta e
  acabar com o Coronel Velho, encarar Teotônio.
- **Criatura:** Coronel Velho Valadares, corpo-seco ancião (chefe final); capangas e o resto
  da volante.
- **Ensina:** nada novo: é a prova de tudo.
- **Virada:** o Encosto come o homem que o fez e, pela primeira vez, fica **cheio**. Mesmo
  assim cobra o trato. A fome saciada continua sendo fome.
- **Escolha:** Tonho; o coronel; e, conforme os medidores, a da cova.
- **Termina:** a barragem explode, a água desce para a ribeira seca, o Encosto cobra o corpo
  e o final é decidido pelos medidores.

---

## Fluxo de flags para programação

```
benedito      : poupado | comido
oferenda      : sim | nao
liberato      : perdoado | comido | morto
biu           : salvo | perdido
papafigo      : comido | morto
vizinhos      : abrigados | fora
rosalia       : livre | comida
damiao        : curado | morto
tenente       : poupado | comido | morto
tonho         : livre | preso
coronel       : encosto | bala | povo
marca         : int 0..6
graca         : int 0..6
folhetos      : int 0..9   (colecionável de cordel, um por capítulo)
```
