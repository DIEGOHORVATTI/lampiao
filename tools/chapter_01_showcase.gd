extends Node

const SCENE := "res://game/world/chapters/chapter_01/chapter_01.tscn"
const SHOTS := [
	["farm", Vector3(-4, 2.2, -181), Vector3(-4, 4, 0), false],
	["fence", Vector3(-1, 1.4, -184.5), Vector3(-4, 70, 0), false],
	["street", Vector3(-4, 1.7, -189), Vector3(-2, 10, 0), false],
	["horses", Vector3(-11, 1.8, -177), Vector3(-6, 50, 0), false],
	["chapel", Vector3(18, 1.8, -206), Vector3(4, -20, 0), false],
	["room", Vector3(-12, 1.6, -233), Vector3(-4, -60, 0), true],
	["corridor", Vector3(0, 1.6, -235), Vector3(-2, 180, 0), true],
	["mouth", Vector3(1, 1.8, -21), Vector3(8, 180, 0), false],
	["camp", Vector3(5, 1.6, -5), Vector3(-16, 142, 0), false],
	["camp_wall", Vector3(3, 1.8, 6), Vector3(-6, 70, 0), false],
	["tunnel", Vector3(4.4, 0.7, 25), Vector3(-4, 142, 0), true],
	["hall", Vector3(0, -4.2, 63), Vector3(6, 180, 0), true],
	["hall_back", Vector3(2, -4.2, 86), Vector3(4, 10, 0), true],
	["hall_comic", Vector3(3, -4.2, 78), Vector3(6, 132, 0), true],
	["skylight", Vector3(7, -3.4, 67), Vector3(-12, 135, 0), false],
	["burial", Vector3(-8, 1.8, -19), Vector3(-6, 30, 0), false],
]


func _ready() -> void:
	var level: Node = load(SCENE).instantiate()
	level.set_script(null)
	for unwanted in ["Player", "HUD", "MuzzleFlashRig", "InputManager"]:
		var node := level.find_child(unwanted, true, false)
		if node:
			node.free()
	add_child(level)
	var cam := Camera3D.new()
	cam.fov = 70.0
	add_child(cam)
	var lantern := OmniLight3D.new()
	lantern.light_color = Color(1.0, 0.8, 0.55)
	lantern.omni_range = 14.0
	cam.add_child(lantern)
	var only := OS.get_environment("ONLY")
	var prefix := OS.get_environment("PREFIX") if OS.has_environment("PREFIX") else "shot"
	for shot in SHOTS:
		if only != "" and not only.split(",").has(shot[0]):
			continue
		cam.position = shot[1]
		cam.rotation_degrees = shot[2]
		lantern.light_energy = 1.2 if shot[3] else 0.0
		await get_tree().create_timer(0.4).timeout
		get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/env/shots/%s-%s.png" % [prefix, shot[0]])
	get_tree().quit()
