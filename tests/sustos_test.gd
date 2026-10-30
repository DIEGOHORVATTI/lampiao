extends Node

var failures: Array[String] = []


func _ready() -> void:
	add_child(load("res://world/sertao/sertao.tscn").instantiate())
	await get_tree().create_timer(1.5).timeout

	Sustos.jumpscare("corpo_seco")
	await get_tree().create_timer(0.1).timeout
	_check(Sustos.face_rect.visible and Global.player.camera.h_offset != 0.0, "jumpscare mostra rosto e treme a câmera")
	if OS.has_environment("SHOT"):
		get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT") + "-jumpscare.png")
	await get_tree().create_timer(1.0).timeout
	_check(not Sustos.face_rect.visible and Global.player.camera.h_offset == 0.0, "jumpscare some e câmera volta")

	var shadow := Sustos.vulto()
	await get_tree().create_timer(0.6).timeout
	var to_shadow: Vector3 = (shadow.global_position - Global.player.global_position).normalized()
	var forward: Vector3 = -Global.player.camera.global_basis.z
	var angle := rad_to_deg(acos(clampf(forward.dot(to_shadow), -1.0, 1.0)))
	_check(is_instance_valid(shadow) and angle > 30.0 and angle < 60.0, "vulto aparece na borda da visão")
	if OS.has_environment("SHOT"):
		get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT") + "-vulto.png")
	await get_tree().create_timer(1.6).timeout
	_check(not is_instance_valid(shadow), "vulto some")

	var lights := find_children("*", "OmniLight3D", true, false).filter(func(l): return l.global_position.distance_to(Global.player.global_position) < 18.0 and l.name != "Clarao")
	Sustos.apagar_luzes(18.0, 1.0)
	await get_tree().create_timer(0.6).timeout
	_check(lights.size() > 0 and lights.all(func(l): return l.light_energy == 0.0), "apagão desliga as fogueiras perto")
	await get_tree().create_timer(1.0).timeout
	_check(lights.all(func(l): return l.light_energy > 0.0), "fogueiras voltam")

	for kind in ["passos", "batida", "sussurro", "respiracao"]:
		Sustos.som_atras(kind)
	await get_tree().create_timer(0.2).timeout
	_check(find_children("*", "AudioStreamPlayer3D", true, false).size() >= 3, "sons tocam atrás do jogador")

	for f in failures:
		printerr("FALHOU: ", f)
	print("sustos_test: ", "OK" if failures.is_empty() else "%d falha(s)" % failures.size())
	get_tree().quit(1 if failures else 0)


func _check(ok: bool, name: String) -> void:
	print(("  ✓ " if ok else "  ✗ ") + name)
	if not ok:
		failures.append(name)
