extends Node3D

const CORPO_SECO := preload("res://enemies/corpo_seco.tscn")
const CINEMATICA := preload("res://world/cap01/cinematica.gd")
const RELEVO := preload("res://world/cap01/relevo.gd")
const INTERAGIVEL := preload("res://world/interagivel.gd")
const CORPOS := [
	["Cansanção", "Vinte ano do meu lado, velho. Vinte ano."],
	["Sabiá", "Num vai ter mais cantoria, Sabiá."],
	["Gavião", "Tu atirava melhor que eu, mulher."],
	["Fumaça", "Perdoa, cabra."],
	["Pé-de-Serra", "", "Bilhete no bornal: \"Mãe, to bem. O capitão dis que no natal nos passa perto. Guarde o bode.\""],
	["Jurema", ""],
]
const BENEDITO_TIMEOUT := 30.0

var covered := 0
var cine: Node3D
var firing := false
var rifle_taken := false
var e4_spawned := 0
var e4_done := false


func _ready() -> void:
	await get_tree().process_frame
	_lock(true)
	Dialogo.fade(1.0, 0.0)
	await _prologo()
	await _lata()
	_acampamento()


func _prologo() -> void:
	cine = CINEMATICA.new()
	add_child(cine)
	cine.setup(self)
	await Dialogo.cartao("Na Grota da Baraúna,\nantes do galo cantar,\na volante fez a cerca\npra ninguém se levantar.\nMas um subiu da lama\nsem cabeça pra pensar.\n\n— Zé Mirim", 5.0)
	var floor_y := RELEVO.altura(-6, 80)
	cine.begin(Vector3(-6, floor_y, 80), -90.0)
	cine.dawn_rain()
	var rim := []
	for z in [80, 86, 92, 98, 104, 110]:
		rim.append(cine.soldier(Vector3(17, RELEVO.altura(17, z), z), PI / 2))
	var cansancao: Node3D = cine.soldier(Vector3(-4, floor_y, 79.5), -PI / 2)
	cine.look(28.0, 0.1)
	Dialogo.fade(0.0, 3.0)
	await Dialogo.falar([["", "[chuva na lona. Um bode longe. Mais nada.]"], ["CANSANÇÃO", "Capitão. Os cachorro calaram."]])
	await cine.lift_head(1.5)
	cine.sound(cine.PISTOL, cansancao.global_position + Vector3(6, 4, 0), 4.0)
	create_tween().tween_property(cansancao, "rotation:z", -PI / 2, 0.4)
	firing = true
	_fire_loop(rim)
	await Dialogo.falar([
		["GAVIÃO", "Sabiá! Sabiá, levanta, home!"],
		["JUREMA", "Capitão, eu atiro? Eu atiro?"],
		["LAMPIÃO", "Fica atrás da pedra, menino! Atrás da pedra!"],
	])
	cine.sound(cine.PISTOL, Vector3(16, RELEVO.altura(16, 90), 90), 8.0)
	await Dialogo.fade(0.55, 0.15, Color(0.45, 0.0, 0.0))
	AudioServer.set_bus_volume_db(0, -14.0)
	await cine.fall_to_side(0.6)
	cine.look(18.0, 0.8)
	await Dialogo.fade(0.7, 1.5, Color(0.04, 0.0, 0.0))
	var passer: Node3D = cine.soldier(Vector3(-3, floor_y, 77), PI)
	create_tween().tween_property(passer, "global_position", Vector3(-3, floor_y, 84), 6.0)
	cine.footsteps(passer.global_position, 10, 0.6)
	await Dialogo.falar([
		["ENCOSTO", "Ô, Lampião. Tá doendo?"],
		["LAMPIÃO", "Quem é?"],
		["ENCOSTO", "Quem sempre andou do teu lado. Tu é que nunca olhou pra trás."],
		["ENCOSTO", "Tão vindo com o facão. Primeiro a tua cabeça, depois a dos teus. Vão botar no sal e mostrar na feira, que nem bode."],
		["LAMPIÃO", "Meus cabra..."],
		["ENCOSTO", "Teus cabra já tão frio. Tu inda não. Tu quer morrer assim, de joelho na grota, com a cara na lama, vendido?"],
		["LAMPIÃO", "Quem vendeu?"],
		["ENCOSTO", "Me dá a carcaça que eu te dou a noite. Tu cobra quem te vendeu. Eu como."],
		["LAMPIÃO", "E o preço?"],
		["ENCOSTO", "Comida. Toda noite. E quando tua vingança acabar, o resto é meu."],
	])
	await Dialogo.segurar("Segure a tela para aceitar", 1.5, func(): Dialogo.falar([["ENCOSTO", "Eles tão chegando, garoto."]]))
	await Dialogo.falar([
		["LAMPIÃO", "Feito. Eu te alimento com qualquer carniça que tiver no caminho. Mas tu fica calado até eu ter minha vingança."],
		["ENCOSTO", "(riso baixo) Calado eu fico. Com fome, não."],
	])
	var executioner: Node3D = cine.soldier(Vector3(-5.2, floor_y, 80.6), -PI / 2)
	cine.footsteps(executioner.global_position, 3, 0.5)
	await Dialogo.fade(0.3, 1.0, Color(0.04, 0.0, 0.0))
	await cine.look(-60.0, 1.5)
	await get_tree().create_timer(1.2).timeout
	firing = false
	Dialogo.fade(1.0, 0.0)
	AudioServer.set_bus_volume_db(0, -80.0)
	for node in rim + [cansancao, passer, executioner]:
		node.queue_free()
	await get_tree().create_timer(3.0).timeout
	AudioServer.set_bus_volume_db(0, 0.0)
	cine.end()


func _fire_loop(rim: Array) -> void:
	while firing:
		var shooter: Node3D = rim[randi() % rim.size()]
		await cine.burst(shooter.global_position + Vector3(-0.5, 1.4, 0), randi_range(2, 6), 0.09)
		await get_tree().create_timer(randf_range(0.3, 1.2)).timeout


func _lata() -> void:
	cine.setup(self)
	var lata_pos := Vector3(-3, RELEVO.altura(-3, 3), 3)
	cine.begin(lata_pos, -45.0)
	cine.look(4.0, 0.1)
	var camp := []
	for p in [Vector3(2, -0.5, -1), Vector3(-1, -0.5, -2.2), Vector3(1.8, -0.5, 1.6)]:
		camp.append(cine.soldier(p, atan2(p.x, p.z)))
	camp.append(cine.soldier(Vector3(-8, 0, -2.5), PI / 2))
	await Dialogo.fade(0.6, 2.0, Color(0.5, 0.3, 0.04))
	await Dialogo.falar([
		["", "[líquido mexendo. Tudo âmbar e turvo, de dentro de uma lata de querosene. Luz de fogueira por um furo de prego.]"],
		["SOLDADO", "Sete lata, sete cabeça. Coronel paga por cabeça."],
		["SOLDADO", "Bota mais sal na do Capitão, que essa vai separada, na frente."],
		["TENENTE LAURINDO", "Ninguém mexe nessa lata. Essa é minha."],
		["SOLDADO", "E o eixo, Tenente?"],
		["TENENTE LAURINDO", "De manhã se conserta. Ninguém dorme longe da fogueira."],
		["ENCOSTO", "Shhh. Num se mexe, garoto. Inda não."],
	])
	await get_tree().create_timer(2.0).timeout
	for i in 3:
		cine.knock(lata_pos + Vector3.UP * 0.3)
		await get_tree().create_timer(1.1).timeout
	var sentinela: Node3D = cine.soldier(Vector3(-11, RELEVO.altura(-11, 9), 9), -PI * 0.75)
	var body: Node3D = cine.undead_walker(Vector3(-16, RELEVO.altura(-16, 12), 12))
	create_tween().tween_property(body, "global_position", lata_pos + Vector3(-0.6, 0, 0.9), 9.0)
	cine.footsteps(body.global_position, 12, 0.75)
	await Dialogo.falar([
		["SENTINELA", "Quem vem lá?"],
		["SENTINELA", "Quem vem lá, desgraça? ...Valei-me. Valei-me, Nossa Senhora..."],
	])
	cine.sound(cine.PISTOL, sentinela.global_position + Vector3.UP, 6.0)
	create_tween().tween_property(sentinela, "rotation:x", PI / 2, 0.5)
	await Dialogo.fade(0.0, 0.25)
	await cine.look(-10.0, 0.4)
	await Dialogo.falar([["", "[a lata cai. A tampa salta. A cabeça rola na terra.]"]])
	await get_tree().create_timer(2.0).timeout
	await Dialogo.falar([["", "[dois braços descem. Os dedos estão pretos, com raiz saindo de debaixo das unhas.]"]])
	body.queue_free()
	Dialogo.fade(0.5, 0.2, Color(0.5, 0.0, 0.0))
	await cine.lift_head(2.5)
	await Dialogo.fade(0.0, 0.8)
	for soldier in camp:
		var run := create_tween()
		run.tween_property(soldier, "global_position", soldier.global_position + Vector3(randf_range(-4, 4), 0, -30), 3.0)
		run.tween_callback(soldier.queue_free)
	cine.sound(cine.ENGINE, Vector3(0, 0, -10), 4.0)
	cine.end()
	_lock(false)
	Pacto.start_level(60.0)


func _acampamento() -> void:
	var lata := _interagivel("Lata", "Pegar o rifle")
	lata.usado.connect(func():
		rifle_taken = true
		Global.player.weapons_manager.switch_weapon(2)
		Dialogo.falar([["ENCOSTO", "Costurar cabeça dá fome, garoto. Fome, fome."]]))
	_interagivel("Barraca", "Ler os papéis").usado.connect(func(): Dialogo.falar([
		["", "Relação do serviço. Grota da Baraúna, 28 de julho."],
		["", "1. Vulgo Lampião (lata separada). 2. Cansanção. 3. Sabiá. 4. Mulher dita Gavião. 5. Fumaça. 6. Pé-de-Serra. 7. Um menino. Não se sabe o nome."],
		["", "Coronel T. Valadares, Fazenda Jatobá. Serviço feito. Sete cabeças. Exposição na feira de Santa Luzia domingo. Ten. L. Brás."],
	]))
	_interagivel("CruzEnjeitados", "Ler a cruz").usado.connect(func(): Dialogo.falar([["", "AQUI A TERRA NÃO QUIS. NÃO REZE."]]))
	_gatilho("G_Carroca").entrou.connect(_benedito)
	_gatilho("G_Cemiterio").entrou.connect(_enjeitados)
	_gatilho("G_Grota").entrou.connect(_grota)
	_gatilho("G_Saida").entrou.connect(_saida)
	_gatilho("G_Estrada").entrou.connect(_amanhecer)
	await Dialogo.falar([
		["TENENTE LAURINDO", "É assombração! Pro caminhão! Larga essa merda e sobe!"],
		["ENCOSTO", "Teu rifle tá ali no chão, garoto. Pega. Num é à toa que chamam tu de Lampião."],
	])


func _benedito() -> void:
	await Dialogo.falar([
		["", "[gemido debaixo da carroça tombada]"],
		["BENEDITO", "Não! Pelo amor de Deus, Capitão. Pelo amor da sua mãe."],
		["LAMPIÃO", "Minha mãe morreu de desgosto faz dezessete ano. Meu pai, macaco matou."],
		["BENEDITO", "Eu num tava lá. Eu tenho dezenove ano. Eu entrei semana passada, Capitão, eu nem atirei, eu juro..."],
		["ENCOSTO", "Olha que coisa. Novinho. Carne de menino é macia, garoto. Abre a boca, que eu faço o resto."],
		["BENEDITO", "Com quem o senhor tá falando?"],
	])
	var choice := await Dialogo.escolher(["Guardar a peixeira", "Deixar ele comer"], BENEDITO_TIMEOUT, func(): Pacto.hunger = minf(99.0, Pacto.hunger + 10.0))
	if choice == 0:
		Historia.set_flag("benedito", "poupado")
		await Dialogo.falar([
			["", "[as raízes estalam; a carroça sobe; Benedito se arrasta e foge pela estrada]"],
			["LAMPIÃO", "Corre. E conta pra todo mundo o que tu viu."],
			["ENCOSTO", "Tu vai se arrepender de cada um que tu solta, garoto. Cada um."],
		])
	else:
		Historia.set_flag("benedito", "comido")
		Historia.add_marca()
		await Dialogo.fade(1.0, 0.3, Color(0.25, 0.0, 0.0))
		await Dialogo.falar([["", "[o grito. Dois segundos de mastigar.]"]])
		Pacto.feed(100.0)
		Pacto.heal(100.0)
		await Dialogo.fade(0.0, 1.0)
		await Dialogo.falar([["ENCOSTO", "Tá vendo? Gente enche."]])


func _enjeitados() -> void:
	await Dialogo.falar([
		["", "[os grilos param. Um estalo de couro seco, como sola velha dobrando.]"],
		["ENCOSTO", "Tá ouvindo? Pararam os grilo. Chegou visita."],
	])
	_spawn("E1")
	Dialogo.mostrar_prompt("RAÍZES derrubam o corpo-seco. Depois, USAR para comer.")
	await get_tree().create_timer(6.0).timeout
	Dialogo.esconder_prompt()
	_spawn("E2a")
	await get_tree().create_timer(10.0).timeout
	_spawn("E2b")


func _grota() -> void:
	for i in CORPOS.size():
		var corpo := _interagivel("Corpo_%d" % i, "Cobrir")
		corpo.usado.connect(_cobrir.bind(i))
	await Dialogo.falar([["", "[asas. Muitas asas. Os urubus explodem em revoada.]"]])
	for name in ["E3a", "E3b", "E3c"]:
		_spawn(name)


func _cobrir(index: int) -> void:
	var line: String = CORPOS[index][1]
	if CORPOS[index].size() > 2:
		await Dialogo.falar([["", "[Lampião tira o chapéu]"], ["", CORPOS[index][2]]])
	elif line != "":
		await Dialogo.falar([["LAMPIÃO", line]])
	else:
		await Dialogo.falar([["", "[Lampião tira o chapéu e fica um tempo]"]])
	covered += 1
	if covered == CORPOS.size():
		_jurema()


func _jurema() -> void:
	var jurema := _build_jurema()
	var spot: Node3D = find_child("JuremaPos", true, false)
	jurema.global_position = spot.global_position
	await Dialogo.falar([
		["", "[um assovio de \"Mulher Rendeira\" vem de trás]"],
		["JUREMA", "Capitão... cadê minha cabeça?"],
		["LAMPIÃO", "Levaram, menino. Levaram de todos nós."],
		["JUREMA", "Tá frio aqui."],
		["LAMPIÃO", "Eu vou buscar. Juro por meu Padim. Vou buscar e enterrar em chão bento."],
		["JUREMA", "O senhor tá frio também."],
	])
	var exit: Node3D = find_child("JuremaSaida", true, false)
	var walk := create_tween()
	walk.tween_property(jurema, "global_position", exit.global_position, 8.0)
	walk.tween_callback(jurema.queue_free)


func _saida() -> void:
	while e4_spawned < 5 and not e4_done:
		if _alive_count() < 3:
			_spawn("E4a" if e4_spawned % 2 == 0 else "E4b")
			e4_spawned += 1
		await get_tree().create_timer(3.0).timeout


func _amanhecer() -> void:
	e4_done = true
	var env: Environment = find_child("WorldEnvironment", true, false).environment
	var dawn := create_tween().set_parallel()
	dawn.tween_property(env, "background_color", Color(0.18, 0.22, 0.38), 6.0)
	dawn.tween_property(env, "ambient_light_energy", 0.8, 6.0)
	dawn.tween_property(env, "fog_light_color", Color(0.3, 0.32, 0.45), 6.0)
	await Dialogo.falar([["ENCOSTO", "Dia, garoto. De dia eu durmo. E tu cai."]])
	_lock(true)
	await Dialogo.fade(1.0, 3.0)
	await Dialogo.falar([["DORINHA", "Valei-me, minha Nossa Senhora. É ele."]])
	await Dialogo.cartao("Fim do capítulo 1\nA Cabeça", 3.0)
	Historia.capitulo = 2
	Historia.save_game()
	Dialogo.limpar()
	get_tree().change_scene_to_file("res://ui/menu.tscn")


func _lock(locked: bool) -> void:
	Pacto.active = not locked
	if Global.player:
		Global.player.set_physics_process(not locked)
		Global.player.set_process_unhandled_input(not locked)



func _spawn(marker_name: String) -> void:
	var marker: Node3D = find_child(marker_name, true, false)
	var corpo: Node3D = CORPO_SECO.instantiate()
	add_child(corpo)
	corpo.global_position = marker.global_position


func _alive_count() -> int:
	var count := 0
	for child in get_children():
		if child is CharacterBody3D and child.is_alive:
			count += 1
	return count


func _interagivel(marker_name: String, text: String) -> Area3D:
	var marker: Node3D = find_child(marker_name, true, false)
	var area := Area3D.new()
	area.set_script(INTERAGIVEL)
	area.texto = text
	marker.add_child(area)
	return area


func _gatilho(marker_name: String) -> Area3D:
	return find_child(marker_name, true, false)


func _build_jurema() -> Node3D:
	var root := Node3D.new()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.6, 0.7, 0.85, 0.55)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.emission_enabled = true
	mat.emission = Color(0.4, 0.5, 0.7)
	mat.emission_energy_multiplier = 0.6
	var body := MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.2
	capsule.height = 1.25
	body.mesh = capsule
	body.material_override = mat
	body.position.y = 0.62
	root.add_child(body)
	var hat := MeshInstance3D.new()
	var brim := CylinderMesh.new()
	brim.top_radius = 0.22
	brim.bottom_radius = 0.38
	brim.height = 0.12
	hat.mesh = brim
	hat.material_override = mat
	hat.position.y = 1.3
	root.add_child(hat)
	add_child(root)
	return root
