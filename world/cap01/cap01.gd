extends Node3D

const HUMANO := preload("res://world/humano.gd")
const SOLDADO := preload("res://enemies/soldado.tscn")
const INTERAGIVEL := preload("res://world/interagivel.gd")
const ALVO := preload("res://world/alvo.gd")
const PROPS := preload("res://world/sertao/props.gd")
const TERNO := Color(0.12, 0.12, 0.16)
const FARDA := Color(0.6, 0.53, 0.38)
const COURO := Color(0.42, 0.3, 0.18)
const BENEDITO_TIMEOUT := 30.0

var bando := {}
var soldados: Array = []
var shots := 0
var veneno := false
var vini_hits := 0
var carnica_comida := false
var facho_light: OmniLight3D
var beat := 0
var env: Environment


func _ready() -> void:
	await get_tree().process_frame
	env = find_child("WorldEnvironment", true, false).environment
	_lock(true)
	Pacto.start_level(0.0)
	Pacto.fome_ativa = false
	Pacto.active = false
	Dialogo.fade(1.0, 0.0)
	await Dialogo.cartao("Nordeste do Brasil, 19XX.\n\nSomos justiceiros errantes.\nBandidos por necessidade.\nNós ajudamos aqueles que necessitam,\ntirando daqueles que têm até demais.\n\nSomos cangaceiros.", 6.0)
	await _assalto()


func _assalto() -> void:
	beat = 1
	bando.barauna = _npc("Barauna_F", COURO, "meia_lua")
	bando.xexeu = _npc("Xexeu_F", COURO.darkened(0.2), "meia_lua")
	bando.maria = _npc("Maria_F", Color(0.35, 0.27, 0.2), "boina")
	bando.barauna.pose("Crouch_Idle")
	_face_player_to("Saco")
	Global.player.weapons_manager.switch_weapon(2)
	await Dialogo.fade(0.0, 1.5)
	_lock(false)
	Dialogo.mostrar_prompt("Olhe arrastando à direita · ande com o polegar esquerdo")
	await get_tree().create_timer(4.0).timeout
	Dialogo.esconder_prompt()
	await _interagivel("Saco", "Pegar o saco").usado
	Historia.set_flag("saco", "sim")
	var benedito := _npc("Benedito_Porta", FARDA, "quepe", false)
	var alvo := _alvo(benedito)
	alvo.atingido.connect(func():
		if Historia.flag("fazenda_benedito") == "":
			Historia.set_flag("fazenda_benedito", "morto")
			benedito.morrer()
			Dialogo.falar([["MARIA", "Lampião!"]]))
	await benedito.andar_ate(_pos("Benedito_Chao"), 1.6, true)
	benedito.pose("Crouch_Idle")
	await Dialogo.falar([
		["BARAÚNA", "Tu tá morto, desgraça!"],
		["LAMPIÃO", "Ele tá desarmado! Tamo aqui pela grana, não pela matança. Para de perder tempo!"],
	])
	await get_tree().create_timer(2.5).timeout
	if Historia.flag("fazenda_benedito") == "":
		Historia.set_flag("fazenda_benedito", "poupado")
		benedito.queue_free()
	await Dialogo.falar([["SOLDADO", "Ali estão eles, não os deixem fugir!"], ["CAPITÃO DA VOLANTE", "FOGO!"]])
	for i in 7:
		var s := _soldado("E0_%d" % (i + 1), 0.22, 0.4)
		s.vision_range = 45.0
		s.shoot_range = 40.0
		s.alert(s.global_position, 1.0)
	Dialogo.mostrar_prompt("O clarão do tiro mostra o caminho. E mostra você.")
	Global.muzzle_flash.connect(_on_player_shot)
	_gatilho("G_Fundos").entrou.connect(func():
		for key in ["barauna", "xexeu", "maria"]:
			bando[key].andar_ate(_pos("G1_Maria") + Vector3(randf_range(-2, 2), 0, randf_range(-1, 1)), 1.8, true))
	await _gatilho("G1_Maria").entrou
	Dialogo.esconder_prompt()
	var atirador := _npc("Soldado_Capela", FARDA, "quepe")
	await atirador.olhar_para(Global.player.global_position, 0.2)
	atirador.pose("Pistol_Shoot")
	_tiro_em(atirador.global_position + Vector3.UP * 1.4)
	bando.maria.global_position = Global.player.global_position + Vector3(1.2, 0, -0.6)
	bando.maria.pose("Crouch_Idle")
	Pacto.hit_flash = 0.8
	await Dialogo.falar([
		["LAMPIÃO", "Maria?!"],
		["LAMPIÃO", "Querida, o que tu fez? Tu tá bem?"],
		["MARIA", "(dente trincado) Urgh! Não podemos parar, vamo reto!"],
		["XEXÉU", "Tão com o Vini, bem ali!"],
		["LAMPIÃO", "Onde que tão os cavalo?"],
		["", "[Maria abre a mão. O terço de contas escuras brilha na luz da lua.]"],
		["MARIA", "Não se preocupa. Eu sou abençoada, lembra?"],
	])
	atirador.queue_free()
	bando.vini = _npc("Vini_F", Color(0.5, 0.48, 0.4), "boina", false)
	for key in ["barauna", "xexeu", "maria"]:
		bando[key].andar_ate(_pos("Vini_F") + Vector3(randf_range(-2, 2), 0, -1.5), 1.6, true)
	await _gatilho("G_Cavalos").entrou
	await _fuga()


func _on_player_shot() -> void:
	shots += 1
	if shots == 3 and beat == 1:
		Dialogo.falar([["SOLDADO", "É ele! É o Lampião! Olha o clarão!"], ["MARIA", "Rápido, pelos fundos! Vamo depressa!"]])


func _fuga() -> void:
	beat = 2
	_lock(true)
	await Dialogo.fade(1.0, 0.6)
	for s in soldados:
		if is_instance_valid(s):
			s.queue_free()
	soldados.clear()
	for key in bando:
		bando[key].queue_free()
	bando.clear()
	_teleport("Coronel_Boca", 180.0)
	_galope()
	await Dialogo.falar([
		["", "[galope. Lua cheia. Tiros ficando para trás.]"],
		["VINI", "Eu conheço um lugar seguro! Apenas me sigam!"],
		["BARAÚNA", "Precisamos parar em algum lugar. Não podemos seguir viagem com Maria nesse estado!"],
		["LAMPIÃO", "Vai ficar tudo bem!"],
	])
	await Dialogo.fade(0.0, 1.5)
	await Dialogo.falar([["", "[pilares tortos de pedra lavrada na entrada]"], ["VINI", "Chegamos. Podemos passar pelo menos essa noite aqui."]])
	await _acampamento()


func _acampamento() -> void:
	beat = 3
	await Dialogo.fade(1.0, 0.4)
	_teleport("Lampiao_Manta", 180.0)
	bando.maria = _npc("Maria", Color(0.35, 0.27, 0.2), "boina", false)
	bando.maria.deitar()
	bando.barauna = _npc("Barauna", COURO, "meia_lua")
	bando.barauna.pose("Sitting_Idle")
	bando.xexeu = _npc("Xexeu", COURO.darkened(0.2), "meia_lua")
	bando.xexeu.pose("Crouch_Idle")
	bando.vini = _npc("Vini", Color(0.5, 0.48, 0.4), "boina", false)
	bando.vini.global_position = _pos("Fogueira") + Vector3(0.9, 0, 0.9)
	for key in ["barauna", "xexeu", "vini"]:
		bando[key].olhar_para(_pos("Fogueira"), 0.01)
	await Dialogo.fade(0.0, 1.5)
	_lock(false)
	_falar_npc(bando.xexeu, [["XEXÉU", "Caramba! Esse calote foi do Pipoco. Olha toda essa grana!"], ["LAMPIÃO", "Nem adianta ficar muito animado não. Temos planos pra toda essa bufunfa, lembra?"]])
	_falar_npc(bando.barauna, [["BARAÚNA", "Essas taxa vão de volta pras comunidade que pagaram. Começando pela comunidade de Maria."], ["BARAÚNA", "Daí o que sobrar, a gente compra comida e suprimento."]])
	_falar_npc(bando.vini, [["VINI", "Sopa de bode, Capitão. Do jeito que tua mãe fazia, só que melhor."], ["", "[ele não olha nos olhos]"]])
	_interagivel("Idolo", "Olhar o rosto de pedra").usado.connect(func():
		Sustos.som_atras("respiracao", 2.0)
		await get_tree().create_timer(2.5).timeout
		Sustos.vulto(6.0, 1.2))
	await _interagivel("Maria", "Falar com Maria").usado
	await Dialogo.falar([
		["MARIA", "Vem cá. Segura isso pra mim enquanto eu durmo."],
		["LAMPIÃO", "Teu terço? Tu num larga isso nem pra tomar banho."],
		["MARIA", "Tu num é abençoado, mas eu te empresto. Amanhã tu me devolve."],
		["LAMPIÃO", "Amanhã eu te devolvo."],
		["MARIA", "Tu acende a noite toda vez que atira, sabia? O povo te chama de Lampião por isso. Eu chamo de besta."],
	])
	Historia.set_flag("terco", "pulso")
	await Dialogo.falar([
		["VINI", "Pessoal, sopa tá pronta!"],
		["BARAÚNA", "Orra, que sopa deliciosa. Tu tem uns talento escondido, Vini."],
		["VINI", "Hahah, que nada, home. Agora descansem. Vou passar a noite na vigia."],
	])
	bando.vini.andar_ate(_pos("Vini"), 1.4)
	await Dialogo.falar([["VINI", "(já na boca da caverna, de costas) Tenham um bom descanso."]])
	await _interagivel("Cuia", "Tomar a sopa").usado
	await _veneno()


func _veneno() -> void:
	beat = 4
	_lock(true)
	await Dialogo.fade(1.0, 2.0)
	bando.vini.visible = false
	Sustos.face_rect.texture = load("res://resources/ui/sustos/lua.jpg")
	Sustos.face_rect.modulate.a = 0.0
	Sustos.face_rect.scale = Vector2.ONE
	Sustos.face_rect.visible = true
	await create_tween().tween_property(Sustos.face_rect, "modulate:a", 1.0, 2.0).finished
	await create_tween().tween_property(Sustos.face_rect, "scale", Vector2.ONE * 1.25, 4.0).finished
	Sustos.face_rect.visible = false
	Sustos.jumpscare("maria")
	await get_tree().create_timer(0.5).timeout
	for key in ["maria", "barauna", "xexeu"]:
		bando[key].deitar()
	Dialogo.fade(0.0, 0.8)
	await Dialogo.falar([["LAMPIÃO", "Q-que mizera de pesadelo foi esse? M-Maria..."], ["", "[espuma branca escorrendo pelo queixo dela. Baraúna caído na mesma espuma. Xexéu com a cuia na mão.]"], ["LAMPIÃO", "Maria?! Que porra é essa?"]])
	_lock(false)
	_set_veneno(true)
	await _interagivel("Maria", "Levantar Maria").usado
	await Dialogo.falar([["MARIA", "(quase sem voz) Vai... Eu sou abençoada, lembra? Volta pra mim."], ["", "[lá fora: cascos, muitos. Os cavalos relincham e disparam.]"], ["XEXÉU", "(morrendo, apontando a boca da caverna) É o Coronel..."]])
	var coronel := _npc("Coronel_Boca", TERNO, "quepe", false)
	await Dialogo.falar([["CORONEL", "Tu vai se arrepender de roubar de mim, fi duma rapariga!"], ["LAMPIÃO", "Cacete! Como eles acharam a gente aqui?"]])
	coronel.queue_free()
	var apagou := [false]
	var fogueira_int := _interagivel("Fogueira", "Apagar a fogueira")
	fogueira_int.usado.connect(func():
		apagou[0] = true
		Sustos.apagar_luzes(4.0, 9999.0))
	for i in 2:
		_soldado("E1a_%d" % (i + 1), 0.3, 1.6).alert(_pos("Fogueira"), 1.0)
	await get_tree().create_timer(6.0).timeout
	if not apagou[0]:
		Sustos.apagar_luzes(4.0, 9999.0)
	await _until(func(): return _vivos() == 0, 60.0)
	bando.vini.visible = true
	bando.vini.global_position = _pos("Desmorona_1") + Vector3(-1, 0, -3)
	_vini_facho(true)
	await Dialogo.falar([["VINI", "Por aqui! Tem outra saída!"], ["LAMPIÃO", "A gente num tem escolha..."]])
	await _gatilho("G2_Desmorona").entrou
	_desmoronar("Desmorona_1", 5)
	await _galeria()


func _galeria() -> void:
	beat = 5
	_gatilho("S4_Vulto").entrou.connect(func(): Sustos.vulto(7.0, 1.0))
	_gatilho("S5_Sussurro").entrou.connect(func():
		Sustos.som_atras("sussurro", 1.0)
		Dialogo.falar([["", "[uma voz de mulher, muito longe, no fundo do túnel: ...fome...]"]]))
	var spawned := false
	for point in ["Vini_G1", "Vini_G2", "Vini_G3", "Vini_G4", "Vini_Salao"]:
		await _until(func(): return Global.player.global_position.distance_to(bando.vini.global_position) < 7.0, 120.0)
		await bando.vini.andar_ate(_pos(point), 1.8)
		if point == "Vini_G2" and not spawned:
			spawned = true
			for i in 2:
				_soldado("E1b_%d" % (i + 1), 0.3, 1.8).alert(Global.player.global_position, 1.0)
	await _until(func(): return _vivos() == 0, 90.0)
	_desmoronar("Desmorona_2", 6)
	await _gatilho("G_Salao").entrou
	_set_veneno(false)
	await Dialogo.falar([
		["VINI", "Acho que despistamos eles."],
		["VINI", "E-eu preciso parar..."],
		["LAMPIÃO", "Isso tudo parece muito conveniente, tu num acha, Vini?"],
		["VINI", "O-o que o senhor quer dizer?"],
	])
	await _traicao()


func _traicao() -> void:
	beat = 6
	await Dialogo.falar([["LAMPIÃO", "Que lugar é esse?"]])
	bando.vini.global_position = _pos("Vini_Duelo")
	bando.vini.olhar_para(Global.player.global_position, 0.1)
	bando.vini.pose("Pistol_Aim_Neutral")
	await Dialogo.falar([
		["VINI", "Me desculpa..."],
		["LAMPIÃO", "...?"],
		["VINI", "Tu não faria o mesmo por Maria?"],
		["LAMPIÃO", "Nem se atreva a falar o nome dela!"],
		["VINI", "Eu... eu não tive escolha. Eles pegaram a minha família. Ameaçaram matar meus pais, minha esposa... minha filha!"],
	])
	Global.player.weapons_manager.switch_weapon(0)
	Dialogo.mostrar_prompt("Só a peixeira. Desvie e golpeie.")
	var alvo := _alvo(bando.vini)
	alvo.atingido.connect(func(): vini_hits += 1)
	_vini_ataca()
	await _until(func(): return vini_hits >= 2, 180.0)
	Dialogo.esconder_prompt()
	bando.vini.pose("Crouch_Idle")
	await Dialogo.falar([["", "[a peixeira abre o rosto de Vini de orelha a boca. Ele cai de joelho. Um passo atrás de você.]"]])
	await _degola()


func _vini_ataca() -> void:
	while vini_hits < 2 and beat == 6:
		await get_tree().create_timer(2.2).timeout
		if beat != 6 or vini_hits >= 2:
			return
		var alvo_pos: Vector3 = Global.player.global_position + Global.player.global_position.direction_to(bando.vini.global_position) * 1.2
		await bando.vini.andar_ate(alvo_pos, 2.2, true)
		bando.vini.pose("Punch_Cross")
		if bando.vini.global_position.distance_to(Global.player.global_position) < 1.8:
			Global.player.get_damage(15.0, bando.vini.global_position.direction_to(Global.player.global_position), true)


func _degola() -> void:
	beat = 7
	_lock(true)
	var origem: Camera3D = Global.player.camera
	var corpo := HUMANO.new()
	corpo.roupa = COURO
	corpo.chapeu = "nenhum"
	add_child(corpo)
	corpo.global_position = Global.player.global_position
	corpo.model.rotation.y = Global.player.camera_pivot.rotation.y + PI
	var cabeca := Camera3D.new()
	add_child(cabeca)
	cabeca.global_transform = origem.global_transform
	cabeca.make_current()
	Global.player.visible = false
	Global.player.get_node("WeaponSubViewport").visible = false
	_hud(false)
	Sustos.shake(0.05, 0.3)
	Pacto.hit_flash = 1.0
	var queda := create_tween().set_parallel()
	queda.tween_property(cabeca, "global_position", _pos("Cabeca") + Vector3.UP * 0.15, 1.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	queda.tween_property(cabeca, "rotation", cabeca.rotation + Vector3(0.3, TAU * 1.5, 1.4), 1.1)
	await queda.finished
	Pacto.rachar_lente()
	var olhar_corpo := atan2(corpo.global_position.x - cabeca.global_position.x, corpo.global_position.z - cabeca.global_position.z) + PI
	await create_tween().tween_property(cabeca, "rotation", Vector3(0.05, olhar_corpo, 1.45), 0.6).finished
	_jorro(corpo.global_position + Vector3.UP * 1.55)
	await get_tree().create_timer(1.5).timeout
	corpo.pose("Crouch_Idle")
	Sustos.som_atras("respiracao", 1.0)
	var coronel := _npc("Coronel_Salao", TERNO, "quepe", false)
	await coronel.olhar_para(cabeca.global_position, 0.1)
	var segura: Vector3 = coronel.global_position + Vector3(0, 1.3, 0) + coronel.global_position.direction_to(corpo.global_position) * 0.6
	await create_tween().tween_property(cabeca, "global_position", segura, 0.9).finished
	cabeca.look_at(coronel.global_position + Vector3.UP * 1.55)
	cabeca.rotation.z = 0.3
	await Dialogo.falar([["CORONEL", "Vai ficar bom numa estaca."]])
	await create_tween().tween_property(cabeca, "rotation:y", cabeca.rotation.y + PI * 0.7, 1.4).finished
	await Dialogo.falar([
		["CORONEL", "Belo trabalho, traidor. Vi todos os corpos. Tu é um assassino implacável, haha."],
		["VINI", "O senhor vai liberar minha família agora? Eu fiz tudo que pediu."],
		["CORONEL", "Ha. Tu pensou que eu ia deixar tu ir embora na boa? Tua família tá morta desde que tu saiu em missão."],
		["VINI", "Eh...?"],
	])
	bando.vini.morrer()
	_jorro(bando.vini.global_position + Vector3.UP * 1.3)
	_poca(_pos("Laje") + Vector3(0, 0.47, 0), 1.6)
	for totem in get_tree().get_nodes_in_group("totens"):
		_acender_totem(totem)
		await get_tree().create_timer(0.35).timeout
	await Dialogo.falar([
		["ELA", "Por séculos eu estive sepultada..."],
		["CORONEL", "Quê?"],
		["ELA", "Mas agora que o sacrifício foi feito... dentro do receptáculo oferecido... eu posso renascer mais uma vez."],
		["CORONEL", "(olhando para trás) Cadê o corpo de Lampião?!"],
	])
	corpo.pose("Idle")
	await get_tree().create_timer(0.8).timeout
	await Dialogo.fade(1.0, 0.25)
	cabeca.queue_free()
	corpo.queue_free()
	await _modo_ela(coronel)


func _modo_ela(coronel: Node3D) -> void:
	beat = 8
	Global.player.visible = true
	Global.player.camera.make_current()
	Global.player.camera_pivot.position.y = 1.2
	env.adjustment_enabled = true
	env.adjustment_saturation = 0.08
	env.adjustment_contrast = 1.25
	Poderes.modo_ela = true
	Pacto.meal_value = 12.0
	Pacto.start_level(100.0)
	Pacto.fome_ativa = true
	_hud(true)
	var god := _god_mode()
	for i in 4:
		var s := _soldado("E2_%d" % (i + 1), 0.6, 0.0)
		s.alert(s.global_position, 1.0)
		s.edible_seconds = 999.0
	_lock(false)
	await Dialogo.fade(0.0, 0.6)
	await Dialogo.falar([["SOLDADOS", "FOGO!"], ["ELA", "Infelizmente não sei nem quem são vocês... mas eu agradeço pelas oferendas."], ["ELA", "Ainda não estou completa. Mas só de estar livre é fantástico."]])
	Dialogo.mostrar_prompt("TENTÁCULOS: agarre de longe. Depois USAR para comer.")
	coronel.olhar_para(Global.player.global_position, 0.1)
	for i in 3:
		_tiro_em(coronel.global_position + Vector3.UP * 1.4)
		await get_tree().create_timer(0.35).timeout
	coronel.andar_ate(_pos("Vini_Salao") + Vector3(0, 0, -6), 3.0, true)
	get_tree().create_timer(3.0).timeout.connect(coronel.queue_free)
	var fujao := _npc("E2_4", FARDA, "quepe", false)
	fujao.andar_ate(_pos("Benedito_Fuga") + Vector3(4, 0, -4), 2.5, true)
	get_tree().create_timer(4.0).timeout.connect(fujao.queue_free)
	Dialogo.falar([["SOLDADO", "Coronel?! Coronel!"]])
	await _until(func(): return _vivos() == 0, 240.0)
	Dialogo.esconder_prompt()
	await _until(func(): return Pacto.hunger <= 70.0, 60.0)
	await Dialogo.falar([["ELA", "Eu tô faminta!"], ["ELA", "E essa cabecinha aí? Tem cara de sobremesa."]])
	_lock(true)
	Sustos.shake(0.25, 1.6)
	Sustos._play(Sustos.sounds["estouro"], 6.0)
	for memoria in ["[Maria rindo a cavalo]", "[Maria com um bode no colo]", "[Maria com um feixe de flor do mato]", "[Maria de olho fechado]"]:
		await Dialogo.fade(0.85, 0.08, Color.WHITE)
		Dialogo.subtitle.text = memoria
		await get_tree().create_timer(0.6).timeout
		await Dialogo.fade(0.3, 0.08, Color.WHITE)
	Dialogo.subtitle.text = ""
	await Dialogo.fade(1.0, 0.4, Color.WHITE)
	god.queue_free()
	Poderes.modo_ela = false
	Pacto.meal_value = Pacto.HUNGER_PER_MEAL
	env.adjustment_enabled = false
	Global.player.camera_pivot.position.y = 1.7
	await _nos()


func _nos() -> void:
	beat = 9
	_teleport("Lampiao_Duelo", 0.0)
	Pacto.hunger = 50.0
	_restos_soldados()
	await Dialogo.fade(0.0, 1.5, Color.WHITE)
	await Dialogo.falar([
		["LAMPIÃO", "Eu... eu estou vivo...?"],
		["", "[costura em X em volta do pescoço inteiro, linha preta grossa]"],
		["ELA", "Urgh... Nós estamos vivos. Eu não sei o que houve aqui, mas ainda não estou na minha forma completa... que maravilha."],
		["LAMPIÃO", "Tu é o quê?"],
		["ELA", "Eu sou a dona dessa casa, Capitão. Tu é que entrou sem bater."],
		["LAMPIÃO", "Eu... entendo."],
		["ELA", "Entende nada. Você só tá andando por causa de mim, tá bom? Eu só preciso arranjar mais comida e te deixo descansar em paz."],
		["LAMPIÃO", "E se eu num quiser?"],
		["ELA", "Aí tua cabeça cai de novo. E dessa vez sem eu pra segurar."],
	])
	_lock(false)
	_interagivel("Revolver", "Pegar o revólver").usado.connect(func(): Global.player.weapons_manager.switch_weapon(1))
	_interagivel("Rifle_Vini", "Pegar o rifle").usado.connect(func(): Global.player.weapons_manager.switch_weapon(2))
	Historia.set_flag("vini", "largado")
	_interagivel("Vini_Corpo", "Fechar os olhos de Vini").usado.connect(func():
		Historia.set_flag("vini", "perdoado")
		Dialogo.falar([["", "Bilhete no bolso de Vini: \"Vini. Tua mulher e tua menina tão com a gente. Leva eles pra caverna das pedra de cara. Veneno vai junto com esse bilhete. Se tu não fizer, nós faz.\""]]))
	await _fenda()


func _fenda() -> void:
	beat = 10
	_gatilho("S7_Respiracao").entrou.connect(func():
		Sustos.som_atras("respiracao", 2.5)
		await get_tree().create_timer(3.0).timeout
		await Dialogo.falar([["SOLDADO", "O Coronel quer a cabeça! Sem a cabeça ninguém recebe!"]])
		for i in 2:
			_soldado("E3_%d" % (i + 1), 0.35, 1.8).alert(Global.player.global_position, 1.0))
	_interagivel("Facho_Pickup", "Pegar o facho").usado.connect(_pegar_facho)
	_gatilho("S8_Passos").entrou.connect(func():
		await get_tree().create_timer(8.0).timeout
		Sustos.som_atras("passos"))
	_gatilho("S9_Jumpscare").entrou.connect(func(): Sustos.jumpscare("soldado_comido"))
	_gatilho("S10_Batida").entrou.connect(func():
		for i in 3:
			Sustos.som_atras("batida", 4.0)
			await get_tree().create_timer(1.1).timeout)
	_gatilho("G4_Terco").entrou.connect(func():
		_ensinar_terco()
		for i in 4:
			var s := _soldado("E4_%d" % (i + 1), 0.4, 0.0)
			s.vision_range = 14.0)
	await _gatilho("G_Benedito").entrou
	await _benedito()


func _ensinar_terco() -> void:
	Dialogo.mostrar_prompt("Segure o TERÇO para acalmar a fome.")
	await _until(func(): return Poderes.terco_ativo, 30.0)
	Dialogo.esconder_prompt()
	Dialogo.falar([["ELA", "Irch... sério que você vai usar isso aí?"]])


func _benedito() -> void:
	beat = 11
	var preso := _npc("Benedito", FARDA, "quepe", false)
	preso.pose("Sitting_Idle")
	await preso.olhar_para(Global.player.global_position, 0.1)
	var poupado := Historia.flag("fazenda_benedito") != "morto"
	var quem := "BENEDITO" if poupado else "SOLDADO"
	var falas := []
	if poupado:
		falas.append(["BENEDITO", "Capitão... É o senhor? O senhor me poupou na fazenda. Duas vez num é pedir muito?"])
	else:
		falas.append(["SOLDADO", "Pelo amor de Deus, Capitão. Eu tenho filho."])
	falas.append_array([
		["LAMPIÃO", "Tu tava com quem me degolou."],
		[quem, "Eu num sabia, Capitão. O Coronel disse que era só pegar o dinheiro de volta. Eu tenho dezenove ano..."],
		["ELA", "Olha que coisa. Novinho. Carne de menino é macia, Capitão. Abre o pescoço, que eu faço o resto."],
		[quem, "(ouvindo só a respiração de Lampião) Com quem o senhor tá falando?"],
	])
	await Dialogo.falar(falas)
	var choice := await Dialogo.escolher(["Guardar a peixeira", "Deixar ela comer"], BENEDITO_TIMEOUT, func():
		Pacto.hunger = minf(99.0, Pacto.hunger + 10.0)
		Dialogo.falar([["ELA", "Tô esperando, Capitão."]]))
	if choice == 0:
		Historia.set_flag("benedito", "poupado")
		preso.andar_ate(_pos("G_SaidaFenda"), 2.0, true)
		await Dialogo.falar([["LAMPIÃO", "Corre. E conta pra todo mundo o que tu viu."], ["ELA", "Tu vai se arrepender de cada um que tu solta, Capitão. Cada um."]])
		preso.queue_free()
	else:
		Historia.set_flag("benedito", "comido")
		Historia.add_marca()
		await Dialogo.fade(1.0, 0.25, Color(0.2, 0.0, 0.0))
		preso.queue_free()
		await Dialogo.falar([["", "[o grito vira um som molhado. Dois segundos de mastigar no escuro.]"]])
		Pacto.feed(100.0)
		Pacto.heal(100.0)
		await Dialogo.fade(0.0, 1.0)
		await Dialogo.falar([["ELA", "Tá vendo? Gente enche."]])
	await _gatilho("G_SaidaFenda").entrou
	await _maria()


func _maria() -> void:
	beat = 12
	for s in soldados:
		if is_instance_valid(s):
			s.queue_free()
	var amanhecer := create_tween().set_parallel()
	amanhecer.tween_property(env, "background_color", Color(0.26, 0.3, 0.42), 8.0)
	amanhecer.tween_property(env, "ambient_light_energy", 0.7, 8.0)
	amanhecer.tween_property(env, "fog_light_color", Color(0.35, 0.37, 0.48), 8.0)
	bando.barauna.deitar()
	bando.xexeu.deitar()
	bando.maria.global_position = _pos("Maria_Pedra")
	bando.maria.pose("Sitting_Idle")
	await Dialogo.falar([["", "[cascos marcados no chão e cartucho vazio: a volante foi embora]"]])
	await _interagivel("Maria_Pedra", "Pegar Maria no colo").usado
	_lock(true)
	await Dialogo.falar([
		["LAMPIÃO", "Nada foi um sonho..."],
		["LAMPIÃO", "Maria!"],
		["LAMPIÃO", "Tu é abençoada, lembra? Acorda!"],
		["LAMPIÃO", "Maria, meu amor, tu precisa acordar... por favor!"],
		["MARIA", "(olho meio aberto, vendo a costura) Tu... voltou."],
		["MARIA", "Fica com ele. Ele cuida de tu agora."],
	])
	bando.maria.morrer()
	await Dialogo.falar([["LAMPIÃO", "Meu amor... me desculpa... me desculpa."], ["", "[a barriga dela ronca, bem baixo. Um \"shhh\" que não é de ninguém.]"]])
	_lock(false)
	await _enterro()


func _enterro() -> void:
	beat = 13
	var sol := create_tween().set_parallel()
	sol.tween_property(env, "background_color", Color(0.55, 0.42, 0.32), 12.0)
	sol.tween_property(env, "ambient_light_energy", 1.1, 12.0)
	sol.tween_property(env, "fog_light_color", Color(0.6, 0.45, 0.35), 12.0)
	_gatilho("S11_Vulto").entrou.connect(func():
		var visao := _npc("Arvore", Color(0.35, 0.27, 0.2), "boina", false)
		get_tree().create_timer(0.7).timeout.connect(visao.queue_free))
	var covas := [0]
	for i in 3:
		var marker := "Cova_%d" % (i + 1)
		var area := _interagivel(marker, "Cavar")
		area.usado.connect(func():
			await Dialogo.segurar("Segure para cavar", 3.0)
			_cova(marker)
			covas[0] += 1)
	_interagivel("Cova_Vini", "Cavar para Vini").usado.connect(func():
		await Dialogo.segurar("Segure para cavar", 3.0)
		_cova("Cova_Vini")
		Historia.set_flag("vini", "enterrado"))
	await _until(func(): return covas[0] >= 3, 600.0)
	_lock(true)
	await Dialogo.falar([
		["LAMPIÃO", "Meus companheiros..."],
		["LAMPIÃO", "Obrigado por tudo que fizeram por mim."],
		["", "[ele pendura o chapéu de três medalhões na cruz de Maria e passa o terço pelo pescoço, por cima da costura]"],
		["ELA", "Irch... sério que você vai usar isso aí no pescoço?"],
		["ELA", "Er... eu não quero interromper, mas tô precisando bater um rango."],
		["LAMPIÃO", "Aguenta um pouquinho, que em troca..."],
		["LAMPIÃO", "Aquieta o facho. Tu vai ter o que comer."],
		["LAMPIÃO", "Eu vou te matar, Coronel!"],
		["ELA", "Bleh."],
		["LAMPIÃO", "Eu vou te dar todas as carnes podres que eu achar no caminho."],
	])
	Historia.set_flag("terco", "pescoco")
	await Dialogo.fade(1.0, 2.0)
	await Dialogo.cartao("Fim do capítulo 1\nO Sacrifício", 3.0)
	Historia.capitulo = 2
	Historia.save_game()
	Dialogo.limpar()
	Pacto.fome_ativa = true
	Pacto.stop()
	get_tree().change_scene_to_file("res://ui/menu.tscn")


func _cova(marker: String) -> void:
	var cova: Node3D = PROPS.build("cova", RandomNumberGenerator.new())
	add_child(cova)
	cova.global_position = _pos(marker)


func _set_veneno(on: bool) -> void:
	veneno = on
	Global.player.walk_speed = 2.2 if on else 5.0
	if on:
		_cambalear()


func _cambalear() -> void:
	while veneno:
		Global.player.look(Vector2(randf_range(-0.004, 0.004), randf_range(-0.003, 0.003)))
		await get_tree().process_frame


func _vini_facho(on: bool) -> void:
	if facho_light:
		facho_light.queue_free()
	if on:
		facho_light = OmniLight3D.new()
		facho_light.light_color = Color(1.0, 0.6, 0.25)
		facho_light.light_energy = 2.4
		facho_light.omni_range = 5.0
		facho_light.position = Vector3(0.3, 2.0, 0.2)
		facho_light.set_script(load("res://world/sertao/flicker.gd"))
		bando.vini.add_child(facho_light)


func _pegar_facho() -> void:
	var light := OmniLight3D.new()
	light.light_color = Color(1.0, 0.6, 0.25)
	light.light_energy = 2.2
	light.omni_range = 5.0
	light.position = Vector3(-0.4, -0.2, -0.3)
	light.set_script(load("res://world/sertao/flicker.gd"))
	Global.player.camera.add_child(light)
	await get_tree().create_timer(90.0).timeout
	if is_instance_valid(light):
		light.queue_free()


func _restos_soldados() -> void:
	for i in 4:
		var marker := "Carnica_%d" % (i + 1)
		var resto: Node3D = PROPS.build("corpo", RandomNumberGenerator.new())
		add_child(resto)
		resto.global_position = _pos(marker)
		_poca(_pos(marker) + Vector3.UP * 0.02, 1.0)
		var area := _interagivel(marker, "Comer")
		area.usado.connect(_comer_resto.bind(resto))


func _comer_resto(resto: Node3D) -> void:
	Pacto.comer()
	Pacto.hit_flash = 0.8
	Sustos.shake(0.1, 0.7)
	resto.queue_free()
	if not carnica_comida:
		carnica_comida = true
		Dialogo.falar([["ELA", "Morto de pouco. Ainda tá quente."], ["LAMPIÃO", "Tu disse carne podre."], ["ELA", "Tu disse. Eu como o que tiver."]])


func _desmoronar(marker: String, count: int) -> void:
	var base := _pos(marker)
	for i in count:
		var rock: Node3D = PROPS.build("pedra", RandomNumberGenerator.new())
		add_child(rock)
		rock.global_position = base + Vector3(randf_range(-1.5, 1.5), 3.5, randf_range(-1.0, 1.0))
		create_tween().tween_property(rock, "global_position:y", base.y + randf_range(0.0, 0.8), 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).set_delay(i * 0.12)
	Sustos.shake(0.15, 1.0)


func _acender_totem(totem: Node3D) -> void:
	var glow := StandardMaterial3D.new()
	glow.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	glow.albedo_color = Color(2.5, 2.5, 2.4)
	glow.disable_fog = true
	var olhos := totem.find_child("Olhos", true, false)
	if olhos:
		for mi in olhos.find_children("*", "MeshInstance3D", true, false):
			mi.material_override = glow
	else:
		for mi in totem.find_children("*", "MeshInstance3D", true, false):
			if mi.mesh is ArrayMesh and mi.material_override == PROPS.material("ash"):
				mi.material_override = glow


func _jorro(at: Vector3) -> void:
	var blood := CPUParticles3D.new()
	blood.amount = 90
	blood.lifetime = 1.4
	blood.direction = Vector3.UP
	blood.spread = 18.0
	blood.initial_velocity_min = 3.0
	blood.initial_velocity_max = 5.5
	blood.gravity = Vector3(0, -9.8, 0)
	var drop := SphereMesh.new()
	drop.radius = 0.035
	drop.height = 0.07
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.04, 0.0, 0.0)
	drop.material = mat
	blood.mesh = drop
	add_child(blood)
	blood.global_position = at
	get_tree().create_timer(3.0).timeout.connect(func(): blood.emitting = false)
	get_tree().create_timer(5.0).timeout.connect(blood.queue_free)


func _poca(at: Vector3, radius: float) -> void:
	var pool := MeshInstance3D.new()
	var disc := CylinderMesh.new()
	disc.top_radius = radius
	disc.bottom_radius = radius
	disc.height = 0.01
	pool.mesh = disc
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.05, 0.0, 0.0)
	mat.roughness = 0.1
	pool.material_override = mat
	add_child(pool)
	pool.global_position = at
	pool.scale = Vector3(0.1, 1, 0.1)
	create_tween().tween_property(pool, "scale", Vector3.ONE, 2.0)


func _tiro_em(from: Vector3) -> void:
	var flash := OmniLight3D.new()
	flash.light_color = Color(1.0, 0.75, 0.4)
	flash.light_energy = 7.0
	flash.omni_range = 14.0
	add_child(flash)
	flash.global_position = from
	create_tween().tween_property(flash, "light_energy", 0.0, 0.15)
	get_tree().create_timer(0.3).timeout.connect(flash.queue_free)
	var p := AudioStreamPlayer3D.new()
	p.stream = preload("res://resources/sfx/weapons/pistol.wav")
	add_child(p)
	p.global_position = from
	p.play()
	p.finished.connect(p.queue_free)


func _galope() -> void:
	var t := 0.0
	while beat == 2:
		t += get_process_delta_time()
		Global.player.camera.v_offset = sin(t * 11.0) * 0.06
		Global.player.camera.h_offset = sin(t * 5.5) * 0.03
		await get_tree().process_frame
	Global.player.camera.v_offset = 0.0
	Global.player.camera.h_offset = 0.0


func _god_mode() -> Timer:
	var timer := Timer.new()
	timer.wait_time = 0.1
	timer.timeout.connect(func():
		if is_instance_valid(Global.player):
			Global.player.current_health = 100.0)
	add_child(timer)
	timer.start()
	return timer


func _npc(marker: String, roupa: Color, chapeu: String, com_rifle := true) -> Node3D:
	var npc := HUMANO.new()
	npc.roupa = roupa
	npc.chapeu = chapeu
	npc.com_rifle = com_rifle
	add_child(npc)
	npc.global_position = _pos(marker)
	return npc


func _soldado(marker: String, accuracy: float, speed: float) -> CharacterBody3D:
	var s: CharacterBody3D = SOLDADO.instantiate()
	s.accuracy = accuracy
	s.move_speed = speed
	add_child(s)
	s.global_position = _pos(marker)
	soldados.append(s)
	return s


func _alvo(npc: Node3D) -> StaticBody3D:
	var alvo := StaticBody3D.new()
	alvo.set_script(ALVO)
	npc.add_child(alvo)
	return alvo


func _vivos() -> int:
	var count := 0
	for s in soldados:
		if is_instance_valid(s) and s.is_alive:
			count += 1
	return count


func _falar_npc(npc: Node3D, linhas: Array) -> void:
	var area := Area3D.new()
	area.set_script(INTERAGIVEL)
	area.texto = "Falar"
	area.raio = 2.2
	area.uma_vez = false
	npc.add_child(area)
	area.usado.connect(func(): Dialogo.falar(linhas))


func _interagivel(marker: String, text: String) -> Area3D:
	var area := Area3D.new()
	area.set_script(INTERAGIVEL)
	area.texto = text
	find_child(marker, true, false).add_child(area)
	return area


func _gatilho(trigger: String) -> Area3D:
	return find_child(trigger, true, false)


func _pos(marker: String) -> Vector3:
	return (find_child(marker, true, false) as Node3D).global_position


func _teleport(marker: String, yaw_deg: float) -> void:
	Global.player.global_position = _pos(marker) + Vector3.UP * 0.3
	Global.player.velocity = Vector3.ZERO
	Global.player.camera_pivot.rotation.y = deg_to_rad(yaw_deg)
	Global.player.camera_holder.rotation.x = 0.0


func _face_player_to(marker: String) -> void:
	var dir := _pos(marker) - Global.player.global_position
	Global.player.camera_pivot.rotation.y = atan2(-dir.x, -dir.z)


func _lock(locked: bool) -> void:
	Pacto.active = not locked
	if Global.player:
		Global.player.set_physics_process(not locked)
		Global.player.set_process_unhandled_input(not locked)


func _hud(on: bool) -> void:
	var hud := find_child("HUD", true, false)
	if hud:
		hud.visible = on


func _until(condition: Callable, timeout: float) -> void:
	var elapsed := 0.0
	while not condition.call() and elapsed < timeout:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
