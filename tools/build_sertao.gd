extends Node

const PROP := preload("res://world/sertao/prop.gd")
const PROPS := preload("res://world/sertao/props.gd")
var out_path := "res://world/sertao/sertao.tscn"
var map_size := 80.0
var map_center := Vector3.ZERO
var player_start := Vector3(0, 1, 22)
var root_script: Script = null

var scene_root: Node3D
var props: Node3D
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.seed = 1938
	_setup()
	scene_root = Node3D.new()
	scene_root.name = out_path.get_file().get_basename().capitalize().replace(" ", "")
	if root_script:
		scene_root.set_script(root_script)

	var input_manager := Node.new()
	input_manager.name = "InputManager"
	input_manager.set_script(load("res://common/managers/input_manager.gd"))
	_own(input_manager, scene_root)

	var env := WorldEnvironment.new()
	env.name = "WorldEnvironment"
	env.environment = _night()
	_own(env, scene_root)

	var moon := DirectionalLight3D.new()
	moon.name = "Lua"
	moon.light_color = Color(0.55, 0.62, 0.85)
	moon.light_energy = 0.18
	moon.rotation_degrees = Vector3(-35, 30, 0)
	_own(moon, scene_root)

	var player: Node3D = load("res://player/player.tscn").instantiate()
	player.name = "Player"
	player.position = player_start
	_own(player, scene_root)
	var rig := Node.new()
	rig.name = "ClaraoRig"
	rig.set_script(load("res://world/sertao/clarao_rig.gd"))
	rig.auto_start = root_script == null
	_own(rig, scene_root)

	var hud := CanvasLayer.new()
	hud.name = "HUD"
	_own(hud, scene_root)
	_own(load("res://common/hud/gameplay_hud.tscn").instantiate(), hud)

	var nav := NavigationRegion3D.new()
	nav.name = "NavigationRegion"
	nav.set_script(load("res://world/sertao/nav_bake.gd"))
	var navmesh := NavigationMesh.new()
	navmesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	navmesh.agent_radius = 0.5
	navmesh.agent_max_slope = 40.0
	nav.navigation_mesh = navmesh
	_own(nav, scene_root)
	props = Node3D.new()
	props.name = "Cenario"
	_own(props, nav)

	_layout()
	_enemies()
	_bounds()

	var packed := PackedScene.new()
	var err := packed.pack(scene_root)
	if err == OK:
		err = ResourceSaver.save(packed, out_path)
	scene_root.free()
	print("build: ", "salvo em " + out_path if err == OK else "erro %d" % err)
	get_tree().quit(err)


func _setup() -> void:
	pass


func _layout() -> void:
	_prop("terreno", Vector3.ZERO, 0, 7)
	var houses := [Vector3(-9, 0, -4), Vector3(0, 0, -11), Vector3(10, 0, -5), Vector3(-6, 0, 9)]
	for i in houses.size():
		var facing: float = atan2(-houses[i].x, -houses[i].z)
		_prop("casa_taipa", houses[i], facing, i + 3)
		var door: Vector3 = houses[i] + Vector3(sin(facing), 0, cos(facing)) * 3.4
		_prop("lampiao", door + Vector3(0, 1.6, 0), 0, i)
	_prop("poco", Vector3(1, 0, 1), 0, 1)
	for i in 6:
		_prop("cerca_varas", Vector3(18 + (i % 2) * 0.2, 0, -14 + i * 7.6), PI / 2, 40 + i)
	for i in 4:
		_prop("cerca_varas", Vector3(-14 - i * 7.6, 0, -18), 0, 50 + i)
	for i in 14:
		_prop("cruz", Vector3(-24 + (i % 5) * 2.2 + rng.randf_range(-0.4, 0.4), 0, -26 - int(i / 5) * 2.6), rng.randf_range(-0.2, 0.2), 60 + i)
	_scatter("mandacaru", 26, 12.0, 34.0, 100)
	_scatter("arvore_seca", 14, 14.0, 36.0, 200)
	_scatter("pedra", 22, 8.0, 37.0, 300)


func _scatter(kind: String, count: int, min_r: float, max_r: float, seed_base: int) -> void:
	for i in count:
		var a := rng.randf() * TAU
		var r := rng.randf_range(min_r, max_r)
		var pos := Vector3(cos(a) * r, 0, sin(a) * r)
		if pos.distance_to(Vector3(0, 0, 22)) < 4.0:
			continue
		_prop(kind, pos, rng.randf() * TAU, seed_base + i)


func _prop(kind: String, pos: Vector3, yaw: float, seed: int) -> Node3D:
	var node := Node3D.new()
	node.set_script(PROP)
	node.name = "%s_%d" % [kind, seed]
	node.kind = kind
	node.seed = seed
	node.position = pos
	node.rotation.y = yaw
	_own(node, props)
	return node


func _enemies() -> void:
	var enemies := Node3D.new()
	enemies.name = "Enemies"
	_own(enemies, scene_root)
	var spawner_scene: PackedScene = load("res://common/spawner/spawner.tscn")
	var undead: PackedScene = load("res://enemies/soldado.tscn")
	for pos in [Vector3(-22, 0, -27), Vector3(26, 0, 10), Vector3(-26, 0, 14), Vector3(8, 0, -30)]:
		var spawner: Node3D = spawner_scene.instantiate()
		spawner.position = pos
		spawner.item = undead
		spawner.wait_time = 6.0
		spawner.spawn_time = 12.0
		spawner.max_items = 1
		_own(spawner, enemies)
	for pos in [Vector3(-9, 0, 1), Vector3(12, 0, -1), Vector3(-20, 0, -22), Vector3(22, 0, 18), Vector3(2, 0, -26)]:
		_prop("fogueira", pos, 0, int(pos.x * 10 + pos.z))
	var ammo: Node3D = load("res://common/utils/ammo_refil.tscn").instantiate()
	ammo.name = "Municao"
	ammo.position = Vector3(-5, 0, 6)
	_own(ammo, scene_root)


func _bounds() -> void:
	var walls := StaticBody3D.new()
	walls.name = "Limites"
	_own(walls, scene_root)
	var half := map_size / 2.0 - 2.0
	for dir in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = Vector3(map_size, 10, 1) if dir.x == 0 else Vector3(1, 10, map_size)
		shape.shape = box
		shape.position = map_center + dir * half + Vector3.UP * 5
		_own(shape, walls)


func _night() -> Environment:
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.02, 0.02, 0.035)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.25, 0.27, 0.4)
	e.ambient_light_energy = 0.55
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	e.fog_enabled = true
	e.fog_light_color = Color(0.05, 0.05, 0.07)
	e.fog_density = 0.045
	e.glow_enabled = true
	e.glow_intensity = 0.6
	return e


func _own(node: Node, parent: Node) -> void:
	parent.add_child(node)
	node.owner = scene_root
