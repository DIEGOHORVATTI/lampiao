extends Node


func _ready() -> void:
	var scene: Node = load(OS.get_environment("SCENE")).instantiate()
	add_child(scene)
	var yaw := float(OS.get_environment("YAW")) if OS.has_environment("YAW") else 0.0
	await get_tree().create_timer(1.5).timeout
	if Global.player:
		Global.player.camera_pivot.rotation.y = deg_to_rad(yaw)
	await get_tree().create_timer(2.5).timeout
	var frames := Engine.get_frames_drawn()
	await get_tree().create_timer(2.0).timeout
	print("fps: %.1f" % ((Engine.get_frames_drawn() - frames) / 2.0))
	get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT"))
	get_tree().quit()
