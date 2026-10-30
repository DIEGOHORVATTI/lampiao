# Mudanças no cap. 1 — do "A Cabeça" para "O Sacrifício"

O jogo agora é o **"Lampião 1"**: 7 capítulos que seguem os episódios 1 a 11 do quadrinho à risca.
O cap. 1 é o E1 inteiro (`docs/referencias/tapas-2173018/01–38`).

Para o programador. Compara o cap. 1 que está no código (`world/cap01/cap01.gd`,
`world/cap01/cinematica.gd`, `tools/build_cap01.gd`, roteiro antigo `cap01-a-cabeca`) com o
novo roteiro (`03-capitulos/cap01-o-sacrificio.md`) e o novo mapa (`04-mapas.md`, cap. 1).
O cap. 1 é reescrito do zero: quase nada do mapa e das falas se aproveita. O que se aproveita
está marcado como **mantém**.

## 1. Arquivos e ids

- Arquivo de roteiro: `cap01-a-cabeca.md` → `cap01-o-sacrificio.md`. Nome do capítulo na tela:
  "O Sacrifício".
- A cena pode continuar `world/cap01/cap01.tscn`; o mapa muda inteiro (`tools/build_cap01.gd`
  precisa ser refeito com as coordenadas novas).

## 2. História (o que muda de fato)

| Antes | Agora |
|---|---|
| Emboscada da volante na Grota da Baraúna, de madrugada, com chuva | Assalto do bando à **fazenda do Coronel** em noite de **lua cheia**, fuga a cavalo, noite na **Caverna dos Ídolos** |
| Traição de um coiteiro de fora; degola pelo Tenente Laurindo | **Vini**, o cozinheiro do bando, envenena a sopa (o Coronel pegou a família dele) e leva Lampião para o fundo da caverna; o **Coronel em pessoa** degola Lampião e depois mata Vini |
| O "Encosto", masculino, nascido da seca de 1877, voz de coro, raízes pretas | **Ela**: entidade feminina, antiga, que veio do mar e estava enterrada sob os ídolos. Acorda com o sacrifício (o bando envenenado + a degola + o sangue de Vini na laje). Olho no pescoço, boca de dentes, **tentáculos cheios de olhos** |
| Trato falado e aceito ("Segure para aceitar") | Não há trato prévio. Ela acorda, come, tenta comer a cabeça; o **terço de Maria** brilha e a cabeça volta costurada. O "acordo" é a conversa da cena 9 ("Eu só preciso arranjar mais comida e te deixo descansar em paz") |
| Cabeça em lata de querosene; o corpo vem buscar a cabeça no acampamento | Cabeça na mão do Coronel; Ela sai do coto do pescoço; o Coronel larga a cabeça e foge |
| Bando: Cansanção, Sabiá, Gavião, Fumaça, Pé-de-Serra, Jurema (alma) | Bando: **Maria** (mulher de Lampião), **Vini** (traidor), **Baraúna** e **Xexéu**. No fim, três covas (Maria, Baraúna, Xexéu) e uma quarta, opcional, para Vini. Sem Jurema, sem alma penada |
| Termina com Dona Dorinha achando Lampião na estrada | Termina com Lampião **enterrando o bando** ao nascer do sol, o terço no pescoço e o juramento: "Eu vou te matar, Coronel!" |
| Maria Bonita proibida no roteiro | **Maria** é personagem central do cap. 1 (só "Maria"; nenhum sobrenome) |

## 3. Personagens do cap. 1

- **Saem:** Tenente Laurindo, Cansanção, Sabiá, Gavião, Fumaça, Pé-de-Serra, Jurema, Dona
  Dorinha, sentinela, "SOLDADO 1/2".
- **Entram:** Maria, Vini, Baraúna, Xexéu, o Coronel, Capitão da volante (só uma fala),
  soldados da volante, Ela.
- **Mantém:** Benedito, o soldado de 19 anos. Agora aparece duas vezes: desarmado na fazenda
  (beat 1) e preso numa fenda (beat 11, a escolha). Se o jogador atirar nele na fazenda, quem
  aparece na fenda é um soldado sem nome.
- Nome no diálogo: o falante "ENCOSTO" vira **"ELA"**. O jogo não usa mais a palavra
  "Encosto" em fala nem interface.
- Ela chama Lampião de **"Capitão"** (nunca "garoto"). Lampião a trata por "tu".

## 4. Beats (ordem nova, numeração igual à do roteiro)

0. Cartão: narração "Somos justiceiros errantes..." (substitui a sextilha de Zé Mirim).
1. Assalto à fazenda, jogável (tutorial de olhar, andar, agachar, tiro e clarão). Benedito
   desarmado. Maria leva o tiro e mostra o terço.
2. Fuga a cavalo (cena, sem controle).
3. Acampamento na boca da caverna, exploração livre: conversas, Maria dá o terço, a sopa.
4. Sonho (a lua vira olho) e veneno: o bando morrendo, Lampião lento e com mira tremendo;
   o Coronel chega; tiroteio curto; o jogador pode apagar a fogueira; segue Vini.
5. Galeria: seguir o facho de Vini; nichos com corpos secos; 2 soldados; desmoronamentos.
6. Salão dos Ídolos: Vini aponta o rifle, duelo de peixeira (2 golpes).
7. Degola em primeira pessoa (a câmera é a cabeça que cai), o Coronel, morte de Vini, a voz.
8. **Modo Ela:** o jogador controla o corpo sem cabeça; tentáculos e comer contra 4 soldados;
   o terço brilha, Ela grita, a cabeça volta.
9. Conversa "Nós estamos vivos"; revólver; fechar os olhos de Vini.
10. Corpos-secos acordam nos nichos; tutorial de comer cadáver e do terço; a fenda.
11. Escolha de Benedito.
12. Maria morre nos braços dele.
13. Enterro (três covas, mais a de Vini se o jogador quiser) e juramento ao nascer do sol.

## 5. Falas

- **Todas** as falas do `cap01.gd` saem, menos as de Benedito (beat 11, mantém quase iguais,
  trocando "garoto" por "Capitão" e "Deixar ele comer" por "Deixar ela comer") e as duas
  falas da escolha ("Corre. E conta pra todo mundo o que tu viu." / "Tá vendo? Gente enche.").
- A fala do `cap01.gd` "Teu rifle tá ali no chão, garoto. Pega. Num é à toa que chamam tu de
  Lampião." sai. A origem do apelido agora vem de três lugares: o grito do soldado no beat 1
  ("É ele! É o Lampião! Olha o clarão!"), a fala de Maria no beat 3 e o folheto.
- Mensagem de possessão (`pacto.gd`): "O Encosto cansou de esperar.\nAgora a carniça é você."
  → **"Ela cansou de esperar.\nAgora a comida é você."**
- As falas novas estão completas no roteiro; os textos entre colchetes são legenda de som.

## 6. Mecânicas

| Item | Antes | Agora |
|---|---|---|
| Rifle | pego na lata (`rifle_taken`) | com o jogador **desde o início**; vazio no duelo; recuperado no salão |
| Peixeira | só citada | arma de corpo a corpo usada no duelo (beat 6) e contra corpo-seco |
| Pistola | parabélum da sentinela | **revólver** de soldado, no chão do salão (−6, 70) |
| Lampião de querosene | pickup, querosene | **não existe**. Tirar `lampiao` do mapa e qualquer HUD de querosene |
| Luz | lampião + fogueira | clarão do tiro (já existe em `clarao_rig.gd`), fogueira, lua, **facho** (NPC; jogador pode carregar 90 s), candeeiro de cenário, **claraboia** |
| Apagar fogueira | — | interação de 1 s; a fogueira vira `fogueira` apagada |
| Medidor de fome | visível desde o começo, inicia em 60 | **escondido até Ela acordar** (Modo Ela, beat 8). Ao voltar para Lampião (beat 9), fome em 50 |
| Rótulo da barra | "FOME DO ENCOSTO" | **"FOME"** |
| Raízes | botão "RAÍZES", tecla Q, `Poderes.raizes()` | **Tentáculos**: rótulo "TENTÁCULOS". O efeito visual passa de raiz marrom a tentáculo preto com pontinhos brancos (olhos). Pode manter os ids `raizes` no código |
| Comer | corpo-seco caído | igual (mantém: fome −30, vida +15) e mais: em Modo Ela, comer soldado erguido pelo tentáculo (fome −12; a barra começa em 100 no Modo Ela) |
| **Modo Ela** | — | novo, só no cap. 1: câmera a 1,5 m, sem armas, lente olho-de-peixe leve, cinza; Tentáculos sem custo de fome, alcance 6 m, cooldown 0,6 s; tiro não fere; dura até o E2 acabar |
| **Terço** | — (o crucifixo era do cap. 2) | ganho no cap. 1 (beat 3), tutorial no beat 10. Novo botão **"TERÇO"** (segurar): fome desce ~1/s, poderes desligados, corpos-secos recuam a 4 m. Tutorial no gatilho g4 ou com fome ≥ 75 |
| Escolha | `Dialogo.escolher(["Guardar a peixeira", "Deixar ele comer"])` | mantém o mecanismo; texto "**Deixar ela comer**" |
| Segurar para aceitar | `Dialogo.segurar(...)` no trato | sai do cap. 1 (pode ser reaproveitado em "Cavar", 3 s por cova) |
| Duelo | — | Vini: inimigo humano corpo a corpo, 2 golpes de peixeira, coronhada de 15 |
| Degola em primeira pessoa | corte para preto antes do golpe | **mostrada**: câmera solta da cabeça, gira, cai, vê o corpo sem cabeça jorrando sangue preto |
| Lente rachada | — | depois da degola, risco fino no canto direito da tela, permanente |
| Cavar | — | interação de segurar 3 s em `cova-cavavel` |
| Spawner | covas de cemitério | **nichos** na parede da caverna |

## 7. Flags e medidores

| Flag | Valores | Onde |
|---|---|---|
| `fazenda_benedito` | `poupado` / `morto` | beat 1 (novo) |
| `benedito` | `poupado` / `comido` | beat 11 (mantém; Marca +1 se comido) |
| `vini` | `perdoado` / `largado` / `enterrado` | beats 9 e 13 (novo) |

Sai: nada do cap. 1 antigo tinha outras flags. `Historia.capitulo = 2` ao fim continua.

## 8. Mapa

Refazer `tools/build_cap01.gd`. Origem nova: **a fogueira do bando** na boca da caverna.

| Antes | Agora |
|---|---|
| Z1 Acampamento da volante, Z2 Cemiteriozinho, Z3 Trilha do paredão, Z4 Grota, Z5 Saída | Z1 Fazenda (área separada, z −252..−180), Z2 Salão da boca, Z3 Galeria, Z4 Salão dos Ídolos, Z5 Fenda, Z6 Lajedo de fora |
| caminhão (jeep), barracas, carroça, cemitério, cruz de ex-votos | casa-grande com interior, capela, cerca de arame farpado, cavalos, túneis de caverna, totens, laje rachada, nichos, claraboia |
| Marcadores `E1`, `E2a`, `E2b`, `E3a..c`, `E4a/b`, `JuremaPos`, `JuremaSaida` | Marcadores `E0_1..7`, `E1a_1..2`, `E1b_1..2`, `Vini`, `E2_1..4`, `E3_n1..n4`, `E4a`, `E4b`, `Benedito`, `Cabeca` |
| Gatilhos `G_Carroca`, `G_Cemiterio`, `G_Grota`, `G_Saida`, `G_Estrada` | Gatilhos `G1_Maria` (−6, −206), `G_Cavalos` (−18, −186), `G2_Desmorona` (6, 20), `G_Sussurro` (−2, 46), `G_Salao` (0, 62), `G3_Servos` (0, 80), `G4_Terco` (26, 60), `G_Benedito` (31, 24), `G_SaidaFenda` (34, −4), `G_Covas` (−10, −24) |
| Interagíveis "Lata", "Barraca", "CruzEnjeitados", "Corpo_0..5" | "Saco" (cofre), "Falar" (4 NPCs), "Terço" (Maria), "Sopa", "Olhar" (ídolo e laje), "Levantar Maria", "Apagar" (fogueira), "Pegar" (revólver, rifle, facho), "Fechar os olhos" (Vini), "Cavar" (4 covas), "Folheto" |

As coordenadas completas estão em `04-mapas.md`, cap. 1. Peças novas por prioridade: na
mesma seção, "Peças usadas no cap. 1".

## 9. Cinemática (`cinematica.gd`)

- **Mantém** como ferramenta: `begin`, `look`, `lift_head`, `fall_to_side`, `soldier`,
  `burst`, `sound`, `footsteps`, `knock`.
- **Sai:** `dawn_rain` (não chove mais), a cena da lata.
- **Entra:** cavalgada (câmera balançando, cavalos em silhueta), cabeça caindo (câmera solta
  com rotação e quique), mão levantando a cabeça pelo cabelo, olho na lua (sonho), olhos dos
  totens acendendo, Ela saindo do pescoço (massa preta subindo, vista da cabeça no chão),
  brilho do terço com flashes de memória de Maria.

## 10. Sustos

O cap. 1 antigo tinha 4 sustos (batidas na lata, braço na cerca, urubus, Jurema). O novo tem 11,
todos com as ferramentas que o jogo já tem: **jumpscare**, **vulto**, **passos**, **batida**,
**sussurro**, **respiracao**, **apagao**, e **chao** (corpo-seco saindo do nicho). Tabela com zona,
gatilho e efeito no fim de `03-capitulos/cap01-o-sacrificio.md`; posições dos gatilhos em
`04-mapas.md`. Os ids de gatilho sugeridos: `S1_Vulto` … `S11_Vulto` (um por linha da tabela).

## 11. Telas de carregamento

Novas, com gore do quadrinho (preto chapado, silhueta): `tapas-2173018/21.jpg`, `25.jpg`,
`28.jpg`, `23.jpg`, com as legendas do roteiro. Sem emoji em nenhuma legenda.

## 12. Testes

`tests/cap01_test.gd` e `tests/pacto_test.gd` testam o fluxo antigo (lata, Jurema, Benedito
antigo, fome inicial 60). Precisam ser reescritos para: fome escondida até o Modo Ela, fome 50
depois do beat 9, flags `fazenda_benedito`, `benedito`, `vini`, e fim do capítulo depois do
gatilho das covas.
