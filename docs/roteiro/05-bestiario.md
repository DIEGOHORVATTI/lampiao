# Bestiário

Cada ficha traz: **origem folclórica** (a lenda real), **versão no jogo**, **IA** nos termos do
template (patrulhar → perceber → perseguir → atacar), **fraqueza**, **som** e **o que Ela ganha**
ao comer.

## Como ler a IA

O inimigo base (`common/enemy/enemy.gd`) faz: parado/patrulha → vê o jogador dentro de
`vision_range` → persegue por `chase_time` → ataca dentro de `attack_range`. As fichas dão
valores para esses `@export` e marcam com **🆕** o que precisa ser programado além do template.

Força: o corpo-seco é a unidade (3 tiros de pistola). "Vida 3T" = aguenta 3 tiros de pistola.
Rifle = 2 tiros de pistola. Peixeira = 1 tiro, silenciosa. Tentáculos = mata corpo-seco e gente
na hora; em chefe, 2 tiros.

## Regras gerais

- **Clarão:** todo inimigo com linha de visão vê o jogador no instante do tiro, a qualquer
  distância até 40 m. Tiro também acorda corpo-seco a 25 m.
- **Do escuro dela** (o terço faz recuar a 4 m): Corpo-Seco, Batatão, Papa-figo (depois de
  revelado).
- **Da mata** (o terço não faz nada; só oferenda): Comadre Fulozinha, Caipora.
- **Da sina do Velho** (o terço só atrasa 2 s; prata fere; Ela não digere): Lobisomem, o Velho.
- **Gente** (volante, irmãos, multidão, capangas, o Coronel): o terço não faz nada; Ela só come
  gente nas escolhas ou em cenas roteirizadas.

## Tabela rápida

| Criatura | Caps. | Vida | Velocidade | Visão | Pode comer? | Fome | Ganho |
|---|---|---|---|---|---|---|---|
| Corpo-Seco | 1–10 | 3T | lenta | 10 m (clarão: 40 m) | sim | −30 | vida +15 |
| Batatão | 2 | — (some com tiro, volta) | média | atraído por tiro | não | — | — |
| Comadre Fulozinha | 4 | — | — | onipresente na mata | não | — | — |
| Lobisomem (Ciro) | 6–7 | 30T (chefe) | muito rápida | 20 m, faro | **não** (enjoo) | — | Boca elástica (só nele), depois Vômito |
| Caipora | 8 | — | — | onipresente | não | — | — |
| Caititu | 8 | 2T | rápida, em vara | 8 m | sim (bicho) | −40 | atrai a Caipora |
| O Velho | 3, 6, 8, 10 | só prata (4 acertos) | muito rápida | 25 m, faro | só no fim (escolha) | zera e **completa** | finais B/C |
| Papa-figo | 9 | 8T | média, emboscada | 6 m no escuro | sim (gente) | zera | Marca +1 |
| Soldado da volante | 1, 9, 10 | 2T | normal | cone de lanterna 14 m | só em cena | −12 (Modo Ela) | — |
| Antônio e Marconi | 2–3 | 4T cada | normal | 16 m | só em cena (roteirizado) | zera | — |
| Multidão | 5 | não-alvo | lenta | — | só Zeca (escolha) | zera | — |
| Capanga | 10 | 2T | normal | 12 m | não | — | — |
| O Coronel | 1, 10 | corpo fechado; aberto: 6T | normal | 20 m | escolha | zera | — |

---

## Corpo-Seco

**Origem folclórica.** Lenda do interior do Sudeste e do Centro-Oeste, contada também no
Nordeste: o homem tão ruim em vida que nem Deus nem o Diabo quiseram, e **a terra cuspiu o
corpo**. Ele seca sem apodrecer, pele de couro grudada no osso, e fica na beira da estrada atacando
quem passa.

**No jogo.** Os primeiros são os **servos dela**, secos de joelhos nos nichos da Caverna dos
Ídolos há séculos (cap. 1). Quando Ela acorda, eles levantam, e com eles levantam os outros secos
do sertão: os enterrados fora do muro, os mortos que a terra não quis. Todos sentem a fome dela e
vão atrás dele, sem saber que é ela lá dentro ("Tu tem cara de comida pra eles"). São a carniça do
jogo. Pele de couro escuro rachado, sem lábio, dentes à mostra, olhos com um ponto branco pequeno
(igual ao dos totens), visível de longe no escuro. Os servos da caverna têm a boca aberta para
cima como os ídolos. Modelo `undead` do template.

**IA.**
- Patrulhar: parado perto do nicho ou da cova; alguns agachados comendo bicho morto.
- Perceber: `vision_range` 10 m; vê no clarão a até 40 m; ouve tiro a 25 m.
- Perseguir: `move_speed` 1.0, `chase_time` 8 s; alerta em grupo a 12 m (🆕 estalo de dentes).
- Atacar: `attack_range` 1.8 m, agarrão e mordida, `attack_damage` 12.
- Não abre porta. Não entra em fogueira (raio 3 m).

**Fraqueza.** Fogo (tição mata na hora); terço (recua a 4 m); tiro na cabeça conta dobrado.

**Som.** Couro seco dobrando como sola velha; ar passando por garganta seca; quando chegam, os
grilos param.

**Ela ganha.** Fome −30, vida +15. "Bleh. Carne de mil ano. Mas engana."

---

## Batatão

**Origem folclórica.** Fogo-fátuo do Nordeste (também "boitatá" no Sul e Sudeste): uma bola de
fogo que corre de noite pelos campos e pelos cemitérios, alma penada que não achou descanso. Quem
segue o batatão se perde; quem corre dele é perseguido.

**No jogo (cap. 2).** Fogo azulado-alaranjado que imita uma **fogueira de acampamento** ao longe,
com estalo de lenha e tudo. No sertão sem lampião, o jogador só tem fogo de gente como guia, e o
batatão vive disso. Quando o jogador chega a 10 m, a "fogueira" levanta do chão e foge. Se for
seguido para fora da trilha, leva até as covas dos secos. Ensina a distinguir a fogueira de
verdade (fixa, com fumaça, com sombra de gente) da falsa (sem fumaça, sem sombra).

**IA** 🆕.
- Fica parado a 30–50 m imitando fogueira. Se o jogador se aproxima a 10 m, voa para o próximo
  ponto da rota (`o`), sempre afastando da trilha.
- Atraído por tiro: cada tiro o traz para perto (gira em volta do jogador a 6 m por 5 s, cega com
  brilho).
- Não fere. O perigo é o lugar para onde leva.

**Fraqueza.** O terço faz o batatão apagar por 20 s. Tiro o divide em dois (e o dobro de luz).

**Som.** Lenha estalando sem lenha, um assovio comprido.

**Ela ganha.** Nada. "Fogo num enche barriga, Capitão."

---

## Comadre Fulozinha

**Origem folclórica.** Pernambuco e Paraíba: espírito da mata, menina de cabelo comprido que
assovia, embaraça o caminho de quem entra sem pedir e dá surra de cipó em caçador. Gosta de fumo,
mel e mingau. Trança crina e rabo de cavalo de noite. Os cangaceiros, que viviam no mato, tinham o
costume de deixar fumo para ela.

**No jogo (cap. 4).** Nunca aparece inteira: um assovio que muda de lado, cabelo preto entre as
galhadas, cipó que se fecha na trilha. Guarda a mata em volta da Pedra de Topo Reto. Lampião
conhece o costume: "Cangaceiro que num dá fumo à Comadre num acha o caminho de casa."

**IA** 🆕 (ambiente). Com oferenda no toco: abre os cipós e guia com assovio. Sem oferenda: fecha
os cipós, gira a trilha (os marcos trocam de lugar) e dá surra de cipó (dano 10 a cada 15 s,
vindo de trás) até o jogador passar dos cipós depois de 60 s.

**Fraqueza.** Nenhuma. Não se mata a dona da mata. Ela nem tenta comer: "Essa aí eu num mordo nem
com fome. Tem gosto de folha."

**Som.** Assovio de menina; riso; cipó estalando no ar.

**Ela ganha.** Nada.

---

## Lobisomem (Ciro)

**Origem folclórica.** Ibérica, muito forte no Nordeste: o homem que vira bicho em noite de lua,
roda pelas encruzilhadas, come sujeira e ataca quem acha. Desencanta-se com um ferimento que tire
sangue (mas quem ferir não pode se sujar do sangue, senão pega a sina) ou se mata com bala de
prata.

**No jogo (caps. 6–7).** Ciro, mordido pelo Velho. Na lua cheia (que não mingua mais), vira:
duas vezes a altura de um homem, corcunda, braços até o chão, pelo preto denso, orelhas
pontudas, olhos brancos sem pupila, focinho curto e bocarra com várias fileiras de presas, ainda
de calça rasgada. Anda de quatro ou curvado, salta, atravessa parede de taipa. Diz "Filha..."
mesmo transformado. A transformação (prólogo do cap. 6) é em primeira pessoa, pelos olhos de
Helena: o rosto incha, a pele racha em veia, os dentes viram presa, osso estalando.

**IA (chefe)** 🆕.
- **Caça pelo clarão:** todo tiro do jogador faz o lobisomem virar e correr para ele. É assim que
  se tira o bicho de cima do povo (cap. 6).
- **Investida:** corre em linha reta 15 m, arrebenta o que estiver na frente (parede, cerca).
  Acerta: 35 de dano e arremessa o jogador 6 m.
- **Garra:** 20 de dano a 2,5 m.
- **Fuga:** com 30% de vida em cada fase, salta para o telhado e some 20 s.
- **Fase 1 (cap. 6):** termina roteirizada na mordida da Boca elástica.
- **Fase 2 (cap. 7):** Ela enjoada (sem Tentáculos); tição, rifle, revólver, Juliana; Vômito
  (roteirizado na primeira vez) prende 5 s; Regina e a prata terminam.

**Fraqueza.** Prata (cada bala: 25% da vida). Bala comum, fogo e tição só atrasam. O terço segura
2 s.

**Som.** Respiração de cachorro grande; osso estalando; "Filha..." rouco; uivo que faz o povo
fechar as janelas.

**Ela ganha.** Nada, e perde: morder o lobisomem dá **enjoo** (Tentáculos desligados até o fim do
cap. 7, Lampião vomita sangue preto, visão balança). "Gosto ruim. Isso é... isso é meu."

---

## O Velho

**Origem.** Do jogo, apoiado na lenda do lobisomem e no tema de "corpo fechado" do sertão. O
primeiro servo dela, que bebeu do sangue dela e virou o primeiro lobisomem. Enterrou-a, viveu
séculos, morde um homem por geração, faz pacto com coronel (corpo fechado em troca de gente).

**No jogo.** Vulto preto de olhos brancos (caps. 3 e 6, só observa); mini-chefe no cap. 8;
chefe final no cap. 10. Forma de luta: lobisomem magro e alto, grisalho, pelo falhado, braços
finos demais, rosto de velho aparecendo debaixo do pelo na luz de fogo.

**IA (chefe)** 🆕.
- **Some no escuro:** fora do clarão e da fogueira fica invisível (só os dois olhos). Aparece de
  verdade só no clarão, por isso o jogador tem que atirar para vê-lo, e o tiro o chama.
- **Agarrão:** pega Juliana se estiver a menos de 8 m dela (cap. 8 e 10): o jogador tem 6 s para
  acertar uma prata ou um tição.
- **Uivo:** levanta 3 corpos-secos das covas próximas (máx. 1 vez por fase).
- **Garra / investida:** como o lobisomem, dano +5.
- Cap. 8: foge com 2 acertos de prata ou com 90 s de luta. Cap. 10: cai com 4 acertos de prata.

**Fraqueza.** Só prata. Fogo o afasta 3 s. Terço: 2 s.

**Som.** Voz baixa de velho perto do ouvido do jogador, sempre do lado oposto ao que ele está.

**Ela ganha** (só se o jogador escolher, no fim do cap. 10). Fome zera e **some** da tela: Ela
fica completa. Decide entre os finais B e C.

---

## Caipora

**Origem folclórica.** Tupi, espalhada pelo Brasil todo: dona dos bichos do mato, montada num
porco-do-mato, protege a caça e castiga quem caça demais, embaralhando o caminho e batendo. Gosta
de fumo. No Nordeste, caçador deixa fumo no toco para ter boa caça.

**No jogo (cap. 8).** Nunca se vê inteira: o cheiro de fumo, o chocalho da vara de caititus, uma
figura baixa e peluda montada num porco do mato no limite da luz. Com Ela faminta e pouca carniça
no caminho, o jogador precisa caçar caititu, e cada bicho caçado chama a Caipora.

**IA** 🆕 (ambiente). Contador de caça: 1º caititu, nada (ou nada até o 2º se `oferenda=sim` no
cap. 4); 2º, a trilha começa a girar e a vara de caititus ataca; 3º, a Caipora em pessoa
acompanha o jogador batendo com vara (dano 8 a cada 10 s) até ele sair do mapa ou deixar fumo no
toco.

**Fraqueza.** Nenhuma. Paz só com fumo no toco.

**Ela ganha.** Nada. Nem tenta: "Essa aí é dona do mato. Nem eu mexo."

### Caititu

Porco-do-mato em vara de 3. Vida 2T, investida rápida, dente de 8 de dano. Comer: fome −40.

---

## Papa-figo

**Origem folclórica.** Recife e litoral nordestino: o velho rico e doente que só se cura comendo
fígado de criança, e paga gente para pegar menino pobre com saco nas costas. Lenda de mãe para
assustar filho, com raiz em boatos de crimes reais.

**No jogo (cap. 9).** O Doutor Anísio, médico do Coronel e dono da botica de Mossoró. Pele
amarela, olho fundo, terno branco sujo de sangue no punho, um saco de estopa. Foi ele quem
preparou a cabeça falsa da estaca. No porão da botica, um menino amarrado.

**IA.**
- Disfarçado: anda pela feira de terno, cumprimenta, oferece remédio. Não é alvo.
- Revelado (no porão): emboscada no escuro, `vision_range` 6 m, ataque com bisturi (15) e saco
  (agarra e arrasta 4 m). Vida 8T. Foge para a escada com 30%.

**Fraqueza.** Terço (depois de revelado: "o que come criança é do escuro"); fogo.

**Som.** Tosse molhada; tesoura abrindo e fechando; uma cantiga de ninar assoviada.

**Ela ganha** (escolha). Fome zera, vida cheia. Marca +1. "Fígado de doutor. Que chique."

---

## Gente

### Soldado da volante

**Origem.** Tropas policiais que caçavam cangaceiros, tão violentas quanto eles. Cangaceiro
chamava soldado de "macaco".

**No jogo.** Farda clara de manga comprida, quepe, cinto, rifle. Andam em dupla, com facho.

**IA** 🆕 (inimigo de tiro).
- Patrulhar: rota em dupla; o facho dá cone de visão de 14 m; fora do cone, 4 m.
- Perceber: vê o clarão do jogador a 40 m; ouve tiro a 30 m.
- Atacar: tiro de rifle (15, cadência lenta), coronhada a 1,5 m. Vida 2T.
- Acertar o facho: o soldado fica cego 5 s.

### Antônio e Marconi

Como soldado, mas vida 4T, revólver (dano 12, cadência rápida), usam cobertura e flanqueiam em
dupla. Antônio grita para chamar a atenção enquanto Marconi dá a volta. Laço: se o jogador ficar
a 6 m de Antônio por 3 s parado, é laçado (cap. 2, roteirizado; cap. 3, 2 s preso).

### Multidão (cap. 5)

Não é alvo de combate. Avança em bloco com tochas (a tocha é luz) e para a 4 m da porta. Tiro
para cima (o clarão) faz recuar 6 m por 10 s. Matar morador: Graça −1. Alguns jogam pedra (5).

### Capanga do Coronel (cap. 10)

Chapéu de couro, espingarda de dois canos ou facão. `vision_range` 12 m, espingarda 25 de dano
a menos de 8 m. Alguns só de facão, `move_speed` 1.6.

### O Coronel (cap. 10)

**Corpo fechado:** bala comum ricocheteia (faísca no peito, som de sino). Abre por 8 s com uma
bala de prata ou com o terço encostado (o jogador precisa chegar a 1,5 m segurando o terço; o
Coronel recua e grita). Aberto: vida 6T. Atira de revólver (15), chama capangas, foge pelo
escritório. Rendido com 10% de vida (escolha).

---

## Ela (referência)

Não é inimigo: é a segunda alma do jogador. Regras completas em `00-biblia.md`.

| Poder | De onde vem |
|---|---|
| Tentáculos, Comer | cap. 1 |
| Boca elástica | cap. 6, só contra o lobisomem |
| Vômito | cap. 7 em diante |
| Completa (sem fome) | só no fim, se comer o Velho |

Cada ponto de **Marca** muda a voz dela: menos deboche, mais intimidade ("meu bem"), e os
Tentáculos ficam mais grossos e com mais olhos.
