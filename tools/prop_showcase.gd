extends Node3D

const KINDS := ["idol_column", "idol_column_tilted", "horse", "barbed_fence", "rail_fence", "drum_column", "broken_drum_column", "block_pillar", "stone_stove", "coin_pile", "sleeping_mat", "gourd_bowls", "hanging_bags", "great_dead_tree", "dry_stakes"]


func _ready() -> void:
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.25, 0.25, 0.3)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color.WHITE
	env.environment.ambient_light_energy = 0.6
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, 30, 0)
	add_child(sun)
	var props := preload("res://game/world/props/prop_library.gd")
	for i in KINDS.size():
		var rng := RandomNumberGenerator.new()
		rng.seed = i
		var node: Node3D = props.build(KINDS[i], rng)
		node.position = Vector3((i % 5) * 9.0 - 18.0, 0, int(i / 5) * -14.0)
		add_child(node)
	var cam := Camera3D.new()
	cam.position = Vector3(0, 14, 16)
	cam.rotation_degrees = Vector3(-32, 0, 0)
	if OS.has_environment("CAM"):
		var c := OS.get_environment("CAM").split_floats(",")
		cam.position = Vector3(c[0], c[1], c[2])
		cam.rotation_degrees = Vector3(c[3], c[4], 0)
	add_child(cam)
	await get_tree().create_timer(1.5).timeout
	get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT"))
	get_tree().quit()
