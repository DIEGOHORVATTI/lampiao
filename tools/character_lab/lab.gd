extends Node3D

const POSES := [["Idle", 0.6], ["Walk", 0.35], ["Pistol_Aim_Neutral", 0.1]]
const MANNEQUIN := "res://resources/personagens/ual/UAL1_Standard.glb"


var stage: SubViewport


func _ready() -> void:
	var args := _args()
	stage = SubViewport.new()
	stage.size = Vector2i(int(args.get("w", "1600")), int(args.get("h", "640")))
	stage.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	stage.own_world_3d = true
	add_child(stage)
	var scenes: PackedStringArray = args.get("scenes", "res://resources/personagens/lampiao/lampiao.tscn").split(",")
	var output: String = args.get("out", "/tmp/claude-1000/lab_shot.png")
	var close: bool = args.get("close", "0") == "1"
	var yaw := float(args.get("yaw", "20"))
	_environment()
	var rows: Array = []
	if args.get("mannequin", "1") == "1":
		rows.append(MANNEQUIN)
	rows.append_array(scenes)
	var spacing := 1.1
	var x := 0.0
	var count := 0
	for scene_path in rows:
		for pose in POSES:
			var character: Node3D = load(scene_path).instantiate()
			stage.add_child(character)
			character.position = Vector3(x, 0, 0)
			character.rotation_degrees.y = yaw
			var anim: AnimationPlayer = character.find_children("*", "AnimationPlayer", true, false)[0]
			anim.play(pose[0])
			anim.seek(anim.current_animation_length * pose[1], true)
			anim.pause()
			x += spacing
			count += 1
			if close:
				break
		x += 0.3
	var cam := Camera3D.new()
	stage.add_child(cam)
	var width := x - spacing - 0.3
	if close:
		cam.fov = 22.0
		cam.position = Vector3(width / 2.0, 1.55, 3.2 + width * 0.9)
		cam.look_at(Vector3(width / 2.0, 1.45, 0))
	else:
		cam.fov = 30.0
		cam.position = Vector3(width / 2.0, 1.1, 2.6 + width * 0.95)
		cam.look_at(Vector3(width / 2.0, 0.9, 0))
	for i in 8:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	stage.get_texture().get_image().save_png(output)
	print("SHOT ", output, " draw_calls=", RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME), " primitives=", RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_PRIMITIVES_IN_FRAME), " characters=", count)
	get_tree().quit()


func _args() -> Dictionary:
	var out := {}
	for arg in OS.get_cmdline_user_args():
		var parts := arg.split("=", true, 1)
		if parts.size() == 2:
			out[parts[0]] = parts[1]
	return out


func _environment() -> void:
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.86, 0.78, 0.62)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.55, 0.45, 0.38)
	env.environment.ambient_light_energy = 0.55
	stage.add_child(env)
	var sun := DirectionalLight3D.new()
	sun.light_color = Color(1.0, 0.92, 0.78)
	sun.light_energy = 1.4
	sun.rotation_degrees = Vector3(-40, 35, 0)
	sun.shadow_enabled = true
	stage.add_child(sun)
	var ground := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(40, 40)
	ground.mesh = plane
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.72, 0.6, 0.42)
	ground.material_override = mat
	stage.add_child(ground)
