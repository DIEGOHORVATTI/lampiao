extends Node

var failures: Array[String] = []


func _ready() -> void:
	add_child(load("res://world/sertao/sertao.tscn").instantiate())
	await get_tree().create_timer(1.5).timeout
	for e in get_tree().get_nodes_in_group("inimigos"):
		e.queue_free()
	var soldado: CharacterBody3D = load("res://enemies/soldado.tscn").instantiate()
	add_child(soldado)
	var forward: Vector3 = -Global.player.camera.global_basis.z
	forward.y = 0
	soldado.global_position = Global.player.global_position + forward.normalized() * 9.0
	soldado.accuracy = 5.0
	var health_before: float = Global.player.current_health
	await get_tree().create_timer(4.0).timeout
	if OS.has_environment("SHOT"):
		get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT"))
	_check(soldado.alerted_until > 0.0, "soldado vê o jogador")
	_check(Global.player.current_health < health_before, "soldado atira e acerta")

	var hearer: CharacterBody3D = load("res://enemies/soldado.tscn").instantiate()
	add_child(hearer)
	hearer.global_position = Global.player.global_position - forward.normalized() * 20.0
	await get_tree().create_timer(0.5).timeout
	Global.muzzle_flash.emit()
	_check(hearer.alerted_until > Time.get_ticks_msec() / 1000.0, "clarão do tiro alerta soldado a 20 m")

	Global.player.current_health = 100.0
	soldado.get_damage(1000.0, Vector3.ZERO)
	await get_tree().create_timer(0.5).timeout
	_check(not soldado.is_alive and soldado.collision_layer == 0, "soldado morre com tiro")
	Global.player.global_position = soldado.global_position + Vector3(0.6, 0.5, 0)
	Pacto.hunger = 70.0
	await get_tree().create_timer(0.4).timeout
	Global.activate_pressed.emit()
	await get_tree().process_frame
	_check(Pacto.hunger < 45.0, "Ela come o soldado morto")

	for f in failures:
		printerr("FALHOU: ", f)
	print("soldado_test: ", "OK" if failures.is_empty() else "%d falha(s)" % failures.size())
	get_tree().quit(1 if failures else 0)


func _check(ok: bool, name: String) -> void:
	print(("  ✓ " if ok else "  ✗ ") + name)
	if not ok:
		failures.append(name)
