extends Node3D

const SHOTS := [
	["boca", Vector3(0, 1.7, -20), Vector3(0, 0, 0)],
	["boca_dentro", Vector3(-6, 1.7, -2), Vector3(-5, 160, 0)],
	["galeria", Vector3(4.5, 0.7, 24), Vector3(-10, 200, 0)],
	["idolos", Vector3(0, -4.3, 64), Vector3(5, 180, 0)],
	["fenda", Vector3(27, -2.8, 52), Vector3(0, 10, 0)],
]


func _ready() -> void:
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.1, 0.12, 0.2)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.6, 0.6, 0.7)
	env.environment.ambient_light_energy = 0.5
	add_child(env)
	var props := preload("res://game/world/props/prop_library.gd")
	var t0 := Time.get_ticks_msec()
	for kind in ["cave_floor", "cave_ceiling", "cave_top"]:
		add_child(props.build(kind, RandomNumberGenerator.new()))
	print("caverna gerada em ms: ", Time.get_ticks_msec() - t0)
	var cam := Camera3D.new()
	add_child(cam)
	var light := OmniLight3D.new()
	light.omni_range = 18.0
	light.light_energy = 2.0
	cam.add_child(light)
	for shot in SHOTS:
		cam.position = shot[1]
		cam.rotation_degrees = shot[2]
		await get_tree().create_timer(0.3).timeout
		get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/cav-%s.png" % shot[0])
	get_tree().quit()
