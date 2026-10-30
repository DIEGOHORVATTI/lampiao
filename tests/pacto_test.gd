extends Node

static var restarted := false
var failures: Array[String] = []


func _ready() -> void:
	add_child(load("res://world/sertao/sertao.tscn").instantiate())
	await get_tree().create_timer(1.5).timeout
	if restarted:
		_check(not get_tree().paused and Pacto.active and Pacto.hunger < 5.0, "toque reinicia a fase")
		return _finish()

	_check(Pacto.active, "fase ativa o Pacto")
	_check(Pacto.hunger < 5.0, "começa com fome baixa")
	Pacto.hunger = 50.0
	Pacto.comer()
	_check(Pacto.hunger < 25.0, "comer carniça alimenta o Encosto")
	var corpo: Node3D = load("res://enemies/corpo_seco.tscn").instantiate()
	add_child(corpo)
	corpo.global_position = Global.player.global_position + Vector3(4, 0, 0)
	await get_tree().create_timer(0.3).timeout
	Global.player.camera_pivot.look_at(corpo.global_position, Vector3.UP)
	Global.player.camera_holder.rotation.x = 0.0
	_check(Poderes.tentaculos() and not corpo.is_alive, "tentáculos derrubam o corpo-seco à frente")
	Pacto.hunger = 60.0
	Global.player.global_position = corpo.global_position + Vector3(0.5, 0.5, 0)
	await get_tree().create_timer(0.4).timeout
	Global.activate_pressed.emit()
	await get_tree().process_frame
	_check(Pacto.hunger < 35.0 and not corpo.character_root.visible, "matar e comer o corpo-seco com USAR")
	var carnica := Node3D.new()
	carnica.set_script(load("res://world/carnica.gd"))
	add_child(carnica)
	carnica.global_position = Global.player.global_position + Vector3(0, -0.5, 0)
	Pacto.hunger = 70.0
	await get_tree().create_timer(0.4).timeout
	Global.activate_pressed.emit()
	await get_tree().process_frame
	_check(carnica.eaten and Pacto.hunger < 45.0, "comer carniça de bicho alimenta Ela")
	Pacto.hunger = 99.95
	await get_tree().create_timer(0.5).timeout
	_check(get_tree().paused, "fome cheia mata e pausa")
	_check(Pacto.death_screen.visible, "tela de morte aparece")
	if failures:
		return _finish()
	restarted = true
	var tap := InputEventScreenTouch.new()
	tap.pressed = true
	Input.parse_input_event(tap)


func _finish() -> void:
	for f in failures:
		printerr("FALHOU: ", f)
	print("pacto_test: ", "OK" if failures.is_empty() else "%d falha(s)" % failures.size())
	get_tree().quit(1 if failures else 0)


func _check(ok: bool, name: String) -> void:
	print(("  ✓ " if ok else "  ✗ ") + name)
	if not ok:
		failures.append(name)
