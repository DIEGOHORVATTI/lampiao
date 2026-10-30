extends "res://tools/build_sertao.gd"

const GATILHO := preload("res://world/gatilho.gd")
const CAVE := preload("res://world/cap01/caverna.gd")
const CARTUCHEIRA := preload("res://common/utils/ammo_refil.tscn")
const GEO_DIR := "res://world/cap01/geo/"
const FAZENDA := Vector3(0, 0, -216)


func _setup() -> void:
	out_path = "res://world/cap01/cap01.tscn"
	player_start = Vector3(-10, 0.4, -230)
	root_script = load("res://world/cap01/cap01.gd")
	rng.seed = 1938


func _layout() -> void:
	_fazenda()
	_caverna_geo()
	_z2_boca()
	_z3_galeria()
	_z4_idolos()
	_z5_fenda()
	_z6_lajedo()
	_lua()


func _night() -> Environment:
	var e := super._night()
	e.ambient_light_energy = 0.35
	e.fog_density = 0.03
	return e


func _lua() -> void:
	var moon := DirectionalLight3D.new()
	moon.name = "LuaCheia"
	moon.light_color = Color(0.62, 0.68, 0.9)
	moon.light_energy = 0.55
	moon.rotation_degrees = Vector3(-40, -70, 0)
	_own(moon, scene_root)
	var shaft := SpotLight3D.new()
	shaft.name = "Claraboia"
	shaft.light_color = Color(0.7, 0.75, 0.95)
	shaft.light_energy = 6.0
	shaft.spot_range = 18.0
	shaft.spot_angle = 16.0
	shaft.position = Vector3(0, 8.5, 74)
	shaft.rotation_degrees = Vector3(-90, 0, 0)
	_own(shaft, scene_root)


func _fazenda() -> void:
	_put("terreno_fazenda", FAZENDA, 0)
	_put("casa_grande", Vector3(0, 0, -226), 0)
	_put("capela", Vector3(25, 0, -228), 0)
	for seg in [[-34.0, 1.0], [-24.0, 0.66], [-10.0, 1.0], [2.0, 1.0], [14.0, 1.0], [26.0, 1.0], [37.0, 0.5]]:
		_put("cerca_arame", Vector3(seg[0], 0, -188), 0).scale.x = seg[1]
	for x in [-22.0, -18.0, -14.0]:
		_put("cavalo", Vector3(x, 0, -184), PI + rng.randf_range(-0.3, 0.3))
	for p in [Vector3(-14, 2.4, -228), Vector3(0, 2.4, -224), Vector3(-14, 2.4, -220)]:
		_put("candeeiro", p, 0)
	_put("caixote", Vector3(-14, 0.1, -234), 0)
	_put("monte_moedas", Vector3(-12.5, 0.1, -233.5), 0)
	_put("pedra", Vector3(6, 0, -206), 0)
	_put("caixote", Vector3(-24, 0, -204), 0.4)
	_put("arvore_seca", Vector3(-30, 0, -212), 0).scale = Vector3.ONE * 1.4
	for i in 40:
		var a := rng.randf() * TAU
		var r := rng.randf_range(36.0, 46.0)
		var kind: String = ["arvore_seca", "mandacaru", "xique_xique", "pedra"][rng.randi() % 4]
		_put(kind, FAZENDA + Vector3(cos(a) * r, 0, sin(a) * r), rng.randf() * TAU)
	_marker("Saco", -13, -233.5, 0.1)
	_marker("Maria_F", -4, -229, 0.1)
	_marker("Barauna_F", -12, -232, 0.1)
	_marker("Xexeu_F", -10, -234.5, 0.1)
	_marker("Benedito_Porta", 10, -238, 0.1)
	_marker("Benedito_Chao", 10, -230, 0.1)
	_marker("Vini_F", -16, -182, 0.1)
	_marker("Soldado_Capela", 20, -214, 0.1)
	var e0 := [Vector3(-20, 0, -248), Vector3(0, 0, -248), Vector3(18, 0, -248), Vector3(34, 0, -228), Vector3(34, 0, -212), Vector3(28, 0, -196), Vector3(36, 0, -200)]
	for i in e0.size():
		_marker("E0_%d" % (i + 1), e0[i].x, e0[i].z, 0.1)
	_trigger_at("G_Fundos", Vector3(0, 0, -214), Vector3(6, 4, 4))
	_trigger_at("G1_Maria", Vector3(-6, 0, -206), Vector3(8, 4, 8))
	_trigger_at("G_Cavalos", Vector3(-18, 0, -186), Vector3(8, 4, 6))
	_fazenda_bounds()


func _fazenda_bounds() -> void:
	var walls := StaticBody3D.new()
	walls.name = "LimitesFazenda"
	_own(walls, scene_root)
	var boxes := [
		[Vector3(84, 10, 1), FAZENDA + Vector3(0, 5, -38)],
		[Vector3(84, 10, 1), FAZENDA + Vector3(0, 5, 34)],
		[Vector3(1, 10, 76), FAZENDA + Vector3(-42, 5, -2)],
		[Vector3(1, 10, 76), FAZENDA + Vector3(42, 5, -2)],
	]
	for b in boxes:
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = b[0]
		shape.shape = box
		shape.position = b[1]
		_own(shape, walls)


func _caverna_geo() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(GEO_DIR))
	var surfaces := [["caverna_chao", "chao", false, "stone"], ["caverna_teto", "teto", true, "stone"], ["caverna_topo", "topo", false, "earth"]]
	for s in surfaces:
		var generated: Node3D = PROPS.superficie(CAVE, s[1], s[2], s[3])
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


func _z2_boca() -> void:
	_at("arco_pedra", 0, -8, 0)
	_at("fogueira", 0, 0)
	_at("caldeirao", 0.7, 0.4)
	_at("esteira", -4, 6, 0.2)
	_at("esteira", -8, 8, -0.3)
	_at("monte_moedas", 10, 4)
	_at("totem_idolo", -10, 14, PI)
	for p in [Vector2(-8, -16), Vector2(4, -16)]:
		_at("cavalo", p.x, p.y, rng.randf() * TAU)
	for m in [["Lampiao_Manta", -4, 6], ["Maria", -8, 8], ["Barauna", 6, 8], ["Xexeu", 8, 2], ["Vini", 2, -4], ["Cuia", -3.2, 5.2], ["Idolo", -10, 12.5], ["Fogueira", 0, 0], ["E1a_1", 0, -9], ["E1a_2", 2.5, -10], ["Desmorona_1", 6, 18], ["Coronel_Boca", 0, -14]]:
		_marker(m[0], m[1], m[2])
	_trigger("G2_Desmorona", 6, 20, Vector3(4, 4, 4))
	_trigger("S1_Vulto", -10, 12, Vector3(4, 4, 4))


func _z3_galeria() -> void:
	for p in [Vector2(8.5, 24), Vector2(0.8, 30), Vector2(-6.5, 36), Vector2(2.8, 44), Vector2(-4.6, 50)]:
		_at("nicho_ossada", p.x, p.y, rng.randf() * TAU)
	for m in [["E1b_1", 4, 26], ["E1b_2", 5, 24], ["Desmorona_2", -1, 48], ["Vini_G1", 4, 26], ["Vini_G2", -4, 36], ["Vini_G3", -2, 46], ["Vini_G4", 2, 56], ["Vini_Salao", 0, 62]]:
		_marker(m[0], m[1], m[2])
	_trigger("S4_Vulto", -4, 36, Vector3(5, 4, 5))
	_trigger("S5_Sussurro", -2, 46, Vector3(5, 4, 5))
	_trigger("G_Salao", 0, 61, Vector3(6, 4, 3))


func _z4_idolos() -> void:
	for p in [Vector2(-10, 64), Vector2(10, 64), Vector2(-12, 76), Vector2(12, 76), Vector2(-10, 88), Vector2(10, 88)]:
		var t := _at("totem_idolo", p.x, p.y, atan2(-p.x, 76.0 - p.y))
		t.name = "Totem_%d" % int(p.x * 10 + p.y)
		t.add_to_group("totens", true)
	_at("laje_sepultura", 0, 80)
	for p in [Vector2(-13, 70), Vector2(13, 70), Vector2(-13, 84), Vector2(13, 84)]:
		_at("nicho_ossada", p.x, p.y, rng.randf() * TAU)
	var carnes := [Vector2(-6, 62), Vector2(6, 62), Vector2(-8, 72), Vector2(8, 72)]
	for i in carnes.size():
		_marker("Carnica_%d" % (i + 1), carnes[i].x, carnes[i].y)
		_marker("E2_%d" % (i + 1), carnes[i].x, carnes[i].y)
	for m in [["Lampiao_Duelo", 0, 66], ["Vini_Duelo", 0, 72], ["Cabeca", -2, 66], ["Coronel_Salao", 1.5, 67], ["Revolver", -6, 70], ["Rifle_Vini", 4, 78], ["Vini_Corpo", 2, 78], ["E3_1", 12, 78], ["E3_2", 10, 72], ["Benedito_Fuga", 14, 80], ["Laje", 0, 80]]:
		_marker(m[0], m[1], m[2])
	_trigger("S7_Respiracao", 0, 80, Vector3(8, 4, 8))


func _z5_fenda() -> void:
	_at("facho", 16, 78)
	_at("nicho_ossada", 27, 54, -PI / 2)
	_at("corpo", 27.3, 54, 0.4)
	for i in 4:
		var p: Vector2 = [Vector2(24, 66), Vector2(27, 56), Vector2(29, 40), Vector2(30, 34)][i]
		_marker("E4_%d" % (i + 1), p.x, p.y)
		_at("pedra", p.x + 0.8, p.y + 1.4)
		_at("facho", p.x - 0.6, p.y + 0.8).name = "Tocha_%d" % (i + 1)
	_at("pedra", 31.5, 23.5).scale = Vector3.ONE * 1.3
	for m in [["Facho_Pickup", 16, 78], ["Nicho_Soldado", 27, 54], ["Benedito", 31, 24]]:
		_marker(m[0], m[1], m[2])
	_trigger("G4_Terco", 26, 60, Vector3(5, 4, 5))
	_trigger("S8_Passos", 18, 74, Vector3(4, 4, 4))
	_trigger("S9_Jumpscare", 27, 55, Vector3(3, 4, 3))
	_trigger("S10_Batida", 31, 28, Vector3(4, 4, 4))
	_trigger("G_Benedito", 31, 24, Vector3(5, 4, 5))
	_trigger("G_SaidaFenda", 34, -6, Vector3(5, 4, 5))


func _z6_lajedo() -> void:
	_at("pedra", 14, -14)
	_at("pedra", -22, -12)
	_at("mandacaru", -24, -20)
	_at("mandacaru", 20, -28)
	_at("arvore_seca", -18, -34).scale = Vector3.ONE * 1.5
	for i in 30:
		var x := rng.randf_range(-27, 37)
		var z := rng.randf_range(-35, -30)
		_at(["xique_xique", "pedra", "mandacaru"][rng.randi() % 3], x, z, rng.randf() * TAU)
	for m in [["Cova_1", -14, -24], ["Cova_2", -10, -24], ["Cova_3", -6, -24], ["Cova_Vini", -20, -30], ["Fim", -10, -30], ["Arvore", -18, -34], ["Maria_Pedra", -6, 10]]:
		_marker(m[0], m[1], m[2])
	var ammo: Node3D = CARTUCHEIRA.instantiate()
	ammo.name = "Cartucheira"
	ammo.position = Vector3(12, CAVE.chao(12, -30), -30)
	_own(ammo, scene_root)
	_trigger("G_Covas", -10, -22, Vector3(14, 4, 6))
	_trigger("S11_Vulto", -18, -30, Vector3(8, 4, 8))


func _enemies() -> void:
	pass


func _bounds() -> void:
	pass


func _put(kind: String, pos: Vector3, yaw := 0.0) -> Node3D:
	return _prop(kind, pos, yaw, rng.randi() % 100000)


func _at(kind: String, x: float, z: float, yaw := 0.0) -> Node3D:
	return _prop(kind, Vector3(x, CAVE.chao(x, z), z), yaw, rng.randi() % 100000)


func _marker(marker_name: String, x: float, z: float, y := NAN) -> void:
	var marker := Marker3D.new()
	marker.name = marker_name
	marker.position = Vector3(x, CAVE.chao(x, z) if is_nan(y) else y, z)
	_own(marker, scene_root)


func _trigger(trigger_name: String, x: float, z: float, size: Vector3) -> void:
	_trigger_at(trigger_name, Vector3(x, CAVE.chao(x, z), z), size)


func _trigger_at(trigger_name: String, pos: Vector3, size: Vector3) -> void:
	var area := Area3D.new()
	area.name = trigger_name
	area.set_script(GATILHO)
	area.tamanho = size
	area.position = pos - Vector3(0, 1.0, 0)
	_own(area, scene_root)
