extends "res://tools/build_sandbox.gd"

const TRIGGER := preload("res://game/world/components/trigger.gd")
const CAVE := preload("res://game/world/chapters/chapter_01/cave_field.gd")
const CAVE_PIECES := preload("res://game/world/props/cave_pieces.gd")
const ROOT_REGIONS := [["roots_mouth", -10.0, 14.0, 240], ["roots_tunnel", 14.0, 60.0, 300], ["roots_hall", 60.0, 93.0, 300]]
const GEO_DIR := "res://game/world/chapters/chapter_01/geo/"
const FARM := Vector3(0, 0, -216)


func _setup() -> void:
	out_path = "res://game/world/chapters/chapter_01/chapter_01.tscn"
	player_start = Vector3(-10, 0.4, -230)
	root_script = load("res://game/world/chapters/chapter_01/chapter_01.gd")
	rng.seed = 1938


func _layout() -> void:
	_farm()
	_cave_geometry()
	_z2_cave_mouth()
	_z3_gallery()
	_z4_idol_hall()
	_z6_rock_shelf()
	_moonlight()


func _night() -> Environment:
	var e := super._night()
	e.ambient_light_energy = 0.35
	e.fog_density = 0.03
	return e


func _moonlight() -> void:
	var moon := DirectionalLight3D.new()
	moon.name = "FullMoon"
	moon.light_color = Color(0.62, 0.68, 0.9)
	moon.light_energy = 0.55
	moon.rotation_degrees = Vector3(-40, -70, 0)
	_own(moon, scene_root)
	var shaft := SpotLight3D.new()
	shaft.name = "Skylight"
	shaft.light_color = Color(0.7, 0.75, 0.95)
	shaft.light_energy = 6.0
	shaft.spot_range = 18.0
	shaft.spot_angle = 16.0
	shaft.spot_attenuation = 0.25
	shaft.position = Vector3(0, 8.5, 74)
	shaft.rotation_degrees = Vector3(-90, 0, 0)
	_own(shaft, scene_root)


func _farm() -> void:
	_put("farm_terrain", FARM, 0)
	_put("manor", Vector3(0, 0, -226), 0)
	_put("chapel", Vector3(25, 0, -228), PI)
	for seg in [[-34.0, 1.0], [-24.0, 0.66], [-10.0, 1.0], [2.0, 1.0], [14.0, 1.0], [26.0, 1.0], [37.0, 0.5]]:
		_put("barbed_fence", Vector3(seg[0], 0, -188), 0).scale.x = seg[1]
	for x in [-22.0, -18.0, -14.0]:
		_put("horse", Vector3(x, 0, -184), rng.randf_range(-0.2, 0.2))
	_put("rail_fence", Vector3(-18, 0, -181.6), 0)
	for p in [Vector3(-26.5, 0, -181), Vector3(-9.5, 0, -180), Vector3(-27, 0, -186)]:
		_put("mandacaru", p, rng.randf() * TAU)
	for p in [Vector3(-21, 0, -211), Vector3(-21, 0, -203), Vector3(-21, 0, -195), Vector3(4.5, 0, -207), Vector3(4.5, 0, -198)]:
		_put("porch_house", p, PI / 2 if p.x < 0 else -PI / 2)
	_put("dead_tree", Vector3(-30, 0, -186), 0).scale = Vector3.ONE * 1.4
	for i in 40:
		var a := rng.randf() * TAU
		var r := rng.randf_range(36.0, 46.0)
		var kind: String = ["dead_tree", "mandacaru", "xique_xique", "rock"][rng.randi() % 4]
		_put(kind, FARM + Vector3(cos(a) * r, 0, sin(a) * r), rng.randf() * TAU)
	for m in [["OpeningView", -4, -183], ["LampiaoRaid", -9, -230], ["RoomDoor", -2, -230], ["Triangles", -12, -232], ["Stars", -7, -228], ["MariaFarm", -5, -231], ["Guard", 7, -230], ["SoldierDoor", 10, -237], ["SoldierHandsUp", 1, -229], ["Drawings", -1, -224], ["BackDoor", 0, -215], ["StreetMiddle", -8, -200], ["ViniFarm", -16, -182]]:
		_marker(m[0], m[1], m[2], 0.1)
	var e0 := [Vector3(-20, 0, -248), Vector3(0, 0, -248), Vector3(18, 0, -248), Vector3(34, 0, -228), Vector3(34, 0, -212), Vector3(28, 0, -196), Vector3(36, 0, -200)]
	for i in e0.size():
		_marker("FarmSoldier_%d" % (i + 1), e0[i].x, e0[i].z, 0.1)
	_trigger_at("BackDoorTrigger", Vector3(0, 0, -214), Vector3(6, 4, 4))
	_trigger_at("MariaShotTrigger", Vector3(-6, 0, -206), Vector3(8, 4, 8))
	_trigger_at("StreetTrigger", Vector3(-10, 0, -196), Vector3(10, 4, 4))
	_trigger_at("HorsesTrigger", Vector3(-18, 0, -186), Vector3(8, 4, 6))
	_farm_bounds()


func _farm_bounds() -> void:
	var walls := StaticBody3D.new()
	walls.name = "FarmBounds"
	_own(walls, scene_root)
	var boxes := [
		[Vector3(84, 10, 1), FARM + Vector3(0, 5, -38)],
		[Vector3(84, 10, 1), FARM + Vector3(0, 5, 34)],
		[Vector3(1, 10, 76), FARM + Vector3(-42, 5, -2)],
		[Vector3(1, 10, 76), FARM + Vector3(42, 5, -2)],
	]
	for b in boxes:
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = b[0]
		shape.shape = box
		shape.position = b[1]
		_own(shape, walls)


func _cave_geometry() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(GEO_DIR))
	var surfaces := [["cave_floor", "floor_height", false, "cave"], ["cave_ceiling", "ceiling_height", true, "cave"], ["cave_top", "top_height", false, "sand"]]
	for s in surfaces:
		var generated: Node3D = PROPS.surface(CAVE, s[1], s[2], s[3])
		var mi: MeshInstance3D = generated.find_children("*", "MeshInstance3D", true, false)[0]
		var col: CollisionShape3D = generated.find_children("*", "CollisionShape3D", true, false)[0]
		ResourceSaver.save(mi.mesh, GEO_DIR + s[0] + ".mesh")
		ResourceSaver.save(col.shape, GEO_DIR + s[0] + "_col.res")
		generated.free()
		var body := StaticBody3D.new()
		body.name = s[0]
		_own(body, props)
		var visual := MeshInstance3D.new()
		visual.mesh = load(GEO_DIR + s[0] + ".mesh")
		visual.material_override = PROPS.material(s[3])
		_own(visual, body)
		var shape := CollisionShape3D.new()
		shape.shape = load(GEO_DIR + s[0] + "_col.res")
		_own(shape, body)
	for region in ROOT_REGIONS:
		ResourceSaver.save(CAVE_PIECES.roots_mesh(region[1], region[2], region[3]), GEO_DIR + region[0] + ".mesh")
		var roots := MeshInstance3D.new()
		roots.name = region[0]
		roots.mesh = load(GEO_DIR + region[0] + ".mesh")
		roots.material_override = PROPS.material("root")
		_own(roots, props)


func _z2_cave_mouth() -> void:
	_at("cave_mouth", 0, -8, 0)
	_at("drum_column", -4.3, -10.4, rng.randf() * TAU)
	_at("drum_column", 5.4, -10.3, rng.randf() * TAU)
	_at("broken_drum_column", -7.4, -11.9, rng.randf() * TAU)
	_at("block_pillar", -11.6, -12.6, 0.2)
	for p in [Vector2(11.2, -12.4), Vector2(13.8, -11.0), Vector2(-11.8, -14.0)]:
		_at("mandacaru", p.x, p.y, rng.randf() * TAU)
	_at("campfire", 0, 0)
	_at("stone_stove", 2.4, -1.8)
	for p in [Vector2(-4, 6), Vector2(-8, 8), Vector2(6, 8), Vector2(8, 2)]:
		_at("sleeping_mat", p.x, p.y, rng.randf_range(-0.3, 0.3))
	for p in [Vector2(-6, 4.5), Vector2(7.5, 6.5)]:
		_at("rolled_blanket", p.x, p.y)
	for p in [Vector2(-1.6, 1.8), Vector2(1.9, 1.6), Vector2(3.6, -0.6)]:
		_at("gourd_bowls", p.x, p.y)
	_at("hanging_bags", -11.0, 3.0, PI / 2)
	_at("coin_pile", 10, 4)
	for p in [Vector2(-8, -16), Vector2(4, -16)]:
		_at("horse", p.x, p.y, rng.randf() * TAU)
	for m in [["LampiaoMat", -4, 6], ["Maria", -8, 8], ["Triangles", 6, 8], ["Stars", 8, 2], ["Vini", 2, -4], ["CoinPile", 10, 4], ["SoupBowl", -3.2, 5.2], ["Campfire", 0, 0], ["ColonelAtMouth", 0, -16], ["MouthSoldier_1", -3, -14], ["MouthSoldier_2", 3, -14], ["MouthSoldier_3", 5, -17]]:
		_marker(m[0], m[1], m[2])
	_trigger("CampReturnTrigger", 3, 11, Vector3(6, 4, 4))


func _z3_gallery() -> void:
	for m in [["Tunnel_1", 6, 14], ["Tunnel_2", 4, 26], ["Tunnel_3", -4, 36], ["Tunnel_4", -2, 46], ["Tunnel_5", 2, 56], ["ViniHall", 0, 62]]:
		_marker(m[0], m[1], m[2])
	_trigger("DistrustTrigger", 2, 55, Vector3(5, 4, 4))
	_trigger("HallTrigger", 0, 63, Vector3(8, 4, 3))


func _z4_idol_hall() -> void:
	for p in [Vector2(-10, 64), Vector2(10, 64), Vector2(-12, 76), Vector2(12, 76), Vector2(-10, 88), Vector2(10, 88)]:
		_at("idol_column_tilted" if p == Vector2(-12, 76) else "idol_column", p.x, p.y, atan2(-p.x, 76.0 - p.y))
	_at("fallen_column", -5, 84, 0)
	_at("moonbeam", CAVE.SKYLIGHT.x, CAVE.SKYLIGHT.z)
	_at("arched_block_wall", -4, 90.2, PI)
	var soldiers := [Vector2(-6, 66), Vector2(6, 66), Vector2(-8, 74), Vector2(8, 74)]
	for i in soldiers.size():
		_marker("HallSoldier_%d" % (i + 1), soldiers[i].x, soldiers[i].y)
	for m in [["HallView", 0, 70], ["LampiaoDuel", 0, 72], ["ViniDuel", 0, 77], ["HeadDrop", -1.5, 73], ["ColonelBehind", 0.6, 69], ["ColonelExit", 0, 61], ["LampiaoRifle", 1.2, 72.5]]:
		_marker(m[0], m[1], m[2])


func _z6_rock_shelf() -> void:
	_at("rock", 14, -14)
	_at("rock", -22, -12)
	_at("mandacaru", -24, -20)
	_at("mandacaru", 20, -28)
	_at("great_dead_tree", -18, -34).scale = Vector3.ONE * 1.5
	for p in [Vector2(-10, -31), Vector2(-23, -29), Vector2(-3, -33)]:
		_at("dry_stakes", p.x, p.y)
	for i in 30:
		var x := rng.randf_range(-27, 37)
		var z := rng.randf_range(-35, -30)
		_at(["xique_xique", "rock", "mandacaru"][rng.randi() % 3], x, z, rng.randf() * TAU)
	for m in [["Grave_1", -16, -24], ["Grave_2", -12, -24], ["Grave_3", -8, -24], ["Grave_4", -4, -24], ["OathPoint", -15, -31], ["DeadTree", -18, -34], ["Kepi", -6, -27]]:
		_marker(m[0], m[1], m[2])


func _enemies() -> void:
	pass


func _bounds() -> void:
	pass


func _put(kind: String, pos: Vector3, yaw := 0.0) -> Node3D:
	return _prop(kind, pos, yaw, rng.randi() % 100000)


func _at(kind: String, x: float, z: float, yaw := 0.0) -> Node3D:
	return _prop(kind, Vector3(x, CAVE.floor_height(x, z), z), yaw, rng.randi() % 100000)


func _marker(marker_name: String, x: float, z: float, y := NAN) -> void:
	var marker := Marker3D.new()
	marker.name = marker_name
	marker.position = Vector3(x, CAVE.floor_height(x, z) if is_nan(y) else y, z)
	_own(marker, scene_root)


func _trigger(trigger_name: String, x: float, z: float, size: Vector3) -> void:
	_trigger_at(trigger_name, Vector3(x, CAVE.floor_height(x, z), z), size)


func _trigger_at(trigger_name: String, pos: Vector3, size: Vector3) -> void:
	var area := Area3D.new()
	area.name = trigger_name
	area.set_script(TRIGGER)
	area.size = size
	area.position = pos - Vector3(0, 1.0, 0)
	_own(area, scene_root)
