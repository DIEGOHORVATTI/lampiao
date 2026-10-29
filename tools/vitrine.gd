extends Node3D

const KINDS := ["fogueira", "fogueira_apagada", "barraca_lona", "barraca_rasgada", "carroca_tombada", "caixote", "muro_pedra", "cova", "corpo", "cruz_exvoto", "paredao", "mandacaru", "casa_taipa"]


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
	var props := preload("res://world/sertao/props.gd")
	for i in KINDS.size():
		var rng := RandomNumberGenerator.new()
		rng.seed = i
		var node: Node3D = props.build(KINDS[i], rng)
		node.position = Vector3((i % 5) * 6.0 - 12.0, 0, int(i / 5) * -9.0)
		add_child(node)
	var cam := Camera3D.new()
	cam.position = Vector3(0, 6, 7)
	cam.rotation_degrees = Vector3(-32, 0, 0)
	add_child(cam)
	await get_tree().create_timer(1.0).timeout
	get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT"))
	get_tree().quit()
