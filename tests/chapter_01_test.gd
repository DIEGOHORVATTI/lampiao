extends Node

var failures: Array[String] = []
var level: Node
var shots_taken := {}


func _ready() -> void:
	Engine.time_scale = 6.0
	Engine.physics_ticks_per_second = 360
	Story.reset()
	level = load("res://game/world/chapters/chapter_01/chapter_01.tscn").instantiate()
	add_child(level)
	_god_mode()

	await _until(func(): return level.beat == 1 and Pact.active, 120.0)
	_check(not Pact.hunger_enabled, "fome escondida antes dela acordar")
	_shot("fazenda")
	await _use("CoinBag")
	await _until(func(): return Story.flag("farm_benedito") != "", 90.0)
	_check(Story.flag("farm_benedito") == "spared", "Benedito poupado na fazenda")
	await _until(func(): return level.soldiers.size() >= 7, 60.0)
	_shot("tiroteio")
	await _go("BackDoorTrigger")
	await _go("MariaShotTrigger")
	await _until(func(): return not Dialogue.talking, 120.0)
	await get_tree().create_timer(2.0).timeout
	await _go("HorsesTrigger")
	await _until(func(): return level.beat == 3, 120.0)
	_check(level.beat == 3, "fuga a cavalo chega na caverna")
	await _until(func(): return Pact.active, 60.0)
	_shot("acampamento")
	await _use("Maria")
	await _until(func(): return Story.flag("rosary") == "wrist", 120.0)
	_check(Story.flag("rosary") == "wrist", "Maria empresta o terço")
	await _until(func(): return not Dialogue.talking, 120.0)
	await _use("SoupBowl")
	await _until(func(): return level.beat == 4 and Pact.active, 120.0)
	_check(level.poisoned, "veneno deixa Lampião lento")
	await _use("Maria")
	await _until(func(): return level.soldiers.size() >= 2, 120.0)
	_shot("veneno")
	_kill_all()
	await _until(func(): return level.cast.vini.visible and not Dialogue.talking, 120.0)
	await _go("RockfallTrigger")
	await _until(func(): return level.beat == 5, 30.0)
	for point in ["ViniPath_1", "ViniPath_2", "ViniPath_3", "ViniPath_4"]:
		await _go(point)
		await get_tree().create_timer(3.0).timeout
		_kill_all()
	_shot("galeria")
	await _until(func(): return level.cast.vini.global_position.distance_to(_pos("ViniHall")) < 1.0, 120.0)
	await _go("HallTrigger")
	await _until(func(): return level.beat == 6 and Dialogue.prompt.text.begins_with(tr("CH01_BETRAYAL_07").left(10)), 120.0)
	_check(true, "traição de Vini no Salão dos Ídolos")
	_shot("duelo")
	level.vini_hits = 2
	await _until(func(): return level.beat == 7, 60.0)
	await get_tree().create_timer(4.0).timeout
	_shot("degola")
	_check(Story.flag("lens") == "cracked", "degola racha a lente")
	await _until(func(): return level.beat == 8 and Pact.active, 180.0)
	_check(Pact.hunger_enabled and Pact.hunger > 90.0 and Powers.entity_mode, "Modo Ela com fome cheia")
	_shot("modo_ela")
	await _until(func(): return level.soldiers.size() >= 4, 30.0)
	for s in level.soldiers:
		if is_instance_valid(s) and s.is_alive:
			Global.player.global_position = s.global_position + Vector3(1.2, 0.4, 0)
			Global.player.camera_pivot.look_at(s.global_position, Vector3.UP)
			await get_tree().create_timer(0.3).timeout
			Powers.cooldown = 0.0
			Powers.tentacles()
			await get_tree().create_timer(0.4).timeout
			Global.activate_pressed.emit()
			await get_tree().create_timer(0.3).timeout
	_check(Pact.hunger <= 60.0, "Ela come os soldados (fome desce)")
	await _until(func(): return level.beat == 9, 180.0)
	_check(not Powers.entity_mode and absf(Pact.hunger - 50.0) < 1.0, "volta a Lampião com fome 50")
	await _until(func(): return Pact.active, 120.0)
	_shot("nos")
	await _use("ViniBody")
	await get_tree().create_timer(0.5).timeout
	_check(Story.flag("vini") == "forgiven", "fechar os olhos de Vini")
	await _until(func(): return level.beat == 10, 30.0)
	Pact.hunger = 70.0
	await _use("Remains_1")
	_check(Pact.hunger < 45.0, "comer os restos de soldado")
	await _go("ScareSlabBreathing")
	await get_tree().create_timer(5.0).timeout
	_kill_all()
	await _use("TorchPickup")
	await _go("RosaryTrigger")
	await get_tree().create_timer(2.0).timeout
	_shot("fenda")
	_kill_all()
	await _go("BeneditoTrigger")
	await _until(func(): return Dialogue.choice_buttons[0].visible, 240.0)
	Input.action_press("choice_1")
	await _until(func(): return Story.flag("benedito") != "", 20.0)
	Input.action_release("choice_1")
	_check(Story.flag("benedito") == "spared", "Benedito poupado na fenda")
	await _until(func(): return not Dialogue.talking, 60.0)
	await _go("CreviceExitTrigger")
	await _until(func(): return level.beat == 12, 60.0)
	await _use("MariaRock")
	await _until(func(): return level.beat == 13, 180.0)
	_shot("enterro")
	for grave in ["Grave_1", "Grave_2", "Grave_3"]:
		await _go(grave)
		Global.activate_pressed.emit()
		await get_tree().process_frame
		Input.action_press("activate")
		await get_tree().create_timer(4.0).timeout
		Input.action_release("activate")
	await _until(func(): return Story.chapter == 2, 300.0)
	_check(Story.chapter == 2, "capítulo termina e salva o cap. 2")
	Engine.time_scale = 1.0
	Engine.physics_ticks_per_second = 60
	for f in failures:
		printerr("FALHOU: ", f)
	print("chapter_01_test: ", "OK" if failures.is_empty() else "%d falha(s)" % failures.size())
	Engine.get_main_loop().quit(1 if failures else 0)


func _kill_all() -> void:
	for s in level.soldiers:
		if is_instance_valid(s) and s.is_alive:
			s.get_damage(1000.0, Vector3.ZERO)


func _god_mode() -> void:
	var timer := Timer.new()
	timer.wait_time = 0.05
	timer.timeout.connect(func():
		if is_instance_valid(Global.player):
			Global.player.current_health = 100.0
			Global.player.is_alive = true
		if Pact.hunger > 95.0 and not Powers.entity_mode:
			Pact.hunger = 60.0)
	add_child(timer)
	timer.start()


func _go(marker: String) -> void:
	Global.player.global_position = _pos(marker) + Vector3.UP * 0.6
	Global.player.velocity = Vector3.ZERO
	await get_tree().create_timer(0.6).timeout


func _use(marker: String) -> void:
	var node: Node = level.find_child(marker, true, false)
	await _until(func(): return node.get_children().any(func(c): return c is Area3D and c.has_signal("usado")), 240.0)
	Global.player.global_position = _pos(marker) + Vector3(0, 0.6, 6.0)
	await get_tree().create_timer(0.3).timeout
	await _go(marker)
	Global.activate_pressed.emit()
	await get_tree().process_frame


func _pos(marker: String) -> Vector3:
	return (level.find_child(marker, true, false) as Node3D).global_position


func _shot(name: String) -> void:
	if not OS.has_environment("SHOT"):
		return
	await get_tree().process_frame
	get_viewport().get_texture().get_image().save_png("%s-%s.png" % [OS.get_environment("SHOT"), name])


func _until(condition: Callable, timeout: float) -> void:
	var elapsed := 0.0
	while not condition.call() and elapsed < timeout:
		await get_tree().process_frame
		elapsed += get_process_delta_time()


func _check(ok: bool, name: String) -> void:
	var detail := "" if ok else "  [beat=%d active=%s talking=%s sub=%s prompt=%s pos=%s]" % [level.beat, Pact.active, Dialogue.talking, Dialogue.subtitle.text.left(40), Dialogue.prompt.text.left(30), Global.player.global_position]
	print(("  ✓ " if ok else "  ✗ ") + name + detail)
	if not ok:
		failures.append(name)
