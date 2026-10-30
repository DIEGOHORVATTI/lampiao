extends Node


func _ready() -> void:
	Engine.time_scale = 3.0
	Historia.reset()
	add_child(load("res://world/cap01/cap01.tscn").instantiate())
	for i in 22:
		await get_tree().create_timer(6.0 * Engine.time_scale).timeout
		if Dialogo.hold_bar.visible:
			Input.action_press("activate")
		elif Input.is_action_pressed("activate"):
			Input.action_release("activate")
		get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/cine/%02d.png" % i)
		if Pacto.active:
			break
	get_tree().quit()
