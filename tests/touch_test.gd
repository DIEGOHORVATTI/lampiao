extends Node

var failures: Array[String] = []


func _ready() -> void:
	add_child(load("res://world/sertao/sertao.tscn").instantiate())
	await get_tree().create_timer(1.5).timeout

	var touch := get_node_or_null("/root/TouchControls")
	_check(touch != null, "TouchControls ativo")
	var screen := get_viewport().get_visible_rect().size

	_touch(0, Vector2(300, screen.y - 300), true)
	_drag(0, Vector2(300, screen.y - 420), Vector2(0, -120))
	await _frames(5)
	_check(Input.get_action_strength("forward") > 0.9, "joystick para cima anda para frente")
	_touch(0, Vector2(300, screen.y - 420), false)
	await _frames(2)
	_check(Input.get_action_strength("forward") == 0.0, "soltar o joystick para")

	var pivot: Node3D = Global.player.camera_pivot
	var yaw_before := pivot.rotation.y
	_touch(1, Vector2(screen.x * 0.6, 300), true)
	_drag(1, Vector2(screen.x * 0.6 + 100, 300), Vector2(100, 0))
	await _frames(2)
	_check(not is_equal_approx(pivot.rotation.y, yaw_before), "arrastar à direita gira a câmera")
	_touch(1, Vector2(screen.x * 0.6 + 100, 300), false)

	var fire_center := screen + Vector2(-200, -380) + Vector2(97, 97)
	_touch(2, fire_center, true)
	await _frames(2)
	_check(Input.is_action_pressed("fire"), "tocar em ATIRAR aciona fire")
	_touch(2, fire_center, false)
	_touch(0, Vector2(300, screen.y - 300), true)
	await _frames(1)
	_check(not Input.is_action_pressed("fire"), "toque fora do botão não atira")
	_touch(0, Vector2(300, screen.y - 300), false)

	get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT") if OS.has_environment("SHOT") else "user://touch.png")
	for f in failures:
		printerr("FALHOU: ", f)
	print("touch_test: ", "OK" if failures.is_empty() else "%d falha(s)" % failures.size())
	get_tree().quit(1 if failures else 0)


func _check(ok: bool, name: String) -> void:
	print(("  ✓ " if ok else "  ✗ ") + name)
	if not ok:
		failures.append(name)


func _touch(index: int, position: Vector2, pressed: bool) -> void:
	var e := InputEventScreenTouch.new()
	e.index = index
	e.position = _to_window(position)
	e.pressed = pressed
	Input.parse_input_event(e)


func _drag(index: int, position: Vector2, relative: Vector2) -> void:
	var e := InputEventScreenDrag.new()
	e.index = index
	e.position = _to_window(position)
	e.relative = _to_window(relative)
	Input.parse_input_event(e)


func _to_window(point: Vector2) -> Vector2:
	return point * Vector2(DisplayServer.window_get_size()) / get_viewport().get_visible_rect().size


func _frames(n: int) -> void:
	for i in n:
		await get_tree().process_frame
