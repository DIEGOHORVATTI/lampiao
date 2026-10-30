extends Node3D


func _ready() -> void:
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.05, 0.05, 0.07)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.35, 0.38, 0.5)
	env.environment.ambient_light_energy = 0.6
	add_child(env)
	var fire := OmniLight3D.new()
	fire.light_color = Color(1.0, 0.6, 0.25)
	fire.light_energy = 3.0
	fire.omni_range = 10.0
	fire.position = Vector3(0, 0.6, 1.5)
	add_child(fire)
	var floor := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(20, 20)
	floor.mesh = plane
	add_child(floor)
	var poses := [["Idle", -1.6], ["Sitting_Idle", 0.0], ["Pistol_Aim_Neutral", 1.6]]
	for p in poses:
		var s: CharacterBody3D = load("res://enemies/soldado.tscn").instantiate()
		add_child(s)
		s.set_physics_process(false)
		s.position = Vector3(p[1], 0, 0)
		s.anim.play(p[0])
	var cam := Camera3D.new()
	cam.position = Vector3(0, 1.3, 4.2)
	cam.rotation_degrees = Vector3(-8, 0, 0)
	add_child(cam)
	await get_tree().create_timer(1.0).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/soldados.png")
	get_tree().quit()
