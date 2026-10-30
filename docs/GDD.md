# Lampião — documento de design

Jogo de horror em primeira pessoa no sertão. Inspirado no mangá *Lampião* (justiceiro
errante possuído) e na música de referência (transcrição em `docs/transcricao-musica.txt`).

## Decisões do autor (2026-10-29)

- O apelido vem do rifle: ele atirava tão rápido que o clarão iluminava a noite. **Não existe lampião de querosene**: a luz do jogo vem do clarão dos tiros e das fogueiras. Atirar ilumina, mas revela a posição.
- O jogo nunca usa o nome de batismo, só "Lampião" ou "Capitão".
- Nenhum emoji na interface.
- **Gênero definido (2026-10-30): horror gore em primeira pessoa**, em episódios curtos e polidos que rendam vídeo de streamer. Nada de FPS competitivo, RPG ou MMO. O primeiro capítulo é a vitrine e recebe o polimento máximo.
- A história segue a cronologia do quadrinho (episódios 1 a 11 na ordem) e só depois continua com história nova.
- Onde o roteiro cita querosene, lampião na mão ou pavio, trocar por clarão do rifle, fogueira ou candeeiro de cenário.

## Premissa

O bando foi morto por um coronel. Lampião morreu junto, com a cabeça arrancada, e voltou.
Voltou porque fez um pacto: um **Encosto** vive dentro dele e o mantém de pé. Em troca,
ele precisa ser alimentado com carniça: as criaturas que rondam o sertão à noite.

> "Eu te alimento com qualquer carniça no caminho."

Não é herói. É o mal necessário, o justiceiro do povo que ninguém ajuda.

## Pilares

1. **Escuridão** — a única luz é o lampião na mão. Fora dela, a neblina engole tudo.
2. **Pacto** — o Encosto tem fome. Matar alimenta; não matar deixa a fome subir até ele te tomar.
3. **Folclore** — cada noite traz uma assombração diferente do sertão e do Brasil.
4. **Fé como arma e prisão** — o crucifixo segura o Encosto, mas também o enfraquece.

## Loop (fatia vertical atual)

- Noite, neblina, lampião tremeluzindo.
- Corpos-secos surgem na neblina (olhos vermelhos visíveis de longe) e caminham até você.
- Tiro mata (3 acertos). Toque tira vida.
- **Vida** zera → morre. **Fome do Encosto** enche → possessão (game over).

## Bestiário (planejado)

| Criatura | Origem | Comportamento |
|---|---|---|
| Corpo-Seco | sertão / MG | anda devagar, aguenta tiro, aparece em bando ✅ |
| Lobisomem | ibérico/nordeste | humano de dia, ataca em lua cheia; chefe |
| Mula-sem-cabeça | colonial | investida rápida com fogo, segue o barulho |
| Comadre Fulozinha | Pernambuco | invisível na mata, assovia; só some com oferenda |
| Papa-figo | Recife | se disfarça de mendigo pedindo ajuda |
| Cabra-cabriola | nordeste | entra em casas à noite atrás de crianças |
| Caipora | indígena | protege a caatinga; pune quem caça demais |

## Mecânicas a explorar

- **Querosene**: o lampião apaga sem combustível; no escuro o Encosto fica mais forte (e com mais fome).
- **Forma do Encosto**: gastar fome para atacar com tentáculos (corpo a corpo de alcance).
- **Crucifixo**: segurar acalma a fome, mas desliga os poderes; criaturas profanas recuam.
- **Peixeira**: corpo a corpo silencioso, não atrai bandos.
- **Escolhas morais**: ajudar o povo que te nega ajuda, ou deixar o Encosto comer.

## Ambientação

Caatinga à noite, mandacaru, casas de taipa, cemitério de cruz de madeira, capela abandonada,
lua nova. Paleta: preto, ocre, laranja de chama, vermelho de sangue.
