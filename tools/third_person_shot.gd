extends Node


func _ready() -> void:
	add_child(load("res://game/world/sandbox/sandbox.tscn").instantiate())
	await get_tree().create_timer(1.5).timeout
	Settings.values.third_person = true
	Settings.changed.emit()
	Global.player.weapons_manager.switch_weapon(2)
	await get_tree().create_timer(0.8).timeout
	Input.action_press("forward")
	await get_tree().create_timer(1.2).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/tp-walk.png")
	Input.action_release("forward")
	await get_tree().create_timer(1.0).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/tp-idle.png")
	var view: ThirdPersonView = Global.player.get_children().filter(func(n): return n is ThirdPersonView)[0]
	view.set_physics_process(false)
	var side: Vector3 = Global.player.global_position + Global.player.camera_pivot.global_basis.x * 2.2 + Vector3.UP * 1.5
	Global.player.camera.global_position = side
	Global.player.camera.look_at(Global.player.global_position + Vector3.UP * 1.3)
	await get_tree().create_timer(0.3).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/tp-side.png")
	get_tree().quit()
