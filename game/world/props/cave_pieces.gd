const P := preload("res://game/world/props/prop_library.gd")
const CAVE := preload("res://game/world/chapters/chapter_01/cave_field.gd")
const DRUM_RADIUS := 0.78
const MOUTH_HALF_WIDTH := 30.0
const MOUTH_ARCH_X := 0.6
const MOUTH_ARCH_HALF := 2.6
const MOUTH_ARCH_SPRING := 3.0
const MOUTH_ARCH_TOP := 5.4
const MOUTH_ARCH_DEPTH := 1.8
const MOUTH_PROFILE := [Vector2(-1.8, -0.6), Vector2(-1.5, 2.0), Vector2(-1.1, 4.4), Vector2(-0.5, 6.4), Vector2(0.7, 8.6), Vector2(2.6, 10.9), Vector2(5.0, 12.7), Vector2(8.5, 13.6), Vector2(13.0, 13.0), Vector2(18.0, 10.6), Vector2(22.0, 8.0)]


static func idol_column(rng: RandomNumberGenerator) -> Node3D:
	return _idol(rng, Basis.IDENTITY, 3)


static func idol_column_tilted(rng: RandomNumberGenerator) -> Node3D:
	return _idol(rng, Basis(Vector3.FORWARD, 0.3) * Basis(Vector3.RIGHT, -0.08), 2)


static func idol_totem(rng: RandomNumberGenerator) -> Node3D:
	return idol_column(rng)


static func _idol(rng: RandomNumberGenerator, tilt: Basis, drums: int) -> Node3D:
	var root := P._static_body()
	var holder := Node3D.new()
	holder.transform = Transform3D(tilt, Vector3.ZERO)
	root.add_child(holder)
	var top := _drum_stack(holder, rng, drums, DRUM_RADIUS)
	P._add_cylinder(holder, 1.08, 0.36, Vector3(0, top + 0.18, 0), "carved", 16)
	for i in 14:
		var a := TAU * i / 14.0
		P._add_box(holder, Vector3(0.2, 0.2, 0.14), Vector3(cos(a) * 0.98, top + 0.44, sin(a) * 0.98), "carved", Basis(Vector3.UP, -a + PI / 2))
	_idol_head(holder, Vector3(0, top + 0.36, 0), rng)
	var height := top + 2.4
	P._add_cylinder(root, DRUM_RADIUS + 0.1, height, tilt * Vector3(0, height / 2.0, 0), "", 8, tilt, true)
	return root


static func _drum_stack(parent: Node3D, rng: RandomNumberGenerator, count: int, radius: float) -> float:
	var y := 0.0
	for i in count:
		var h := rng.randf_range(0.85, 1.15)
		var shift := Vector3(rng.randf_range(-0.05, 0.05), 0, rng.randf_range(-0.05, 0.05))
		var squeeze := Basis(Vector3.UP, rng.randf() * TAU) * Basis(Vector3.FORWARD, rng.randf_range(-0.025, 0.025))
		P._add_cylinder(parent, radius * rng.randf_range(0.97, 1.04), h, Vector3(0, y + h / 2.0, 0) + shift, "carved", 14, squeeze)
		y += h
	return y


static func _idol_head(parent: Node3D, base: Vector3, rng: RandomNumberGenerator) -> void:
	var w := 1.6
	var h := 1.8
	var head := Node3D.new()
	head.transform = Transform3D(Basis(Vector3.UP, rng.randf_range(-0.15, 0.15)), base)
	parent.add_child(head)
	P._add_box(head, Vector3(w, h, 0.7), Vector3(0, h / 2.0, -0.35), "carved")
	P._add_box(head, Vector3(w, 0.8, 0.75), Vector3(0, h - 0.4, 0.37), "carved")
	P._add_box(head, Vector3(w * 0.92, 0.32, 0.85), Vector3(0, 0.16, 0.42), "carved")
	for side in [-1.0, 1.0]:
		P._add_box(head, Vector3(0.22, 0.7, 0.72), Vector3(side * (w / 2.0 - 0.11), 0.65, 0.36), "carved")
		P._add_box(head, Vector3(0.18, 1.1, 0.55), Vector3(side * (w / 2.0 + 0.09), 1.0, -0.05), "carved")
		P._add_box(head, Vector3(0.5, 0.24, 0.06), Vector3(side * 0.4, 1.36, 0.76), "void", Basis(Vector3.FORWARD, side * 0.32))
		P._add_box(head, Vector3(0.62, 0.13, 0.2), Vector3(side * 0.4, 1.55, 0.78), "carved", Basis(Vector3.FORWARD, side * 0.32))
		P._add_box(head, Vector3(0.16, 0.42, 0.14), Vector3(side * 0.5, 0.78, 0.66), "carved", Basis(Vector3.FORWARD, side * 0.08))
		P._add_box(head, Vector3(0.14, 0.32, 0.14), Vector3(side * 0.34, 0.45, 0.72), "carved", Basis(Vector3.FORWARD, -side * 0.1))
	P._add_box(head, Vector3(w - 0.44, 0.7, 0.05), Vector3(0, 0.65, 0.02), "void")
	for i in 6:
		var x := -0.4 + i * 0.16
		P._add_box(head, Vector3(0.11, 0.2, 0.1), Vector3(x, 0.9, 0.68), "carved")
		P._add_box(head, Vector3(0.11, 0.16, 0.1), Vector3(x, 0.4, 0.74), "carved")
	P._add_box(head, Vector3(0.26, 0.34, 0.16), Vector3(0, 1.12, 0.8), "carved")
	P._add_box(head, Vector3(w + 0.5, 0.24, 1.6), Vector3(0, h + 0.12, 0.0), "carved")
	P._add_box(head, Vector3(w + 0.2, 0.4, 0.14), Vector3(0, h + 0.3, 0.78), "carved", Basis(Vector3.RIGHT, -0.25))


static func fallen_column(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var lean := Basis(Vector3.BACK, deg_to_rad(64.0))
	var holder := Node3D.new()
	holder.transform = Transform3D(lean, Vector3(0, 0.3, 0))
	root.add_child(holder)
	var length := _drum_stack(holder, rng, 9, 0.68)
	for i in 6:
		var start := Vector3(rng.randf_range(-0.2, 0.2), rng.randf_range(1.0, length - 1.0), 0.0)
		_vine(holder, rng, start, 0.68)
	var axis := lean * Vector3.UP
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(1.3, length, 1.3)
	shape.shape = box
	shape.transform = Transform3D(lean, Vector3(0, 0.3, 0) + axis * length / 2.0)
	root.add_child(shape)
	return root


static func _vine(parent: Node3D, rng: RandomNumberGenerator, start: Vector3, radius: float) -> void:
	var points: Array = []
	var a := rng.randf() * TAU
	var y := start.y
	for i in 7:
		points.append(Vector3(cos(a) * (radius + 0.03), y, sin(a) * (radius + 0.03)))
		a += rng.randf_range(0.4, 0.9)
		y += rng.randf_range(-0.35, 0.1)
	var hang: Vector3 = points[-1]
	for i in 3:
		hang += Vector3(rng.randf_range(-0.1, 0.1), 0, rng.randf_range(-0.1, 0.1)) + parent.transform.basis.inverse() * Vector3(0, -0.45, 0)
		points.append(hang)
	P._add_tube(parent, points, 0.05, 0.012, "root", 5)


static func drum_column(rng: RandomNumberGenerator) -> Node3D:
	return _outdoor_column(rng, rng.randi_range(4, 5), false)


static func broken_drum_column(rng: RandomNumberGenerator) -> Node3D:
	return _outdoor_column(rng, 2, true)


static func trail_pillar(rng: RandomNumberGenerator) -> Node3D:
	var root := _outdoor_column(rng, rng.randi_range(5, 8), rng.randf() < 0.3, rng.randf_range(1.1, 1.45))
	root.rotation = Vector3(rng.randf_range(-0.06, 0.06), rng.randf() * TAU, rng.randf_range(-0.06, 0.06))
	return root


static func _outdoor_column(rng: RandomNumberGenerator, drums: int, broken: bool, radius := 0.85) -> Node3D:
	var root := P._static_body()
	var top := _drum_stack(root, rng, drums, radius)
	if broken:
		for i in 5:
			var a := TAU * i / 5.0 + rng.randf()
			P._add_box(root, Vector3(0.5, rng.randf_range(0.2, 0.55), 0.4) * radius / 0.85, Vector3(cos(a), 0, sin(a)) * radius * 0.53 + Vector3(0, top + 0.1, 0), "carved", Basis(Vector3.UP, -a) * Basis(Vector3.RIGHT, rng.randf_range(-0.3, 0.3)))
		P._add_cylinder(root, radius, 0.9, Vector3(1.6, radius, 0.8), "carved", 14, Basis(Vector3.UP, 0.6) * Basis(Vector3.RIGHT, PI / 2))
	else:
		P._add_cylinder(root, radius + 0.15, 0.3, Vector3(0, top + 0.15, 0), "carved", 14)
	for i in 4:
		_vine(root, rng, Vector3(0, rng.randf_range(top * 0.4, top), 0), radius)
	P._add_cylinder(root, radius, top, Vector3(0, top / 2.0, 0), "", 8, Basis.IDENTITY, true)
	return root


static func block_pillar(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var y := 0.0
	for i in 5:
		var h := rng.randf_range(0.4, 0.55)
		P._add_box(root, Vector3(0.8, h - 0.04, 0.8) * Vector3(rng.randf_range(0.9, 1.05), 1, rng.randf_range(0.9, 1.05)), Vector3(rng.randf_range(-0.05, 0.05), y + h / 2.0, rng.randf_range(-0.05, 0.05)), "carved", Basis(Vector3.UP, rng.randf_range(-0.12, 0.12)))
		y += h
	P._add_box(root, Vector3(0.6, y, 0.6), Vector3(0, y / 2.0, 0), "stone")
	_vine(root, rng, Vector3(0, y - 0.2, 0), 0.5)
	P._add_box_shape(root, Vector3(0.9, y, 0.9), Vector3(0, y / 2.0, 0))
	return root


static func arched_block_wall(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var width := 9.0
	var height := 6.6
	var door := 1.15
	var spring := 2.2
	P._add_box(root, Vector3(width, height, 0.4), Vector3(0, height / 2.0, -0.45), "stone")
	P._add_box(root, Vector3(door * 2.0 + 0.2, spring + door + 0.2, 0.06), Vector3(0, (spring + door) / 2.0, -0.2), "void")
	var y := 0.0
	var row := 0
	while y < height:
		var h := rng.randf_range(0.5, 0.65)
		var x := -width / 2.0 - (0.4 if row % 2 == 1 else 0.0)
		while x < width / 2.0:
			var len := rng.randf_range(0.8, 1.4)
			var center := Vector3(x + len / 2.0, y + h / 2.0, 0)
			if not _in_arch(center, len, h, door, spring) and absf(center.x) < width / 2.0:
				P._add_box(root, Vector3(len - 0.06, h - 0.06, 0.55), center + Vector3(0, 0, rng.randf_range(-0.04, 0.04)), "carved", Basis(Vector3.FORWARD, rng.randf_range(-0.02, 0.02)))
			x += len
		y += h
		row += 1
	for i in 9:
		var a := PI * (i + 0.5) / 9.0
		var center := Vector3(cos(a) * (door + 0.3), spring + sin(a) * (door + 0.3), 0.08)
		P._add_box(root, Vector3(0.36, 0.62, 0.6), center, "carved", Basis(Vector3.FORWARD, a - PI / 2))
	for side in [-1.0, 1.0]:
		P._add_box(root, Vector3(0.36, spring, 0.6), Vector3(side * (door + 0.3), spring / 2.0, 0.08), "carved")
		P._add_box_shape(root, Vector3(width / 2.0 - door, height, 0.9), Vector3(side * (width / 2.0 + door) / 2.0, height / 2.0, -0.2))
	P._add_box_shape(root, Vector3(door * 2.0, height - spring - door, 0.9), Vector3(0, (height + spring + door) / 2.0, -0.2))
	P._add_box_shape(root, Vector3(door * 2.0, spring + door, 0.3), Vector3(0, (spring + door) / 2.0, -0.4))
	for i in 5:
		var start := Vector3(rng.randf_range(-width / 2.0, width / 2.0), height - 0.1, 0.33)
		_wall_root(root, rng, start, rng.randf_range(1.5, 4.0))
	return root


static func _in_arch(center: Vector3, len: float, h: float, door: float, spring: float) -> bool:
	var reach := door + 0.5
	if absf(center.x) - len / 2.0 > reach:
		return false
	return center.y - h / 2.0 < spring + reach


static func _wall_root(root: Node3D, rng: RandomNumberGenerator, start: Vector3, length: float) -> void:
	var points: Array = [start]
	var p := start
	var steps := int(length / 0.4)
	for i in steps:
		p += Vector3(rng.randf_range(-0.18, 0.18), -0.4, 0)
		points.append(p)
	P._add_tube(root, points, 0.06, 0.012, "root", 5)


static func cave_mouth(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var noise := FastNoiseLite.new()
	noise.seed = rng.randi()
	noise.frequency = 0.16
	noise.fractal_octaves = 3
	var sheet := func(u: float, v: float) -> Vector3: return _hill_point(noise, u, v)
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	_hill_sheet(st, sheet)
	_arch_jamb(st, sheet)
	st.generate_normals()
	var mesh := st.commit()
	root.add_child(P._mesh_instance(mesh, "stone_double"))
	var shape := CollisionShape3D.new()
	shape.shape = mesh.create_trimesh_shape()
	root.add_child(shape)
	var vines := SurfaceTool.new()
	vines.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in 150:
		_hill_vine(vines, rng, sheet)
	for i in 14:
		_arch_root(vines, rng, sheet)
	vines.generate_normals()
	root.add_child(P._mesh_instance(vines.commit(), "root"))
	return root


static func _hill_point(noise: FastNoiseLite, u: float, v: float) -> Vector3:
	var x := u * MOUTH_HALF_WIDTH
	var base := _profile(v)
	var side := absf(u)
	var height := 1.0 - 0.45 * side * side
	var tuck := maxf(side - 0.72, 0.0) * 34.0
	var p := Vector3(x, base.y * height, base.x + tuck)
	var lump := Vector3(noise.get_noise_3d(x, p.y, 7.0) * 0.6, noise.get_noise_3d(x, p.y, 31.0) * 0.5, noise.get_noise_3d(x, p.y, 0.0) * 1.3)
	var grip := smoothstep(0.0, 0.06, v) * _arch_calm(x, p.y)
	return p + lump * grip + Vector3(0, 0, -0.25 * (1.0 - grip))


static func _profile(v: float) -> Vector2:
	var t := v * (MOUTH_PROFILE.size() - 1)
	var i := mini(int(t), MOUTH_PROFILE.size() - 2)
	return MOUTH_PROFILE[i].lerp(MOUTH_PROFILE[i + 1], t - i)


static func _arch_calm(x: float, y: float) -> float:
	var q := Vector2((x - MOUTH_ARCH_X) / MOUTH_ARCH_HALF, maxf(y - MOUTH_ARCH_SPRING, 0.0) / (MOUTH_ARCH_TOP - MOUTH_ARCH_SPRING))
	return smoothstep(1.1, 2.2, q.length())


static func _in_mouth_arch(x: float, y: float) -> bool:
	var dx := absf(x - MOUTH_ARCH_X)
	var half := MOUTH_ARCH_HALF + 0.3
	if y < MOUTH_ARCH_SPRING:
		return dx < half
	var k := (y - MOUTH_ARCH_SPRING) / (MOUTH_ARCH_TOP + 0.3 - MOUTH_ARCH_SPRING)
	return k < 1.0 and dx < half * sqrt(1.0 - k * k)


static func _hill_sheet(st: SurfaceTool, sheet: Callable) -> void:
	var cols := 96
	var rows := 44
	var grid: Array = []
	for r in rows + 1:
		var row: Array = []
		for c in cols + 1:
			row.append(sheet.call(lerpf(-1.0, 1.0, float(c) / cols), float(r) / rows))
		grid.append(row)
	for r in rows:
		for c in cols:
			var quad: Array = [grid[r][c], grid[r][c + 1], grid[r + 1][c], grid[r + 1][c + 1]]
			var mid: Vector3 = (quad[0] + quad[3]) / 2.0
			var plain := _profile((r + 0.5) / rows)
			if plain.x < 1.0 and _in_mouth_arch(lerpf(-1.0, 1.0, (c + 0.5) / cols) * MOUTH_HALF_WIDTH, plain.y):
				continue
			_quad(st, quad)


static func _quad(st: SurfaceTool, q: Array) -> void:
	for k in [0, 2, 1, 1, 2, 3]:
		st.add_vertex(q[k])


static func _arch_outline() -> Array:
	var points: Array = []
	for y in [-0.6, 0.6, 1.6, 2.4]:
		points.append(Vector2(MOUTH_ARCH_X - MOUTH_ARCH_HALF, y))
	for i in 25:
		var a := PI * i / 24.0
		points.append(Vector2(MOUTH_ARCH_X - cos(a) * MOUTH_ARCH_HALF, MOUTH_ARCH_SPRING + (MOUTH_ARCH_TOP - MOUTH_ARCH_SPRING) * sin(a)))
	for y in [2.4, 1.6, 0.6, -0.6]:
		points.append(Vector2(MOUTH_ARCH_X + MOUTH_ARCH_HALF, y))
	return points


static func _arch_jamb(st: SurfaceTool, sheet: Callable) -> void:
	var outline := _arch_outline()
	var rings: Array = []
	for p in outline:
		var on: Vector3 = sheet.call(p.x / MOUTH_HALF_WIDTH, _profile_v(maxf(p.y, -0.6)))
		var out := Vector2(p.x - MOUTH_ARCH_X, maxf(p.y - MOUTH_ARCH_SPRING, 0.0)).normalized()
		var lip := Vector3(p.x, p.y, on.z - 0.12)
		rings.append([lip + Vector3(out.x, out.y, 0.0) * 0.9 + Vector3(0, 0, -0.05), lip, lip + Vector3(-out.x * 0.4, -out.y * 0.3, MOUTH_ARCH_DEPTH)])
	for i in rings.size() - 1:
		for k in 2:
			_quad(st, [rings[i][k], rings[i + 1][k], rings[i][k + 1], rings[i + 1][k + 1]])


static func _profile_v(y: float) -> float:
	for i in MOUTH_PROFILE.size() - 1:
		var lo: Vector2 = MOUTH_PROFILE[i]
		var hi: Vector2 = MOUTH_PROFILE[i + 1]
		if y <= hi.y:
			return (i + clampf((y - lo.y) / (hi.y - lo.y), 0.0, 1.0)) / (MOUTH_PROFILE.size() - 1)
	return 1.0


static func _hill_vine(st: SurfaceTool, rng: RandomNumberGenerator, sheet: Callable) -> void:
	var u := rng.randf_range(-0.8, 0.8)
	var v := rng.randf_range(0.25, 0.75)
	var points: Array = []
	for i in rng.randi_range(8, 22):
		var p: Vector3 = sheet.call(u, v)
		if v < 0.02 or (_profile(v).x < 1.0 and _in_mouth_arch(p.x, _profile(v).y)):
			break
		points.append(p + Vector3(0, 0, -0.12))
		u += rng.randf_range(-0.012, 0.012)
		v -= rng.randf_range(0.012, 0.03)
	if points.size() > 2:
		P.tube(st, points, rng.randf_range(0.04, 0.11), 0.012, 5)


static func _arch_root(st: SurfaceTool, rng: RandomNumberGenerator, sheet: Callable) -> void:
	var x := MOUTH_ARCH_X + rng.randf_range(-MOUTH_ARCH_HALF - 1.5, MOUTH_ARCH_HALF + 1.5)
	var u := x / MOUTH_HALF_WIDTH
	var v := _profile_v(MOUTH_ARCH_TOP + rng.randf_range(0.6, 2.5))
	var points: Array = []
	for i in 12:
		var p: Vector3 = sheet.call(u, v)
		points.append(p + Vector3(0, 0, -0.15))
		v -= 0.02
		u += rng.randf_range(-0.01, 0.01)
		if _profile(v).y < MOUTH_ARCH_TOP - 0.2 and _in_mouth_arch(p.x, _profile(v).y):
			break
	var tip: Vector3 = points[-1]
	for i in 3:
		tip += Vector3(rng.randf_range(-0.15, 0.15), -rng.randf_range(0.3, 0.7), rng.randf_range(0.0, 0.2))
		points.append(tip)
	P.tube(st, points, rng.randf_range(0.06, 0.12), 0.01, 5)


static func roots_mesh(z_min: float, z_max: float, count: int) -> ArrayMesh:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(z_min * 31.0 + z_max)
	var noise := P.surface_noise()
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var made := 0
	var tries := 0
	while made < count and tries < count * 40:
		tries += 1
		var x := rng.randf_range(CAVE.MIN.x, CAVE.MAX.x)
		var z := rng.randf_range(z_min, z_max)
		var s: Dictionary = CAVE.sample(x, z)
		if not s.roof or s.d > 0.3 or s.d < -2.6:
			continue
		if is_nan(CAVE.ceiling_height(x, z)):
			continue
		if s.d > -1.2 and rng.randf() < 0.65:
			_crawling_root(st, rng, noise, x, z)
		else:
			_hanging_roots(st, rng, noise, x, z)
		made += 1
	st.generate_normals()
	return st.commit()


static func _ceiling(noise: FastNoiseLite, x: float, z: float) -> float:
	return P.surface_height(CAVE, "ceiling_height", noise, x, z)


static func _crawling_root(st: SurfaceTool, rng: RandomNumberGenerator, noise: FastNoiseLite, x: float, z: float) -> void:
	var points: Array = []
	var pos := Vector2(x, z)
	var drift := Vector2.from_angle(rng.randf() * TAU) * 0.25
	for i in rng.randi_range(6, 16):
		var y := _ceiling(noise, pos.x, pos.y)
		if is_nan(y):
			break
		var floor_y := CAVE.floor_height(pos.x, pos.y)
		if y - floor_y < 0.15:
			break
		points.append(Vector3(pos.x, y - 0.05, pos.y))
		var e := 0.3
		var grad := Vector2(CAVE.sample(pos.x + e, pos.y).d - CAVE.sample(pos.x - e, pos.y).d, CAVE.sample(pos.x, pos.y + e).d - CAVE.sample(pos.x, pos.y - e).d).normalized()
		pos += grad * 0.28 + drift + Vector2(rng.randf_range(-0.12, 0.12), rng.randf_range(-0.12, 0.12))
	if points.size() > 2:
		P.tube(st, points, rng.randf_range(0.04, 0.09), 0.012, 5)


static func _hanging_roots(st: SurfaceTool, rng: RandomNumberGenerator, noise: FastNoiseLite, x: float, z: float) -> void:
	var top := _ceiling(noise, x, z)
	var room := top - CAVE.floor_height(x, z) - 2.3
	if is_nan(top) or room < 0.3:
		return
	for k in rng.randi_range(2, 5):
		var origin := Vector3(x + rng.randf_range(-0.4, 0.4), 0, z + rng.randf_range(-0.4, 0.4))
		origin.y = _ceiling(noise, origin.x, origin.z) + 0.1
		if is_nan(origin.y):
			continue
		var length := minf(rng.randf_range(0.4, 2.0), room)
		var points: Array = [origin]
		var p := origin
		for i in 4:
			p += Vector3(rng.randf_range(-0.12, 0.12), -length / 4.0, rng.randf_range(-0.12, 0.12))
			points.append(p)
		P.tube(st, points, rng.randf_range(0.025, 0.05), 0.006, 4)


static func cauldron(_rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	_pot(root, Vector3.ZERO)
	return root


static func _pot(root: Node3D, base: Vector3) -> void:
	var body := SphereMesh.new()
	body.radius = 0.36
	body.height = 0.5
	body.radial_segments = 14
	body.rings = 7
	var mi := P._mesh_instance(body, "iron")
	mi.position = base + Vector3(0, 0.24, 0)
	root.add_child(mi)
	var rim := TorusMesh.new()
	rim.inner_radius = 0.27
	rim.outer_radius = 0.33
	rim.rings = 14
	rim.ring_segments = 5
	var rim_mi := P._mesh_instance(rim, "iron")
	rim_mi.position = base + Vector3(0, 0.46, 0)
	root.add_child(rim_mi)
	P._add_cylinder(root, 0.29, 0.02, base + Vector3(0, 0.42, 0), "gourd", 14)
	for side in [-1.0, 1.0]:
		var handle := TorusMesh.new()
		handle.inner_radius = 0.06
		handle.outer_radius = 0.085
		handle.rings = 8
		handle.ring_segments = 4
		var h_mi := P._mesh_instance(handle, "iron")
		h_mi.transform = Transform3D(Basis(Vector3.FORWARD, PI / 2), base + Vector3(side * 0.37, 0.4, 0))
		root.add_child(h_mi)


static func stone_stove(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	for layer in 3:
		var count := 9 - layer
		for i in count:
			var a := TAU * (i + layer * 0.5) / count
			if layer == 0 and absf(wrapf(a - PI / 2, -PI, PI)) < 0.4:
				continue
			P._add_stone(root, rng, rng.randf_range(0.15, 0.19), Vector3(cos(a) * 0.45, 0.1 + layer * 0.16, sin(a) * 0.45))
	P._add_cylinder(root, 0.3, 0.05, Vector3(0, 0.03, 0), "ember", 10)
	P._add_cylinder(root, 0.32, 0.04, Vector3(0, 0.08, 0), "ash", 10)
	_pot(root, Vector3(0, 0.38, 0))
	P._add_cylinder(root, 0.62, 0.9, Vector3(0, 0.45, 0), "", 8, Basis.IDENTITY, true)
	return root


static func coin_pile(rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	var mound := SphereMesh.new()
	mound.radius = 0.7
	mound.height = 0.5
	mound.radial_segments = 14
	mound.rings = 6
	mound.is_hemisphere = true
	var mi := P._mesh_instance(mound, "coins")
	mi.scale = Vector3(1.0, 0.6, 0.8)
	root.add_child(mi)
	for i in 40:
		var a := rng.randf() * TAU
		var r := rng.randf_range(0.6, 1.4)
		P._add_cylinder(root, 0.035, 0.012, Vector3(cos(a) * r, 0.008, sin(a) * r * 0.8), "coins", 7, Basis(Vector3.RIGHT, rng.randf_range(-0.2, 0.2)))
	var sack := SphereMesh.new()
	sack.radius = 0.32
	sack.height = 0.5
	sack.radial_segments = 10
	sack.rings = 6
	var sack_mi := P._mesh_instance(sack, "canvas")
	sack_mi.transform = Transform3D(Basis(Vector3.FORWARD, 1.2).scaled(Vector3(1.0, 1.5, 1.0)), Vector3(-0.9, 0.25, -0.3))
	root.add_child(sack_mi)
	return root


static func sleeping_mat(rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	P._add_box(root, Vector3(1.1, 0.04, 2.0), Vector3(0, 0.02, 0), "cloth", Basis(Vector3.UP, rng.randf_range(-0.05, 0.05)))
	P._add_box(root, Vector3(1.0, 0.05, 0.7), Vector3(0.05, 0.06, -0.55), "cloth", Basis(Vector3.UP, rng.randf_range(-0.2, 0.2)) * Basis(Vector3.FORWARD, 0.04))
	P._add_cylinder(root, 0.13, 0.9, Vector3(0, 0.12, 0.85), "canvas", 8, Basis(Vector3.FORWARD, PI / 2))
	return root


static func rolled_blanket(rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	P._add_cylinder(root, 0.16, 0.95, Vector3(0, 0.15, 0), "cloth", 10, Basis(Vector3.UP, rng.randf() * PI) * Basis(Vector3.FORWARD, PI / 2))
	return root


static func gourd_bowls(rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	for i in rng.randi_range(2, 3):
		var bowl := SphereMesh.new()
		bowl.radius = 0.12
		bowl.height = 0.12
		bowl.radial_segments = 10
		bowl.rings = 4
		bowl.is_hemisphere = true
		var mi := P._mesh_instance(bowl, "gourd")
		var pos := Vector3(rng.randf_range(-0.35, 0.35), 0.12, rng.randf_range(-0.35, 0.35))
		mi.transform = Transform3D(Basis(Vector3.RIGHT, PI), pos)
		root.add_child(mi)
		P._add_cylinder(root, 0.105, 0.01, pos + Vector3(0, 0.0, 0), "ash", 10)
	return root


static func hanging_bags(rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	P._add_cylinder(root, 0.035, 1.2, Vector3(0, 1.85, 0.3), "wood", 5, Basis(Vector3.RIGHT, PI / 2 - 0.15))
	for i in 2:
		var z := 0.35 + i * 0.4
		P._add_tube(root, [Vector3(-0.12, 1.86, z), Vector3(-0.16, 1.45, z), Vector3(0.16, 1.45, z), Vector3(0.12, 1.86, z)], 0.015, 0.015, "leather", 4)
		var bag := SphereMesh.new()
		bag.radius = 0.2
		bag.height = 0.4
		bag.radial_segments = 8
		bag.rings = 5
		var mi := P._mesh_instance(bag, "canvas" if i == 0 else "leather")
		mi.transform = Transform3D(Basis(Vector3.UP, rng.randf_range(-0.3, 0.3)).scaled(Vector3(1.0, 1.0, 0.55)), Vector3(0, 1.3, z))
		root.add_child(mi)
	return root


static func moonbeam(_rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	var cone := CylinderMesh.new()
	cone.top_radius = 2.6
	cone.bottom_radius = 3.6
	cone.height = 15.0
	cone.radial_segments = 16
	cone.cap_top = false
	cone.cap_bottom = false
	var mi := P._mesh_instance(cone, "moonbeam")
	mi.position.y = 7.5
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(mi)
	return root


static func stone_arch(rng: RandomNumberGenerator) -> Node3D:
	return cave_mouth(rng)
