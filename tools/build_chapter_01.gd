extends "res://tools/build_sandbox.gd"

const TRIGGER := preload("res://game/world/components/trigger.gd")
const CAVE := preload("res://game/world/chapters/chapter_01/cave_field.gd")
const AMMO_BELT := preload("res://common/utils/ammo_refil.tscn")
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
	_z5_crevice()
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
	shaft.position = Vector3(0, 8.5, 74)
	shaft.rotation_degrees = Vector3(-90, 0, 0)
	_own(shaft, scene_root)


func _farm() -> void:
	_put("farm_terrain", FARM, 0)
	_put("manor", Vector3(0, 0, -226), 0)
	_put("chapel", Vector3(25, 0, -228), 0)
	for seg in [[-34.0, 1.0], [-24.0, 0.66], [-10.0, 1.0], [2.0, 1.0], [14.0, 1.0], [26.0, 1.0], [37.0, 0.5]]:
		_put("barbed_fence", Vector3(seg[0], 0, -188), 0).scale.x = seg[1]
	for x in [-22.0, -18.0, -14.0]:
		_put("horse", Vector3(x, 0, -184), PI + rng.randf_range(-0.3, 0.3))
	for p in [Vector3(-14, 2.4, -228), Vector3(0, 2.4, -224), Vector3(-14, 2.4, -220)]:
		_put("wall_lamp", p, 0)
	_put("crate", Vector3(-14, 0.1, -234), 0)
	_put("coin_pile", Vector3(-12.5, 0.1, -233.5), 0)
	_put("rock", Vector3(6, 0, -206), 0)
	_put("crate", Vector3(-24, 0, -204), 0.4)
	_put("dead_tree", Vector3(-30, 0, -212), 0).scale = Vector3.ONE * 1.4
	for i in 40:
		var a := rng.randf() * TAU
		var r := rng.randf_range(36.0, 46.0)
		var kind: String = ["dead_tree", "mandacaru", "xique_xique", "rock"][rng.randi() % 4]
		_put(kind, FARM + Vector3(cos(a) * r, 0, sin(a) * r), rng.randf() * TAU)
	_marker("CoinBag", -13, -233.5, 0.1)
	_marker("MariaFarm", -4, -229, 0.1)
	_marker("BaraunaFarm", -12, -232, 0.1)
	_marker("XexeuFarm", -10, -234.5, 0.1)
	_marker("BeneditoDoor", 10, -238, 0.1)
	_marker("BeneditoFloor", 10, -230, 0.1)
	_marker("ViniFarm", -16, -182, 0.1)
	_marker("ChapelSoldier", 20, -214, 0.1)
	var e0 := [Vector3(-20, 0, -248), Vector3(0, 0, -248), Vector3(18, 0, -248), Vector3(34, 0, -228), Vector3(34, 0, -212), Vector3(28, 0, -196), Vector3(36, 0, -200)]
	for i in e0.size():
		_marker("FarmSoldier_%d" % (i + 1), e0[i].x, e0[i].z, 0.1)
	_trigger_at("BackDoorTrigger", Vector3(0, 0, -214), Vector3(6, 4, 4))
	_trigger_at("MariaShotTrigger", Vector3(-6, 0, -206), Vector3(8, 4, 8))
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
	var surfaces := [["cave_floor", "floor_height", false, "stone"], ["cave_ceiling", "ceiling_height", true, "stone"], ["cave_top", "top_height", false, "earth"]]
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


func _z2_cave_mouth() -> void:
	_at("stone_arch", 0, -8, 0)
	_at("campfire", 0, 0)
	_at("cauldron", 0.7, 0.4)
	_at("sleeping_mat", -4, 6, 0.2)
	_at("sleeping_mat", -8, 8, -0.3)
	_at("coin_pile", 10, 4)
	_at("idol_totem", -10, 14, PI)
	for p in [Vector2(-8, -16), Vector2(4, -16)]:
		_at("horse", p.x, p.y, rng.randf() * TAU)
	for m in [["LampiaoMat", -4, 6], ["Maria", -8, 8], ["Barauna", 6, 8], ["Xexeu", 8, 2], ["Vini", 2, -4], ["SoupBowl", -3.2, 5.2], ["Idol", -10, 12.5], ["Campfire", 0, 0], ["MouthSoldier_1", 0, -9], ["MouthSoldier_2", 2.5, -10], ["Rockfall_1", 6, 18], ["ColonelAtMouth", 0, -14]]:
		_marker(m[0], m[1], m[2])
	_trigger("RockfallTrigger", 6, 20, Vector3(4, 4, 4))
	_trigger("ScareIdolApparition", -10, 12, Vector3(4, 4, 4))


func _z3_gallery() -> void:
	for p in [Vector2(8.5, 24), Vector2(0.8, 30), Vector2(-6.5, 36), Vector2(2.8, 44), Vector2(-4.6, 50)]:
		_at("bone_niche", p.x, p.y, rng.randf() * TAU)
	for m in [["GallerySoldier_1", 4, 26], ["GallerySoldier_2", 5, 24], ["Rockfall_2", -1, 48], ["ViniPath_1", 4, 26], ["ViniPath_2", -4, 36], ["ViniPath_3", -2, 46], ["ViniPath_4", 2, 56], ["ViniHall", 0, 62]]:
		_marker(m[0], m[1], m[2])
	_trigger("ScareGalleryApparition", -4, 36, Vector3(5, 4, 5))
	_trigger("ScareWhisper", -2, 46, Vector3(5, 4, 5))
	_trigger("HallTrigger", 0, 61, Vector3(6, 4, 3))


func _z4_idol_hall() -> void:
	for p in [Vector2(-10, 64), Vector2(10, 64), Vector2(-12, 76), Vector2(12, 76), Vector2(-10, 88), Vector2(10, 88)]:
		var t := _at("idol_totem", p.x, p.y, atan2(-p.x, 76.0 - p.y))
		t.name = "Totem_%d" % int(p.x * 10 + p.y)
		t.add_to_group("totens", true)
	_at("tomb_slab", 0, 80)
	for p in [Vector2(-13, 70), Vector2(13, 70), Vector2(-13, 84), Vector2(13, 84)]:
		_at("bone_niche", p.x, p.y, rng.randf() * TAU)
	var carnes := [Vector2(-6, 62), Vector2(6, 62), Vector2(-8, 72), Vector2(8, 72)]
	for i in carnes.size():
		_marker("Remains_%d" % (i + 1), carnes[i].x, carnes[i].y)
		_marker("HallSoldier_%d" % (i + 1), carnes[i].x, carnes[i].y)
	for m in [["LampiaoDuel", 0, 66], ["ViniDuel", 0, 72], ["HeadDrop", -2, 66], ["ColonelHall", 1.5, 67], ["Revolver", -6, 70], ["ViniRifle", 4, 78], ["ViniBody", 2, 78], ["ReturnSoldier_1", 12, 78], ["ReturnSoldier_2", 10, 72], ["BeneditoEscape", 14, 80], ["Slab", 0, 80]]:
		_marker(m[0], m[1], m[2])
	_trigger("ScareSlabBreathing", 0, 80, Vector3(8, 4, 8))


func _z5_crevice() -> void:
	_at("torch", 16, 78)
	_at("bone_niche", 27, 54, -PI / 2)
	_at("corpse", 27.3, 54, 0.4)
	for i in 4:
		var p: Vector2 = [Vector2(24, 66), Vector2(27, 56), Vector2(29, 40), Vector2(30, 34)][i]
		_marker("CreviceSoldier_%d" % (i + 1), p.x, p.y)
		_at("rock", p.x + 0.8, p.y + 1.4)
		_at("torch", p.x - 0.6, p.y + 0.8).name = "CreviceTorch_%d" % (i + 1)
	_at("rock", 31.5, 23.5).scale = Vector3.ONE * 1.3
	for m in [["TorchPickup", 16, 78], ["EatenSoldierNiche", 27, 54], ["BeneditoNiche", 31, 24]]:
		_marker(m[0], m[1], m[2])
	_trigger("RosaryTrigger", 26, 60, Vector3(5, 4, 5))
	_trigger("ScareFootsteps", 18, 74, Vector3(4, 4, 4))
	_trigger("ScareEatenSoldier", 27, 55, Vector3(3, 4, 3))
	_trigger("ScareKnock", 31, 28, Vector3(4, 4, 4))
	_trigger("BeneditoTrigger", 31, 24, Vector3(5, 4, 5))
	_trigger("CreviceExitTrigger", 34, -6, Vector3(5, 4, 5))


func _z6_rock_shelf() -> void:
	_at("rock", 14, -14)
	_at("rock", -22, -12)
	_at("mandacaru", -24, -20)
	_at("mandacaru", 20, -28)
	_at("dead_tree", -18, -34).scale = Vector3.ONE * 1.5
	for i in 30:
		var x := rng.randf_range(-27, 37)
		var z := rng.randf_range(-35, -30)
		_at(["xique_xique", "rock", "mandacaru"][rng.randi() % 3], x, z, rng.randf() * TAU)
	for m in [["Grave_1", -14, -24], ["Grave_2", -10, -24], ["Grave_3", -6, -24], ["GraveVini", -20, -30], ["EndPoint", -10, -30], ["DeadTree", -18, -34], ["MariaRock", -6, 10]]:
		_marker(m[0], m[1], m[2])
	var ammo: Node3D = AMMO_BELT.instantiate()
	ammo.name = "AmmoBelt"
	ammo.position = Vector3(12, CAVE.floor_height(12, -30), -30)
	_own(ammo, scene_root)
	_trigger("GravesTrigger", -10, -22, Vector3(14, 4, 6))
	_trigger("ScareMariaApparition", -18, -30, Vector3(8, 4, 8))


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
