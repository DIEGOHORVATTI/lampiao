extends "res://tools/build_sertao.gd"

const GATILHO := preload("res://world/gatilho.gd")
const RELEVO := preload("res://world/cap01/relevo.gd")
const PICKUP := preload("res://world/sertao/kerosene_pickup.gd")


func _setup() -> void:
	out_path = "res://world/cap01/cap01.tscn"
	map_size = 0.0
	player_start = Vector3(-3, 1, 4)
	root_script = load("res://world/cap01/cap01.gd")
	rng.seed = 280738


func _layout() -> void:
	_prop("grota_barauna", Vector3.ZERO, 0, 1).position = Vector3.ZERO
	_z1_acampamento()
	_z2_cemiterio()
	_z3_trilha()
	_z4_grota()
	_z5_saida()
	_caatinga_fechada()


func _z1_acampamento() -> void:
	_at("fogueira", 0, 0)
	_marker("Lata", -3, 3)
	_at("barraca_lona", -9, -4, PI / 2)
	_marker("Barraca", -10, -3)
	_at("caixote", -10, -3)
	_pickup(-10, -4, 25.0)
	_at("barraca_lona", 7, -6, PI / 2)
	for p in [Vector2(-12, -7), Vector2(-11, -9), Vector2(9, -1)]:
		_at("caixote", p.x, p.y, rng.randf())
	_at("corpo", -13, 9, 0.7)
	_at("carroca_tombada", 11, 7, 0.5)
	_trigger("G_Carroca", 11, 7, Vector3(8, 4, 8))
	_at("arvore_seca", 5, -21).scale = Vector3.ONE * 1.6
	for p in [Vector2(-20, -12), Vector2(-18, 12), Vector2(15, -14), Vector2(18, 15), Vector2(-6, 17)]:
		_at("mandacaru", p.x, p.y, rng.randf() * TAU)
	_at("pedra", -22, 0)
	_at("pedra", 20, 2)
	_at("pedra", 0, -35).scale = Vector3.ONE * 3.0


func _z2_cemiterio() -> void:
	for x in [31.5, 38.5]:
		_at("muro_pedra", x, 0).scale.x = 0.9
		_at("muro_pedra", x, 12).scale.x = 0.9
	for z in [3.0, 9.0]:
		_at("muro_pedra", 42, z, PI / 2).scale.x = 0.8
	_at("muro_pedra", 28, 2.2, PI / 2).scale.x = 0.55
	_at("muro_pedra", 28, 9.8, PI / 2).scale.x = 0.55
	for x in [32, 36, 40]:
		for z in [4, 8]:
			_at("cruz", x, z, rng.randf_range(-0.2, 0.2))
	_at("cerca_varas", 47, -4).scale.x = 1.25
	for z in [0.0, 8.0, 13.0]:
		_at("cerca_varas", 52, z, PI / 2)
	for p in [Vector2(46, -1), Vector2(46, 13), Vector2(36, 16), Vector2(49, 6), Vector2(50, 18)]:
		_at("cova", p.x, p.y, PI / 2 + rng.randf_range(-0.3, 0.3))
	_at("cruz", 49, 9, 0.35).rotation.z = 0.3
	_marker("CruzEnjeitados", 49, 9)
	_pickup(40, -3, 25.0)
	_at("mandacaru", 54, 0)
	_at("xique_xique", 44, 20)
	_trigger("G_Cemiterio", 27, 6, Vector3(5, 4, 30))
	_marker("E1", 46, -1)
	_marker("E2a", 46, 13)
	_marker("E2b", 36, 16)


func _z3_trilha() -> void:
	for p in RELEVO.DESCIDA:
		for side in [-1.0, 1.0]:
			_at("pedra", p.x + side * 5.0, p.z + side * 2.0, rng.randf() * TAU)
	_at("arvore_seca", 24, 38)
	_pickup(22, 40, 25.0)


func _z4_grota() -> void:
	for z in range(61, 131, 11):
		for side in [-1.0, 1.0]:
			var wall := _at("paredao", side * 16.5, z, PI / 2 + rng.randf_range(-0.08, 0.08))
			wall.scale = Vector3(1.0, 2.0, 1.0)
	_trigger("G_Grota", 4, 66, Vector3(28, 6, 6))
	_at("barraca_rasgada", -6, 78, 0.4)
	_at("barraca_rasgada", 6, 84, -0.5)
	_at("fogueira_apagada", 0, 88)
	var bodies := [Vector2(-4, 80), Vector2(3, 90), Vector2(8, 94), Vector2(-3, 97), Vector2(-9, 102), Vector2(10, 106)]
	for i in bodies.size():
		var body := _at("corpo", bodies[i].x, bodies[i].y, rng.randf() * TAU)
		if i == 5:
			body.scale = Vector3.ONE * 0.7
		_marker("Corpo_%d" % i, bodies[i].x, bodies[i].y)
	_at("pedra", 9, 102).scale = Vector3.ONE * 1.8
	_marker("E3a", -3, 97)
	_marker("E3b", -6, 92)
	_marker("E3c", 6, 112)
	_marker("JuremaPos", 0, 118)
	_marker("JuremaSaida", -14, 116)
	_pickup(-20, 118, 50.0)
	for p in [Vector2(-19, 113), Vector2(-19, 121), Vector2(-22, 117)]:
		_at("pedra", p.x, p.y).scale = Vector3.ONE * 2.2


func _z5_saida() -> void:
	_at("cova", -9, 134, 0.3)
	_at("cova", 11, 139, -0.4)
	_marker("E4a", -9, 134)
	_marker("E4b", 11, 139)
	_at("pedra", 3, 138).scale = Vector3.ONE * 1.5
	_at("pedra", -4, 146).scale = Vector3.ONE * 1.5
	_trigger("G_Saida", 0, 128, Vector3(28, 6, 5))
	_at("cruz_exvoto", 15, 166, 0.2)
	_trigger("G_Estrada", 15, 164, Vector3(10, 5, 6))
	for x in range(-28, 60, 8):
		_at("cerca_varas", x, 170)


func _caatinga_fechada() -> void:
	var placed := 0
	while placed < 140:
		var x := rng.randf_range(-42, 42)
		var z := rng.randf_range(-38, 168)
		if RELEVO.altura(x, z) != 0.0 or _open_area(x, z):
			continue
		var kind: String = ["arvore_seca", "arvore_seca", "pedra", "mandacaru", "xique_xique"][rng.randi() % 5]
		_at(kind, x, z, rng.randf() * TAU)
		placed += 1


func _open_area(x: float, z: float) -> bool:
	var p := Vector2(x, z)
	if p.distance_to(Vector2(0, 0)) < 20.0 or p.distance_to(Vector2(36, 6)) < 18.0:
		return true
	if z > -22.0 and z < -14.0 or (absf(x) < 4.0 and z < -18.0):
		return true
	if z > 150.0 and z < 172.0 and x > -6.0 and x < 30.0:
		return true
	return p.distance_to(Vector2(30, 18)) < 10.0


func _enemies() -> void:
	pass


func _bounds() -> void:
	var walls := StaticBody3D.new()
	walls.name = "Limites"
	_own(walls, scene_root)
	var min_corner := RELEVO.CENTER - Vector3(RELEVO.SIZE.x, 0, RELEVO.SIZE.y) / 2.0
	var max_corner := RELEVO.CENTER + Vector3(RELEVO.SIZE.x, 0, RELEVO.SIZE.y) / 2.0
	var boxes := [
		[Vector3(RELEVO.SIZE.x, 12, 1), Vector3(RELEVO.CENTER.x, 0, min_corner.z + 1)],
		[Vector3(RELEVO.SIZE.x, 12, 1), Vector3(RELEVO.CENTER.x, 0, max_corner.z - 1)],
		[Vector3(1, 12, RELEVO.SIZE.y), Vector3(min_corner.x + 1, 0, RELEVO.CENTER.z)],
		[Vector3(1, 12, RELEVO.SIZE.y), Vector3(max_corner.x - 1, 0, RELEVO.CENTER.z)],
	]
	for b in boxes:
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = b[0]
		shape.shape = box
		shape.position = b[1] + Vector3.UP * 4
		_own(shape, walls)


func _at(kind: String, x: float, z: float, yaw := 0.0) -> Node3D:
	return _prop(kind, Vector3(x, RELEVO.altura(x, z), z), yaw, rng.randi() % 100000)


func _pickup(x: float, z: float, amount: float) -> void:
	var can := Area3D.new()
	can.name = "Querosene"
	can.set_script(PICKUP)
	can.refill = amount
	can.position = Vector3(x, RELEVO.altura(x, z), z)
	_own(can, scene_root)


func _marker(marker_name: String, x: float, z: float) -> void:
	var marker := Marker3D.new()
	marker.name = marker_name
	marker.position = Vector3(x, RELEVO.altura(x, z), z)
	_own(marker, scene_root)


func _trigger(trigger_name: String, x: float, z: float, size: Vector3) -> void:
	var area := Area3D.new()
	area.name = trigger_name
	area.set_script(GATILHO)
	area.tamanho = size
	area.position = Vector3(x, RELEVO.altura(x, z) - 1.0, z)
	_own(area, scene_root)
