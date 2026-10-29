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
	_check(Pacto.hunger < 5.0 and Pacto.kerosene > 95.0, "começa com fome baixa e querosene cheio")
	Pacto.hunger = 50.0
	Global.enemy_killed.emit()
	_check(Pacto.hunger < 25.0, "carniça alimenta o Encosto")
	Pacto.kerosene = 10.0
	var can: Node3D = find_child("Querosene", true, false)
	Global.player.global_position = can.global_position + Vector3.UP
	await get_tree().create_timer(0.6).timeout
	_check(Pacto.kerosene > 50.0 and not is_instance_valid(can), "lata de querosene recarrega o lampião")
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
