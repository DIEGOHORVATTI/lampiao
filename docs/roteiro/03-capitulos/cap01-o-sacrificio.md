# Capítulo 1 — O Sacrifício (`cap01-o-sacrificio`)

Adapta o episódio 1 do quadrinho ("Lampião", 38 págs., `docs/referencias/tapas-2173018/`).

| | |
|---|---|
| **Noite** | noite 1, lua cheia (prólogo no começo da noite, o resto de madrugada, fim no nascer do sol) |
| **Local** | Fazenda do Coronel (prólogo) e Caverna dos Ídolos (mapa em `04-mapas.md`, cap. 1) |
| **Duração** | 16–18 min |
| **Objetivo** | fugir da fazenda com o dinheiro; sobreviver à traição; sair da caverna; enterrar o bando |
| **Inimigos** | volante do Coronel (soldados); Vini (duelo). Comida dela: os soldados que a história entrega e os restos deles |
| **Ganha** | rifle e peixeira (desde o início), pistola (revólver de soldado), o terço de Maria; poderes Tentáculos e Comer |
| **Começa com** | vida 100, sem medidor de fome (a barra só aparece quando Ela acorda, beat 8; ao fim do beat 9 a fome está em 50) |
| **Folheto** | "O Rifle que Alumiava a Noite" (no bornal de Xexéu) |

## Cartão de abertura

Narração de Lampião, letra branca em fundo preto (do quadrinho, E1 02–03):

> Nordeste do Brasil, 19XX.
>
> Somos justiceiros errantes.
> Bandidos por necessidade.
> Nós ajudamos aqueles que necessitam,
> tirando daqueles que têm até demais.
>
> Somos cangaceiros.

## Telas de carregamento do capítulo

Imagem em preto chapado e retícula, legenda curta embaixo. Ordem de sorteio livre.

| Referência | Imagem | Legenda |
|---|---|---|
| `tapas-2173018/21.jpg` | a degola: cabeça rodando, olhos brancos, jato preto | "O Coronel paga por cabeça." |
| `tapas-2173018/25.jpg` | Ela saindo do coto do pescoço, o Coronel com a cabeça na mão | "Por séculos eu estive sepultada." |
| `tapas-2173018/28.jpg` | Ela mastigando um soldado | "Eu tô faminta." |
| `tapas-2173018/23.jpg` | a cabeça no chão, tiro em silhueta | "Vai ficar bom numa estaca." |

---

## Beats

### 1. O assalto (jogável, 3–4 min) — Zona Z1, Fazenda do Coronel

- **Luz:** lua cheia enorme sobre a casa-grande. Dentro da casa, só os candeeiros de parede
  (luz de cenário, fraca, laranja). Fora, a lua e o clarão dos tiros.
- Lampião começa na **sala do cofre** da casa-grande, rifle na mão, com chapéu de couro de
  três medalhões. O cofre está aberto. **Baraúna** enche um saco de moedas. **Xexéu** vigia a
  janela. **Maria** está na porta do corredor, de rifle.
- **Tutorial:** olhar, andar, agachar. Aviso: "Pegue o saco" (interação). O saco de moedas vai
  para as costas de Lampião.
- Um soldado da volante entra pela porta da frente, **desarmado** (o fuzil ficou encostado lá
  fora), e se joga no chão de mãos para o alto. É **Benedito**, menino de farda grande demais.

> **BARAÚNA:** (apontando o rifle) Tu tá morto, desgraça!
> **LAMPIÃO:** Ele tá desarmado! Tamo aqui pela grana, não pela matança. Para de perder tempo!

- O jogador **pode** atirar em Benedito. Se atirar: Maria grita "Lampião!" e olha para ele
  como quem não conhece; `fazenda_benedito=morto`. Se não atirar (o padrão):
  `fazenda_benedito=poupado`. Nenhum medidor muda; é só memória para o beat 8.
- Lá fora, apito e gritos. **SOLDADO** (de fora): "Ali estão eles, não os deixem fugir!"
  **CAPITÃO DA VOLANTE:** "FOGO!"
- **Tutorial de tiro:** a parede da sala vira peneira. Lampião responde da janela. Cada tiro
  do rifle **acende a noite** por um instante: o clarão ilumina o terreiro inteiro (raio de
  ~14 m por 0,15 s) e mostra os soldados agachados atrás da cerca de arame farpado. Os
  soldados também veem Lampião no clarão. Aviso na tela: "O clarão do tiro mostra o
  caminho. E mostra você."
- **SOLDADO** (gritando do terreiro, depois do terceiro tiro do jogador): "É ele! É o
  Lampião! Olha o clarão!"
- **MARIA:** "Rápido, pelos fundos! Vamo depressa!"
- **Jogável:** corredor, cozinha, porta dos fundos, terreiro de trás. Tiros pela janela da
  cozinha. Os soldados avançam pelo lado da capela.
- **Roteirizado (no terreiro de trás, gatilho g1):** um soldado aparece na quina da capela e
  mira em Lampião. Maria se joga na frente. O tiro pega no ombro dela. Sangue preto
  respinga na parede caiada.

> **LAMPIÃO:** Maria?!
> **LAMPIÃO:** Querida, o que tu fez? Tu tá bem?
> **MARIA:** (dente trincado) Urgh! Não podemos parar, vamo reto!
> **XEXÉU:** Tão com o Vini, bem ali!
> **LAMPIÃO:** Onde que tão os cavalo?

- Maria abre a mão. O **terço** de contas escuras com crucifixo brilha na luz da lua:

> **MARIA:** Não se preocupa. Eu sou abençoada, lembra?

- **Jogável:** os últimos 30 m até a porteira do arame farpado, onde **Vini** segura os
  cavalos. O jogador cobre a fuga atirando (Maria vai apoiada em Baraúna). Ao chegar a 3 m
  dos cavalos, corte.

### 2. A fuga (cena a cavalo, 40 s) — sem mapa

- Primeira pessoa a cavalo, galope, lua cheia, caatinga em silhueta. Tiros ficando para trás.

> **VINI:** Eu conheço um lugar seguro! Apenas me sigam!
> **BARAÚNA:** Precisamos parar em algum lugar. Não podemos seguir viagem com Maria nesse
> estado!
> **LAMPIÃO:** Vai ficar tudo bem!

- Corte para a trilha entre paredões de pedra. Pilares tortos de pedra lavrada na entrada
  (o jogador vê, mas ninguém comenta).

> **VINI:** Chegamos. Podemos passar pelo menos essa noite aqui.

### 3. O acampamento (exploração livre, 2–3 min) — Zona Z2, boca da caverna

- **Luz:** a fogueira do bando (checkpoint) e a lua na boca da caverna. O fundo da caverna é
  preto.
- O controle volta. Os cavalos ficam amarrados lá fora. Ninguém tem pressa; o jogador pode
  conversar com cada um (interação "Falar"):
  - **Xexéu** (despejando o saco na pedra, moeda para todo lado): "Caramba! Esse calote foi do
    Pipoco. Olha toda essa grana!"
    **LAMPIÃO:** "Nem adianta ficar muito animado não. Temos planos pra toda essa bufunfa,
    lembra?"
  - **Baraúna** (moeda na mão): "Essas taxa vão de volta pras comunidade que pagaram.
    Começando pela comunidade de Maria." / "Daí o que sobrar, a gente compra comida e
    suprimento."
  - **Vini** (mexendo o caldeirão, assoviando): "Sopa de bode, Capitão. Do jeito que tua mãe
    fazia, só que melhor." Ele não olha nos olhos.
  - **Maria** (deitada na manta, ombro amarrado com pano): ver abaixo.
- **Maria e o terço** (obrigatório para avançar):

> **MARIA:** Vem cá. Segura isso pra mim enquanto eu durmo.
> **LAMPIÃO:** Teu terço? Tu num larga isso nem pra tomar banho.
> **MARIA:** Tu num é abençoado, mas eu te empresto. Amanhã tu me devolve.
> **LAMPIÃO:** Amanhã eu te devolvo.
> **MARIA:** Tu acende a noite toda vez que atira, sabia? O povo te chama de Lampião por
> isso. Eu chamo de besta.

- O terço vai para o pulso de Lampião (fica visível no braço esquerdo em primeira pessoa
  pelo resto do jogo).
- **Pressentimento (opcional):** no fundo do salão, onde a luz da fogueira mal chega, um
  rosto de pedra de boca aberta. Interação "Olhar": a câmera aproxima, o jogador ouve uma
  respiração que não é de ninguém do bando. Nada acontece.
- **A sopa:**

> **VINI:** Pessoal, sopa tá pronta!
> **BARAÚNA:** Orra, que sopa deliciosa. Tu tem uns talento escondido, Vini.
> **VINI:** Hahah, que nada, home. Agora descansem. Vou passar a noite na vigia.
> **VINI:** (já na boca da caverna, de costas) Tenham um bom descanso.

- Interação "Tomar a sopa" na cuia que Vini deixa ao lado de Lampião. A tela escurece.

### 4. O sonho e o veneno (cena + jogável, 3 min) — Zona Z2

- **Sonho (15 s):** céu preto, estrelas, a lua cheia enorme. A lua **abre um olho**: íris
  clara, pupila em fenda. Ela olha para o jogador. Corte.
- Lampião acorda sentado, com a mão no peito. Respiração curta, gosto de ferro na boca.

> **LAMPIÃO:** Q-que mizera de pesadelo foi esse? M-Maria...

- A câmera desce: Maria de boca aberta, **espuma branca escorrendo** pelo queixo, os olhos
  revirados. Baraúna caído de lado na mesma espuma. Xexéu com a cuia ainda na mão.

> **LAMPIÃO:** Maria?! Que porra é essa?

- **Jogável (veneno):** Lampião anda devagar, a visão ondula, a mira treme. Ele não morre
  porque comeu menos (o jogador vê a cuia dele pela metade). Aviso: "Levantar Maria".
- Ao tentar, ela agarra o pulso dele (o do terço):

> **MARIA:** (quase sem voz) Vai... Eu sou abençoada, lembra? Volta pra mim.

- Lá fora: cascos, muitos. Os cavalos do bando relincham e disparam. Lua na boca da caverna.
  Silhuetas a cavalo contra ela. Quepe, medalhas, revólver para cima.

> **XEXÉU:** (morrendo, com o dedo na direção da boca) É o Coronel...
> **CORONEL:** (de fora, a cavalo) Tu vai se arrepender de roubar de mim, fi duma rapariga!
> **LAMPIÃO:** Cacete! Como eles acharam a gente aqui?

- **Jogável (tiroteio curto):** a volante atira da boca da caverna. A fogueira mostra
  Lampião, e o jogador aprende a **apagar a fogueira** com terra (interação, 1 s). No escuro,
  só os clarões: o dele e o deles. Dois soldados entram, e o jogador pode derrubar os dois.
- **Vini** aparece no fundo do salão, com um **facho** (tocha de pau e trapo com breu) na
  mão. Ele está suado e limpo de espuma.

> **VINI:** Por aqui! Tem outra saída!
> **LAMPIÃO:** A gente num tem escolha...

- Ao entrar no túnel atrás de Vini, gatilho g2: rolam pedras atrás deles e a boca do túnel
  fecha **em parte** (os soldados ainda passam, um de cada vez).

### 5. A galeria (jogável, 2–3 min) — Zona Z3

- **Luz:** só o facho de Vini, 4 m à frente. Se o jogador ficar para trás, fica no escuro.
  Soldados vêm atrás com tochas; atirar neles acende o túnel e revela os dois.
- As paredes têm **nichos** cavados na pedra, cheios de ossada antiga e de cacos de pote, com
  rostos de pedra de boca aberta entalhados em cima, como os dos ídolos. Só cenário.
- **Susto !4 (vulto):** no fim do túnel, além da luz do facho, uma figura de pé, muito alta,
  com dois olhos brancos. Quando o jogador olha direto, não tem nada. Vini não viu.
- **Encontro E1:** dois soldados alcançam os dois na curva. Combate curto com o rifle.
- **Sussurro (sem legenda de personagem, só texto entre colchetes):** "[uma voz de mulher,
  muito longe, no fundo do túnel: ...fome...]"
- Depois do E1, um segundo desmoronamento fecha a galeria de vez atrás dos dois (`^`). Não
  há volta para Maria por ali.
- Na entrada do salão, Vini para, ofegante.

> **VINI:** Acho que despistamos eles.
> **VINI:** E-eu preciso parar...
> **LAMPIÃO:** Isso tudo parece muito conveniente, tu num acha, Vini?
> **VINI:** O-o que o senhor quer dizer?

### 6. A traição (cena + duelo, 2 min) — Zona Z4, Salão dos Ídolos

- **Luz:** um buraco no teto, a 12 m de altura, deixa cair uma coluna de lua no meio do salão.
  Em volta, seis totens de pedra com rostos de boca aberta e dentes. No centro, uma laje
  enorme entalhada, rachada no meio. O facho de Vini está no chão, fumaçando.

> **LAMPIÃO:** Que lugar é esse?

- Vini levanta o rifle e aponta para as costas de Lampião. Chora.

> **VINI:** Me desculpa...
> **LAMPIÃO:** ...?
> **VINI:** Tu não faria o mesmo por Maria?
> **LAMPIÃO:** Nem se atreva a falar o nome dela!
> **VINI:** Eu... eu não tive escolha. Eles pegaram a minha família. Ameaçaram matar meus
> pais, minha esposa... minha filha!

- **Duelo (jogável, 30–60 s):** o rifle de Lampião está vazio (o jogador acabou de usar o
  último pente na galeria; se ainda tiver bala, Vini dá a coronhada antes e o rifle voa para
  longe). Só a **peixeira**. Vini dá um tiro (erra; o clarão mostra os totens) e depois vem na
  coronha. Tutorial: "Desvie e golpeie". Dois golpes de peixeira em Vini.
- No segundo golpe, a peixeira abre o rosto de Vini de orelha a boca. Vini cai de joelho,
  segurando a cara, e o jogador ouve **um passo atrás**.

### 7. A degola (cena em primeira pessoa, 30 s)

- **Sem corte.** Um braço de farda passa pela frente da câmera. O fio da faca entra pelo
  lado do pescoço. Som de couro rasgado e de osso.
- **A cabeça cai.** A câmera vai junto: roda no ar, o mundo dá duas voltas (céu do buraco,
  totens, chão, de novo). Os óculos voam. **A lente direita racha** (a partir daqui, a
  rachadura aparece como um risco fino no canto direito da tela pelo resto do jogo).
- Do chão, de lado: o próprio corpo de Lampião ainda de pé, sem cabeça, um **jato de sangue
  preto** subindo do coto e caindo em gotas grossas. O corpo cai de joelho.
- Uma mão pega a cabeça pelo cabelo e levanta. O rosto do **Coronel** enche a tela: quepe,
  cavanhaque, medalhas, a faca pingando preto.

> **CORONEL:** Vai ficar bom numa estaca.

- A câmera (a cabeça, pendurada) gira devagar e mostra Vini de joelhos.

> **CORONEL:** Belo trabalho, traidor. Vi todos os corpos. Tu é um assassino implacável,
> haha.
> **VINI:** O senhor vai liberar minha família agora? Eu fiz tudo que pediu.
> **CORONEL:** Ha. Tu pensou que eu ia deixar tu ir embora na boa? Tua família tá morta desde
> que tu saiu em missão.
> **VINI:** Eh...?

- O Coronel corta a garganta de Vini sem olhar para ele. O sangue espirra na laje rachada
  do centro. Os olhos dos seis totens **brilham** brancos, um de cada vez.
- Voz de mulher, vinda de todo lugar, calma, com eco de pedra:

> **ELA:** Por séculos eu estive sepultada...
> **CORONEL:** Quê?
> **ELA:** Mas agora que o sacrifício foi feito... dentro do receptáculo oferecido... eu
> posso renascer mais uma vez.
> **CORONEL:** (olhando para trás) Cadê o corpo de Lampião?!

- A cabeça (a câmera) vê o corpo sem cabeça se levantando atrás do Coronel. Do coto do
  pescoço sobe uma massa preta. Corte para preto.

### 8. Ela (jogável, 2 min) — Zona Z4, "Modo Ela"

- **O jogador agora é Ela**, no corpo sem cabeça. A câmera fica na altura do coto (1,5 m),
  com lente olho-de-peixe leve, o mundo em tons de cinza e o sangue em preto. Na borda da
  tela, a sombra dos tentáculos se mexendo. O jogador vê a própria forma de relance nas
  sombras do chão: um olho gigante e venoso, uma boca em arco cheia de dentes compridos,
  tentáculos pretos grossos cobertos de olhinhos brancos.
- **SOLDADOS:** "FOGO!" Os tiros entram no corpo e não fazem nada.

> **ELA:** Infelizmente não sei nem quem são vocês... mas eu agradeço pelas oferendas.
> **ELA:** Ainda não estou completa. Mas só de estar livre é fantástico.

- **Tutorial de Tentáculos:** "TENTÁCULOS: agarre de longe". O tentáculo atravessa um
  soldado pelo peito e o levanta (empalamento em primeiro plano, sangue preto escorrendo pelo
  tentáculo até a câmera). **Tutorial de Comer:** "COMER" com o soldado erguido: a boca fecha
  sobre ele. Som de osso e mastigação. Fica a metade de baixo do corpo, que cai.
- Aparece a barra **FOME**, cheia (100) e piscando. Em Modo Ela cada soldado comido baixa
  12: depois dos quatro, ela fica em torno de 50. Séculos de fome não se matam numa noite.

> **ELA:** Eu tô faminta!

- O **Coronel** dá três tiros de revólver no olho, larga a cabeça de Lampião no chão e foge
  pela galeria sem olhar para trás.

> **SOLDADO:** Coronel?! Coronel!

- **Encontro E2:** quatro soldados abandonados. O jogador come os quatro (ou os tentáculos
  matam e ele come os corpos depois). Um quinto, **Benedito** (ou um soldado sem nome se
  `fazenda_benedito=morto`), foge pela fenda leste (Z5) gritando. O jogo não deixa o jogador
  segui-lo: os tentáculos não alcançam.
- Quando o último cai, o olho se vira para a cabeça de Lampião no chão.

> **ELA:** E essa cabecinha aí? Tem cara de sobremesa.

- Um tentáculo vai até a cabeça. Nesse momento, **o punho do corpo, fechado sobre o terço de
  Maria, começa a brilhar.** Raios brancos entre os dedos. Ela grita (som agudo e grave ao
  mesmo tempo, a tela treme). Clarões de memória por cima de tudo, meio segundo cada: Maria
  rindo a cavalo; Maria com um bode no colo; Maria com um feixe de flor do mato; Maria de
  olho fechado.
- Os tentáculos se recolhem para dentro do pescoço como se fossem puxados. A cabeça é
  arrastada pelo chão até o corpo. Branco total.

### 9. Nós (cena, 75 s) — Zona Z4

- Volta em primeira pessoa, deitado. Lampião levanta as mãos na frente do rosto. O terço
  continua no pulso.

> **LAMPIÃO:** Eu... eu estou vivo...?

- Ele leva a mão ao pescoço: **costura em X** em volta dele inteiro, linha preta grossa. Ao
  lado, Vini morto, de olho aberto, o pescoço aberto. Restos de soldado por todo o salão.
- Ela fala **de dentro do pescoço**. A partir daqui o olho dela abre na costura quando ela
  fala (o jogador vê de relance quando olha para baixo).

> **ELA:** Urgh... *Nós* estamos vivos. Eu não sei o que houve aqui, mas ainda não estou na
> minha forma completa... que maravilha.
> **LAMPIÃO:** Tu é o quê?
> **ELA:** Eu sou a dona dessa casa, Capitão. Tu é que entrou sem bater.
> **LAMPIÃO:** Eu... entendo.
> **ELA:** Entende nada. Você só tá andando por causa de mim, tá bom? Eu só preciso arranjar
> mais comida e te deixo descansar em paz.
> **LAMPIÃO:** E se eu num quiser?
> **ELA:** Aí tua cabeça cai de novo. E dessa vez sem eu pra segurar.

- **Pistola:** no chão, entre os restos de um soldado, um **revólver** e uma caixinha de
  balas. Interação "Pegar". O rifle está jogado perto de Vini, com um pente no bornal dele
  ("Pegar o rifle").
- **Escolha pequena (sem medidor):** "Fechar os olhos de Vini" ou deixar. Se fechar,
  `vini=perdoado`. Se não, `vini=largado`. Lampião não fala nada nos dois casos.
- O caminho de volta pela galeria está fechado pelas pedras (beat 5). A saída é a **fenda
  leste**, por onde Benedito fugiu. Uma corrente de ar frio vem de lá.

### 10. A fenda (jogável, 4 min) — Zonas Z4 → Z5

- **Carniça (tutorial de Comer cadáver):** o salão está cheio dos restos dos soldados que Ela
  comeu (metades, pernas, um quepe ainda na cabeça). Aviso "COMER" num deles: o pescoço abre, a
  boca dela morde, a visão desce e sobe. Fome −30, vida +15.

> **ELA:** Morto de pouco. Ainda tá quente.
> **LAMPIÃO:** Tu disse carne podre.
> **ELA:** Tu disse. Eu como o que tiver.

- Ao passar pela laje rachada, gatilho g3. **Susto !7 (respiracao):** uma respiração enorme
  vem de debaixo da laje, lenta, e para quando Lampião para. Ela fica calada.
- **Encontro E3 (salão):** dois soldados voltam pela fenda com tochas, mandados de volta:
  **SOLDADO:** "O Coronel quer a cabeça! Sem a cabeça ninguém recebe!" Peixeira, rifle,
  revólver, Tentáculos. Os corpos viram carniça.
- **A fenda (Z5):** corredor estreito que sobe em rampa para a superfície, 2 m de largura,
  nichos de ossada dos dois lados. Escuro total, a não ser pelos clarões e por um **facho**
  largado pelos soldados no começo da fenda (o jogador pode carregar o facho na mão esquerda no
  lugar de arma; ele ilumina 5 m e dura 90 s).
- **Tutorial do terço:** quando a fome passar de 75 pela primeira vez (ou no gatilho g4, o
  que vier antes), aviso: "Segure o TERÇO para acalmar a fome." Segurando, a fome desce e os
  poderes ficam desligados.

> **ELA:** Irch... sério que você vai usar isso aí?

- **Encontro E4 (fenda):** quatro soldados entrincheirados nas curvas da fenda, atrás de
  pedras, com tochas fincadas no chão. Cada tiro do jogador acende a fenda e os mostra; cada tiro
  deles mostra o jogador. Apagar as tochas a tiro deixa os soldados no escuro. Os mortos são
  carniça.

### 11. Benedito (escolha, 60 s) — Zona Z5, nicho largo

- Num nicho largo perto do topo da fenda, um gemido. **Benedito**, encolhido, a perna presa
  entre duas pedras que caíram. A farda está molhada de mijo e de sangue dos outros. Quando o
  clarão ou o facho bate nele:

  Se `fazenda_benedito=poupado`:

> **BENEDITO:** Capitão... É o senhor? O senhor me poupou na fazenda. Duas vez num é pedir
> muito?
> **LAMPIÃO:** Tu tava com quem me degolou.
> **BENEDITO:** Eu num sabia, Capitão. O Coronel disse que era só pegar o dinheiro de volta.
> Eu tenho dezenove ano...
> **ELA:** Olha que coisa. Novinho. Carne de menino é macia, Capitão. Abre o pescoço, que eu
> faço o resto.
> **BENEDITO:** (ouvindo só a respiração de Lampião) Com quem o senhor tá falando?

  Se `fazenda_benedito=morto`, quem está no nicho é um **soldado sem nome**, de meia-idade.
  As falas são as mesmas, menos a primeira, que vira: "**SOLDADO:** Pelo amor de Deus,
  Capitão. Eu tenho filho."

- **Escolha** (avisos na tela):
  - **Guardar a peixeira** → Lampião empurra a pedra com o ombro; os tentáculos ajudam por
    baixo do casaco, estalando. Benedito se arrasta e some pela fenda acima.
    **LAMPIÃO:** "Corre. E conta pra todo mundo o que tu viu."
    **ELA:** "Tu vai se arrepender de cada um que tu solta, Capitão. Cada um."
    `benedito=poupado`
  - **Deixar ela comer** → a costura abre (a visão desce um palmo, como se a cabeça tombasse
    para trás). O grito vira um som molhado. Dois segundos de mastigar no preto. Volta: o
    nicho vazio e respingado. Fome zera, vida cheia.
    **ELA:** "Tá vendo? Gente enche."
    Marca +1, `benedito=comido`
- Sem escolha em 30 s: a fome sobe 10 e Ela repete, mais baixo: "Tô esperando, Capitão."

### 12. Maria (cena, 90 s) — Zona Z6, lado de fora, voltando à boca da caverna

- A fenda sai num lajedo a leste da boca da caverna. O céu já está cinza-azulado. O jogador
  anda pelo lajedo até a boca (40 m). No caminho, cascos de cavalo marcados no chão e cartucho
  vazio: a volante foi embora.
- Dentro, a fogueira apagada. Baraúna e Xexéu mortos na espuma seca. Maria encostada na
  pedra, onde ele a deixou.

> **LAMPIÃO:** Nada foi um sonho...
> **LAMPIÃO:** Maria!

- Ela respira. Ele a pega no colo (a câmera desce, os braços dele em volta dela).

> **LAMPIÃO:** Tu é abençoada, lembra? Acorda!
> **LAMPIÃO:** Maria, meu amor, tu precisa acordar... por favor!
> **MARIA:** (olho meio aberto, vendo a costura) Tu... voltou.
> **MARIA:** Fica com ele. Ele cuida de tu agora.

- Ela fecha a mão dele sobre o terço. Morre. A cabeça dela cai para o lado.

> **LAMPIÃO:** Meu amor... me desculpa... me desculpa.

- Ela, dentro do pescoço, não fala nada nessa cena. O jogador só ouve, bem baixo, a
  barriga dela roncar, e um "shhh" que não é de ninguém.

### 13. O enterro (jogável curto + cena, 2 min) — Zona Z6

- Sol nascendo atrás da serra. A árvore seca no alto do lajedo, mandacaru, pedra.
- Interação "Cavar" em três covas marcadas no chão de areia (cada uma: segurar 3 s; corte
  para a cova pronta com o corpo dentro e a terra jogada). Maria, Baraúna, Xexéu.
- **Quarta cova (opcional):** "Cavar para Vini". Se o jogador fizer, Lampião volta e traz o
  corpo de Vini (corte) e o enterra um pouco afastado. `vini=enterrado` (vale mais que
  `perdoado` ou `largado`).
- Diante das covas (fala de Lampião, sem resposta):

> **LAMPIÃO:** Meus companheiros...
> **LAMPIÃO:** Obrigado por tudo que fizeram por mim.

- Ele tira o chapéu de três medalhões e o pendura na cruz de Maria (o chapéu fica ali; ele
  não usa mais chapéu no jogo). Tira o terço do pulso e passa pelo pescoço, por cima da
  costura.

> **ELA:** Irch... sério que você vai usar isso aí no pescoço?
> **ELA:** Er... eu não quero interromper, mas tô precisando bater um rango.
> **LAMPIÃO:** Aguenta um pouquinho, que em troca...
> **LAMPIÃO:** Aquieta o facho. Tu vai ter o que comer.

- O sol sobe. Câmera olhando para o horizonte, rifle nas costas.

> **LAMPIÃO:** Eu vou te matar, Coronel!
> **ELA:** Bleh.
> **LAMPIÃO:** Eu vou te dar todas as carnes podres que eu achar no caminho.

- Preto. Cartão: "Fim do capítulo 1 — O Sacrifício".

---

## Textos de ambiente

**Livro-caixa do Coronel** (aberto na mesa da sala do cofre, Z1):
> Recebido dos meeiros do Riacho Fundo, a título de proteção: 4 contos.
> Recebido da comunidade do Poço Branco, idem: 2 contos e 300.
> Recebido da viúva Inês, a terra do finado, por dívida: 1 sítio.

**Bilhete no bolso de Vini** (Z4, só se o jogador revistar o corpo; letra tremida, a lápis):
> Vini. Tua mulher e tua menina tão com a gente. Leva eles pra caverna das pedra de cara.
> Veneno vai junto com esse bilhete. Se tu não fizer, nós faz.

**Inscrição na laje rachada** (Z4, entalhe sem letra: só desenhos. Interação "Olhar"):
> [um olho grande com raios. Embaixo, ondas. Pessoas pequenas carregando peixes até o olho.
> Uma figura peluda, de pé, com uma pedra na mão, por cima do olho.]

**Folheto de cordel** (bornal de Xexéu, Z2): "O Rifle que Alumiava a Noite" (capa em
xilogravura: um cangaceiro atirando e um clarão que ilumina uma serra inteira). Primeira
estrofe, lida em voz alta por Lampião se o jogador abrir:
> Na serra do Poço Branco
> a volante se escondeu.
> O Capitão deu um tiro,
> a noite inteira acendeu.
> Quem tava atrás da pedra
> viu a pedra e não correu.

---

## Sustos (resumo para o level design)

Tipos (ferramentas que o jogo já tem): **jumpscare** (rosto em tela cheia), **vulto** (figura na
visão periférica que some quando se olha), **passos**, **batida**, **sussurro**, **respiracao**
(som atrás do jogador), **apagao** (as fogueiras e tochas próximas apagam juntas). Posições em `04-mapas.md`, cap. 1.

| # | Zona | Tipo | Gatilho | O que acontece |
|---|---|---|---|---|
| !1 | Z2 | vulto | olhar o ídolo do pressentimento (−10, 14) e virar para a fogueira | uma figura de pé atrás de Vini, na borda da luz; some quando o jogador olha |
| !2 | Z2 | jumpscare | acordar do sonho (beat 4) | o rosto de Maria em tela cheia, espuma branca saindo da boca, olho revirado; 0,4 s |
| !3 | Z2 | apagao | o Coronel chega na boca (beat 4) | o vento da boca apaga a fogueira do bando de uma vez (se o jogador não tiver apagado antes); só os clarões |
| !4 | Z3 | vulto | (−6, 36), além da luz do facho de Vini | figura alta de olhos brancos no fim do túnel; some quando o jogador olha |
| !5 | Z3 | sussurro | (−2, 46) | voz de mulher no ouvido esquerdo: "...fome..." |
| !6 | Z4 | respiracao | cabeça caída (beat 7), antes da voz | respiração enorme, de bicho, vinda de debaixo da laje |
| !7 | Z4 | respiracao | passar pela laje depois do beat 9 (g3) | respiração enorme debaixo da laje, que para quando Lampião para |
| !8 | Z5 | passos | 10 s depois de pegar o facho (16, 78) | passos de pé descalço atrás do jogador, parando quando ele para |
| !9 | Z5 | jumpscare | iluminar o nicho (27, 54) com o facho | rosto de **soldado comido** em tela cheia: metade do rosto, olho aberto, quepe; o corpo foi arrastado até ali |
| !10 | Z5 | batida | perto do nicho de Benedito (31, 24) | três batidas de dedo na pedra, devagar; é Benedito pedindo socorro, mas o jogador não sabe |
| !11 | Z6 | vulto | olhar a árvore seca durante o enterro (beat 13) | por um instante, Maria de pé ao lado da árvore, de chapéu; some |

## Encontros de combate

| # | Zona | Inimigos | Notas |
|---|---|---|---|
| E0 | Z1 | 6 soldados em pontos fixos, atirando | tutorial de tiro e clarão; não é preciso matar todos, é preciso chegar aos cavalos |
| E1 | Z2/Z3 | 2 soldados na boca + 2 na curva da galeria | Lampião envenenado: mira com tremor |
| D | Z4 | Vini (duelo) | só peixeira; 2 golpes |
| E2 | Z4 | 4 soldados (Modo Ela) | tutorial de Tentáculos e Comer; tiro não fere Ela |
| E3 | Z4 | 2 soldados com tocha, vindos da fenda | os corpos viram carniça |
| E4 | Z5 | 4 soldados entrincheirados nas curvas, com tochas fincadas | tutorial do terço; apagar tocha a tiro deixa o soldado no escuro |

## Escolhas

| Momento | Opções | Flag | Medidor |
|---|---|---|---|
| Beat 1, Benedito desarmado | atirar / não atirar | `fazenda_benedito=morto/poupado` | — |
| Beat 9, Vini | fechar os olhos / deixar | `vini=perdoado/largado` | — |
| Beat 11, Benedito preso | **Guardar a peixeira** / **Deixar ela comer** | `benedito=poupado/comido` | Marca +1 se comido |
| Beat 13, quarta cova | cavar para Vini / não | `vini=enterrado` | — |

## Ganchos

- `benedito=poupado`: Benedito conta na estrada que "Lampião levantou sem cabeça"; no cap. 2
  Antônio já ouviu o boato.
- O chapéu de três medalhões fica na cruz de Maria.
- As flags do cap. 1 ficam salvas para o "Lampião 2".
