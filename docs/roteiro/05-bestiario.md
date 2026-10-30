# Bestiário

Cada ficha traz: **origem** (folclore ou quadrinho), **versão no jogo**, **IA** nos termos do
template (patrulhar → perceber → perseguir → atacar), **fraqueza**, **som** e **o que Ela ganha**
ao comer. O "Lampião 1" só tem criaturas da obra (E1–E11): a volante, Antônio e Marconi, o
lobisomem. O vulto de olhos brancos não é inimigo. A comida dela é carniça de bicho e a gente que a
história entrega.

## Como ler a IA

O inimigo base (`common/enemy/enemy.gd`) faz: parado/patrulha → vê o jogador dentro de
`vision_range` → persegue por `chase_time` → ataca dentro de `attack_range`. **🆕** marca o que
precisa ser programado além do template.

Força: "Vida 2T" = aguenta 2 tiros de revólver. Rifle = 2 tiros. Peixeira = 1 tiro,
silenciosa. Tentáculos = mata gente na hora; em chefe, 2 tiros.

## Regras gerais

- **Clarão:** todo inimigo com linha de visão vê o jogador no instante do tiro, até 40 m. Quem
  ouve um tiro a 30 m vem ver.
- **Terço:** lobisomem fica lento 2 s; gente não liga.
- **Prata:** só o lobisomem sente.

## Tabela rápida

| Criatura | Caps. | Vida | Velocidade | Visão | Pode comer? | Fome | Ganho |
|---|---|---|---|---|---|---|---|
| Lobisomem (Ciro) | 6–7 | 30T (chefe) | muito rápida | 20 m, faro | **não** (enjoo) | — | — |
| Soldado da volante | 1 | 2T | normal | cone de facho 14 m | sim: vivo no Modo Ela (−12), morto como carniça (−30) | | vida +15 (carniça) |
| Vini (duelo) | 1 | 2 golpes de peixeira | normal | — | não | — | — |
| Antônio e Marconi | 2–3 | 4T cada | normal | 16 m | só em cena (roteirizado) | zera | — |
| Multidão | 5 | não-alvo | lenta | — | só Zeca (escolha) | zera | — |
| Carniça de bicho | 2, 4–6 | — | — | — | sim | −10 a −40 | ver Carniça |

---

## Carniça (comida, não inimigo)

**Origem.** O quadrinho: "Eu vou te dar todas as carnes podres que eu achar no caminho" (E1 38) e
o cavalo morto do E2 ("Opa, esse eu nunca experimentei!").

**No jogo.** Bicho morto espalhado pelo mapa em **marcadores de carniça** (`carnica` no
`04-mapas.md`), quase sempre com urubus em cima que levantam em revoada quando o jogador chega.
Interação "COMER": a costura abre, a boca dela morde, a visão desce e sobe.

| Carniça | Onde | Fome | Vida |
|---|---|---|---|
| Bode / cabra | caps. 2, 5, 6 | −30 | +10 |
| Cavalo / jumento / vaca | caps. 2, 4 | −40 | +15 |
| Urubu (pego com Tentáculos) | caps. 2, 4 | −15 | +5 |
| Galinhas mortas pelo bicho | cap. 6 | −10 | — |
| Restos e cadáver de soldado | cap. 1 | −30 | +15 |

**Som.** Mosca, urubu, o estalo da costura abrindo.

**Ela.** "Bleh. Isso aí já passou do ponto." / "Morto de pouco. Ainda tá quente."

---

## Lobisomem (Ciro)

**Origem folclórica.** Ibérica, muito forte no Nordeste: o homem que vira bicho em noite de lua,
roda pelas encruzilhadas, come sujeira e ataca quem acha. Desencanta-se com um ferimento que tire
sangue (mas quem ferir não pode se sujar do sangue, senão pega a sina) ou se mata com bala de
prata.

**No jogo (caps. 6–7).** Ciro, como no quadrinho. Na lua cheia, vira:
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
  (roteirizado na primeira vez) prende 5 s; balas de prata. Termina de joelhos (não morre: o
  destino de Ciro fica para o "Lampião 2").

**Fraqueza.** Prata (cada bala: 25% da vida). Bala comum, fogo e tição só atrasam. O terço segura
2 s.

**Som.** Respiração de cachorro grande; osso estalando; "Filha..." rouco; uivo que faz o povo
fechar as janelas.

**Ela ganha.** Nada, e perde: morder o lobisomem dá **enjoo** (Tentáculos desligados até o fim do
cap. 7, Lampião vomita sangue preto, visão balança). "Gosto ruim." E Ela reconhece alguém no sangue: "é ele... ele ainda está aqui".

---

---

## O vulto de olhos brancos (não é inimigo)

Do quadrinho (E4 23, E8 12–13). Silhueta preta peluda, dois olhos brancos. Usado só em cena e como
susto do tipo **vulto** (aparece na visão periférica e some quando o jogador olha). Não tem vida,
não ataca, não pode ser alvo. Quem é fica para o "Lampião 2".

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

### Vini (duelo do cap. 1)

Corpo a corpo com a coronha do rifle (15 de dano), um tiro que erra (só clarão). Cai com 2 golpes
de peixeira e a cena da degola começa.

---

## Ela (referência)

Não é inimigo: é a segunda alma do jogador. Regras em `00-biblia.md`.

| Poder | De onde vem |
|---|---|
| Tentáculos, Comer | cap. 1 |
| Boca elástica | cap. 6, só contra o lobisomem |
| Vômito | cap. 7 |
