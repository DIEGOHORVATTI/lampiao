extends Node


func _ready() -> void:
	add_child(load("res://game/world/sandbox/sandbox.tscn").instantiate())
	await get_tree().create_timer(1.5).timeout
	Settings.values.third_person = true
	Settings.changed.emit()
	Input.action_press("forward")
	await get_tree().create_timer(1.2).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/tp-walk.png")
	Input.action_release("forward")
	await get_tree().create_timer(1.0).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/tp-idle.png")
	get_tree().quit()
