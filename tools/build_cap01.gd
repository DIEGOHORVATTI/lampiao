extends "res://tools/build_sertao.gd"

const GATILHO := preload("res://world/gatilho.gd")


func _setup() -> void:
	out_path = "res://world/cap01/cap01.tscn"
	map_size = 130.0
	map_center = Vector3(12, 0, 30)
	player_start = Vector3(1.5, 1, 3.5)
	root_script = load("res://world/cap01/cap01.gd")
	rng.seed = 280738


func _layout() -> void:
	_prop("terreno_grande", map_center, 0, 11)
	_acampamento()
	_cemiterio()
	_grota()
	_saida()
	_scatter_band("mandacaru", 34, 300)
	_scatter_band("arvore_seca", 18, 400)
	_scatter_band("pedra", 30, 500)


func _acampamento() -> void:
	_prop("fogueira", Vector3(0, 0, 0), 0, 1)
	_prop("barraca_lona", Vector3(6, 0, -3), 0.3, 2)
	_marker("Barraca", Vector3(4.6, 0, -1.2))
	_prop("carroca_tombada", Vector3(-6, 0, 3), 0.4, 3)
	_trigger("G_Carroca", Vector3(-6, 0, 3), Vector3(7, 4, 7))
	for i in 5:
		_prop("caixote", Vector3(3 + i * 0.7, 0, 4 + (i % 2) * 0.8), 0, 20 + i)
	_marker("Lata", Vector3(1.8, 0, 1.2))
	_prop("lampiao", Vector3(1.8, 0.0, 1.2), 0, 1).visible = false
	_prop("corpo", Vector3(-1.5, 0, 5.5), 1.2, 30)
	_prop("cerca_varas", Vector3(-12, 0, -6), 1.2, 31)


func _cemiterio() -> void:
	var c := Vector3(24, 0, -2)
	_prop("muro_pedra", c + Vector3(0, 0, -5), 0, 40)
	_prop("muro_pedra", c + Vector3(0, 0, 5), 0, 41)
	_prop("muro_pedra", c + Vector3(-4, 0, 0), PI / 2, 42)
	_prop("muro_pedra", c + Vector3(4, 0, 0), PI / 2, 43)
	for i in 6:
		_prop("cruz", c + Vector3(-2.5 + (i % 3) * 2.5, 0, -2 + int(i / 3) * 3), 0, 44 + i)
	for i in 5:
		_prop("cova", c + Vector3(7 + (i % 2) * 2.5, 0, -6 + i * 3), PI / 2, 50 + i)
	_prop("cerca_varas", c + Vector3(-6, 0, 7), 0.6, 56)
	_trigger("G_Cemiterio", c + Vector3(-8, 0, 2), Vector3(6, 4, 14))
	_marker("E1", c + Vector3(-5, 0, 8))
	_marker("E2a", c + Vector3(8, 0, 4))
	_marker("E2b", c + Vector3(9, 0, -7))


func _grota() -> void:
	for i in 4:
		var z := 14.0 + i * 9.0
		_prop("paredao", Vector3(12, 0, z), PI / 2 + rng.randf_range(-0.15, 0.15), 60 + i)
		_prop("paredao", Vector3(30, 0, z), PI / 2 + rng.randf_range(-0.15, 0.15), 70 + i)
	_trigger("G_Grota", Vector3(21, 0, 44), Vector3(14, 5, 6))
	var bowl := Vector3(21, 0, 54)
	for i in 7:
		var a := PI + i * PI / 6.0
		var pos := bowl + Vector3(cos(a), 0, sin(a)) * Vector3(16, 1, 14) + Vector3(0, 0, 4)
		if i == 3:
			continue
		_prop("paredao", pos, -a + PI / 2, 80 + i)
	_prop("fogueira_apagada", bowl, 0, 90)
	_prop("barraca_rasgada", bowl + Vector3(-5, 0, -2), 0.8, 91)
	_prop("barraca_rasgada", bowl + Vector3(4, 0, -4), -0.5, 92)
	_prop("pedra", bowl + Vector3(6, 0, 4), 0, 93)
	var bodies := [Vector3(-3, 0, 1), Vector3(-1, 0, 4), Vector3(2, 0, 2.5), Vector3(-6, 0, 5), Vector3(3.5, 0, -1), Vector3(7, 0, 5.5)]
	for i in bodies.size():
		_prop("corpo", bowl + bodies[i], rng.randf() * TAU, 94 + i)
		_marker("Corpo_%d" % i, bowl + bodies[i])
	_marker("E3a", bowl + Vector3(-9, 0, 0))
	_marker("E3b", bowl + Vector3(9, 0, -5))
	_marker("E3c", bowl + Vector3(0, 0, 9))
	_marker("JuremaPos", bowl + Vector3(0, 0, -8))
	_marker("JuremaSaida", bowl + Vector3(0, 0, 18))
	_prop("pedra", bowl + Vector3(-9, 0, 9), 0, 101)
	var can := Area3D.new()
	can.name = "QueroseneS2"
	can.set_script(load("res://world/sertao/kerosene_pickup.gd"))
	can.position = bowl + Vector3(-8, 0, 10.5)
	_own(can, scene_root)


func _saida() -> void:
	var foot := Vector3(21, 0, 70)
	for i in 4:
		_prop("cova", foot + Vector3(-6 + i * 4, 0, -2), rng.randf() * TAU, 110 + i)
	_marker("E4a", foot + Vector3(-7, 0, -1))
	_marker("E4b", foot + Vector3(7, 0, -1))
	_trigger("G_Saida", foot + Vector3(0, 0, -6), Vector3(14, 5, 4))
	_prop("cruz_exvoto", foot + Vector3(2, 0, 12), 0.2, 120)
	_trigger("G_Estrada", foot + Vector3(0, 0, 12), Vector3(16, 5, 5))
	for i in 8:
		_prop("cerca_varas", foot + Vector3(-28 + i * 8, 0, 16), 0, 121 + i)


func _scatter_band(kind: String, count: int, seed_base: int) -> void:
	var placed := 0
	var tries := 0
	while placed < count and tries < count * 20:
		tries += 1
		var pos := map_center + Vector3(rng.randf_range(-58, 58), 0, rng.randf_range(-58, 58))
		if _near_path(pos):
			continue
		_prop(kind, pos, rng.randf() * TAU, seed_base + placed)
		placed += 1


func _near_path(pos: Vector3) -> bool:
	var keep := [Vector3(0, 0, 0), Vector3(24, 0, -2), Vector3(21, 0, 54), Vector3(21, 0, 70), Vector3(21, 0, 82)]
	for k in keep:
		if pos.distance_to(k) < 14.0:
			return true
	if pos.x > 8 and pos.x < 34 and pos.z > 8 and pos.z < 90:
		return true
	return pos.distance_to(Vector3(12, 0, 0)) < 10.0


func _enemies() -> void:
	pass


func _marker(marker_name: String, pos: Vector3) -> void:
	var marker := Marker3D.new()
	marker.name = marker_name
	marker.position = pos
	_own(marker, scene_root)


func _trigger(trigger_name: String, pos: Vector3, size: Vector3) -> void:
	var area := Area3D.new()
	area.name = trigger_name
	area.set_script(GATILHO)
	area.tamanho = size
	area.position = pos
	_own(area, scene_root)
