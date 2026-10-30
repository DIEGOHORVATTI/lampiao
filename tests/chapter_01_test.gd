extends Node

var failures: Array[String] = []
var level: Node
var shots_taken := {}


func _ready() -> void:
	Engine.time_scale = 6.0
	Engine.physics_ticks_per_second = 360
	Story.save_path = "user://test_save.json"
	Story.reset()
	level = load("res://game/world/chapters/chapter_01/chapter_01.tscn").instantiate()
	add_child(level)
	_god_mode()

	await _until(func(): return level.beat == 1, 120.0)
	_check(not Pact.active and level.cinematic_camera != null, "abertura é prévia cinematográfica, sem controle")
	_shot("previa")
	await _until(func(): return level.beat == 4 and Pact.active, 400.0)
	_check(not Pact.hunger_enabled, "fome escondida antes dela acordar")
	_check(GameUI.objective_label.text != "", "objetivo aparece na tela")
	_check(Global.player.get_viewport().get_camera_3d() == Global.player.camera, "controle começa na caverna")
	_shot("acampamento")
	_check(not level.find_child("CampfireLit", true, false).visible, "fogueira apagada na chegada")
	await _use("Campfire")
	await _use("Maria")
	await _until(func(): return Pact.active and not Dialogue.talking, 120.0)
	await _go("CoinPile")
	await _until(func(): return level.trail != null and is_instance_valid(level.trail), 120.0)
	_check(level.trail.get_child_count() > 3, "rastro de sangue até a sopa")
	await _until(func(): return level.find_child("SoupBowl", true, false).get_child_count() > 0, 120.0)
	await _use("SoupBowl")
	await _until(func(): return level.beat == 5 and Pact.active, 120.0)
	_shot("veneno")
	await _go("Maria")
	await get_tree().create_timer(1.0).timeout
	await _until(func(): return not Dialogue.talking, 60.0)
	await _go("Stars")
	await _until(func(): return level.beat == 6 and Pact.active, 180.0)
	_check(level.lantern != null, "lanterna no túnel")
	await _go("Tunnel_2")
	await _go("Tunnel_3")
	await _until(func(): return not Dialogue.talking, 60.0)
	await _go("DistrustTrigger")
	await _until(func(): return level.beat == 7 and Pact.active, 180.0)
	_shot("tunel")
	await _go("HallTrigger")
	await _go("HallView")
	await _until(func(): return level.beat == 7 and Pact.active and GameUI.objective_label.text == tr("CH01_GOAL_FIGHT"), 120.0)
	_check(true, "luta com Vini no salão dos ídolos")
	_shot("luta")
	level.vini_hits = 3
	await _until(func(): return level.beat == 8, 60.0)
	await get_tree().create_timer(4.0).timeout
	_shot("degola")
	await _until(func(): return level.beat == 9 and Pact.active, 240.0)
	_check(Pact.hunger_enabled and Pact.hunger > 90.0 and Powers.entity_mode, "Ela acorda faminta")
	_shot("ela")
	await _until(func(): return level.soldiers.size() >= 4, 30.0)
	_kill_all()
	await _until(func(): return level.beat == 10, 240.0)
	await _until(func(): return level.beat == 11 and Pact.active, 180.0)
	_check(not Powers.entity_mode and Story.flag("lens") == "cracked", "volta a Lampião, de óculos trincados")
	await _go("CampReturnTrigger")
	await _until(func(): return level.beat == 12 and Pact.active, 240.0)
	_shot("enterro")
	for grave in ["Grave_1", "Grave_2", "Grave_3", "Grave_4"]:
		await _hold_at(grave)
	await _until(func(): return Pact.active and GameUI.objective_label.text == tr("CH01_GOAL_LEAVE"), 120.0)
	Input.action_press("activate")
	await _until(func(): return Story.flag("rosary") == "neck", 30.0)
	Input.action_release("activate")
	_check(Story.flag("rosary") == "neck", "terço de Maria no pescoço")
	await _use("Kepi")
	await _until(func(): return Story.chapter == 2, 300.0)
	_check(Story.chapter == 2, "capítulo termina e salva o cap. 2")
	Engine.time_scale = 1.0
	Engine.physics_ticks_per_second = 60
	for f in failures:
		printerr("FALHOU: ", f)
	print("chapter_01_test: ", "OK" if failures.is_empty() else "%d falha(s)" % failures.size())
	Engine.get_main_loop().quit(1 if failures else 0)


func _hit_all() -> void:
	for target in level.find_children("*", "StaticBody3D", true, false):
		if target is HitTarget:
			target.hit.emit()


func _hold_at(marker: String) -> void:
	await _use(marker)
	Input.action_press("activate")
	await get_tree().create_timer(4.0).timeout
	Input.action_release("activate")


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
	await _until(func(): return node.get_children().any(func(c): return c is Interactable), 240.0)
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
