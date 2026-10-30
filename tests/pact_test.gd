extends Node

static var restarted := false
var failures: Array[String] = []


func _ready() -> void:
	add_child(load("res://game/world/sandbox/sandbox.tscn").instantiate())
	await get_tree().create_timer(1.5).timeout
	if restarted:
		_check(not get_tree().paused and Pact.active and Pact.hunger < 5.0, "toque reinicia a fase")
		return _finish()

	_check(Pact.active, "fase ativa o pacto")
	_check(Pact.hunger < 5.0, "começa com fome baixa")
	Pact.hunger = 50.0
	Pact.eat()
	_check(Pact.hunger < 25.0, "comer alimenta Ela")
	var soldier: Node3D = load("res://game/enemies/soldier.tscn").instantiate()
	soldier.accuracy = 0.0
	add_child(soldier)
	soldier.set_physics_process(false)
	soldier.global_position = Global.player.global_position + Vector3(4, 0, 0)
	await get_tree().create_timer(0.3).timeout
	Global.player.camera_pivot.look_at(soldier.global_position, Vector3.UP)
	Global.player.camera_holder.rotation.x = 0.0
	_check(Powers.tentacles() and not soldier.is_alive, "tentáculos derrubam o soldado à frente")
	Pact.hunger = 60.0
	Global.player.global_position = soldier.global_position + Vector3(0.5, 0.5, 0)
	await get_tree().create_timer(0.4).timeout
	Global.activate_pressed.emit()
	await get_tree().create_timer(1.2).timeout
	_check(Pact.hunger < 35.0 and soldier.character_root.scale.y < 0.5, "matar e deixar Ela comer o soldado")
	var carrion := Node3D.new()
	carrion.set_script(load("res://game/world/components/carrion.gd"))
	add_child(carrion)
	carrion.global_position = Global.player.global_position + Vector3(0, -0.5, 0)
	Pact.hunger = 70.0
	await get_tree().create_timer(0.4).timeout
	Global.activate_pressed.emit()
	await get_tree().process_frame
	_check(carrion.eaten and Pact.hunger < 45.0, "comer carniça de bicho alimenta Ela")
	Pact.hunger = 99.95
	await get_tree().create_timer(0.5).timeout
	_check(get_tree().paused, "fome cheia mata e pausa")
	_check(Pact.death_screen.visible, "tela de morte aparece")
	if failures:
		return _finish()
	restarted = true
	var tap := InputEventScreenTouch.new()
	tap.pressed = true
	Input.parse_input_event(tap)


func _finish() -> void:
	for f in failures:
		printerr("FALHOU: ", f)
	print("pact_test: ", "OK" if failures.is_empty() else "%d falha(s)" % failures.size())
	get_tree().quit(1 if failures else 0)


func _check(ok: bool, name: String) -> void:
	print(("  ✓ " if ok else "  ✗ ") + name)
	if not ok:
		failures.append(name)
