extends Node


func _ready() -> void:
	var scene: Node = load(OS.get_environment("SCENE")).instantiate()
	add_child(scene)
	var yaw := float(OS.get_environment("YAW")) if OS.has_environment("YAW") else 0.0
	await get_tree().create_timer(1.5).timeout
	Dialogo.limpar()
	if Global.player:
		if OS.has_environment("POS"):
			var xz := OS.get_environment("POS").split(",")
			var from := Vector3(float(xz[0]), 40.0, float(xz[1]))
			var hit := get_viewport().get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, from + Vector3.DOWN * 80.0))
			Global.player.global_position = (hit.position if hit else from) + Vector3.UP * 1.0
		Global.player.camera_pivot.rotation.y = deg_to_rad(yaw)
	await get_tree().create_timer(2.5).timeout
	Dialogo.limpar()
	var frames := Engine.get_frames_drawn()
	await get_tree().create_timer(2.0).timeout
	print("fps: %.1f draw_calls: %d objetos: %d prims: %d" % [(Engine.get_frames_drawn() - frames) / 2.0, Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME), Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)])
	get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT"))
	get_tree().quit()
