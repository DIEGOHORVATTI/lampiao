extends Node

static var phase := 0
var failures: Array[String] = []
var level: Node


func _ready() -> void:
	Engine.time_scale = 8.0
	Historia.reset()
	level = load("res://world/cap01/cap01.tscn").instantiate()
	add_child(level)
	await get_tree().create_timer(2.0).timeout
	_check(not Pacto.active, "prólogo trava o jogador")

	await _until(func(): return Dialogo.prompt.text.begins_with("Segure"), 120.0)
	Input.action_press("activate")
	await _until(func(): return Pacto.active, 120.0)
	Input.action_release("activate")
	_check(Pacto.active and Pacto.hunger >= 59.0, "trato aceito, fome começa em 60")
	_check(Pacto.kerosene == 0.0, "lampião começa seco")

	_god_mode()
	await _go("Lata")
	await _activate()
	_check(Pacto.kerosene >= 69.0, "encher o lampião na lata")

	await _go("G_Carroca")
	await _until(func(): return Dialogo.choice_buttons[0].visible, 240.0)
	Input.action_press("escolha_1")
	await get_tree().process_frame
	await get_tree().process_frame
	Input.action_release("escolha_1")
	await _until(func(): return Historia.flag("benedito") != "", 10.0)
	_check(Historia.flag("benedito") == "poupado", "poupar Benedito grava a flag")

	await _go("G_Cemiterio")
	await get_tree().create_timer(30.0).timeout
	_check(_enemy_count() >= 1, "corpo-seco aparece no cemitério")

	await _go("G_Grota")
	await get_tree().create_timer(2.0).timeout
	for i in 6:
		await _go("Corpo_%d" % i)
		await _activate()
		await _until(func(): return not Dialogo.talking, 90.0)
	await _until(func(): return level.covered == 6, 240.0)
	_check(level.covered == 6, "cobrir os seis corpos")

	await _go("G_Saida")
	await get_tree().create_timer(4.0).timeout
	await _go("G_Estrada")
	await _until(func(): return Historia.capitulo == 2, 240.0)
	_check(Historia.capitulo == 2, "capítulo termina e salva o cap. 2")
	Engine.time_scale = 1.0
	for f in failures:
		printerr("FALHOU: ", f)
	print("cap01_test: ", "OK" if failures.is_empty() else "%d falha(s)" % failures.size())
	Engine.get_main_loop().quit(1 if failures else 0)


func _god_mode() -> void:
	var timer := Timer.new()
	timer.wait_time = 0.1
	timer.timeout.connect(func():
		if is_instance_valid(Global.player):
			Global.player.current_health = 100.0
		Pacto.hunger = minf(Pacto.hunger, 50.0))
	add_child(timer)
	timer.start()


func _go(marker: String) -> void:
	var node: Node3D = level.find_child(marker, true, false)
	Global.player.global_position = node.global_position + Vector3.UP * 0.5
	await get_tree().create_timer(0.5).timeout


func _activate() -> void:
	Global.activate_pressed.emit()
	await get_tree().process_frame


func _enemy_count() -> int:
	return level.find_children("*", "CharacterBody3D", true, false).filter(func(n): return n != Global.player).size()


func _until(condition: Callable, timeout: float) -> void:
	var elapsed := 0.0
	while not condition.call() and elapsed < timeout:
		await get_tree().process_frame
		elapsed += get_process_delta_time()


func _check(ok: bool, name: String) -> void:
	print(("  ✓ " if ok else "  ✗ ") + name)
	if not ok:
		failures.append(name)
