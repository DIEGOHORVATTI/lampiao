const CELL := 0.75
const MIN := Vector2(-32, -40)
const MAX := Vector2(42, 98)
const ROCK_TOP := 9.0
const WALL_BLEND := 1.4

const ROOMS := [
	{"name": "boca", "min": Vector2(-12, -8), "max": Vector2(12, 16), "y": 0.0, "h": 6.0, "roof": true},
	{"name": "idolos", "min": Vector2(-14, 60), "max": Vector2(14, 92), "y": -6.0, "h": 12.0, "roof": true},
	{"name": "lajedo", "min": Vector2(-28, -36), "max": Vector2(38, -8), "y": 0.0, "h": 0.0, "roof": false},
]
const PATHS := [
	{"name": "galeria", "width": 3.2, "h": 3.6, "points": [Vector3(6, 0, 14), Vector3(4, -1, 26), Vector3(-4, -2.5, 36), Vector3(-2, -4, 46), Vector3(2, -5.5, 56), Vector3(0, -6, 62)]},
	{"name": "fenda", "width": 2.4, "h": 3.0, "points": [Vector3(12, -6, 80), Vector3(22, -5.5, 72), Vector3(26, -4.5, 60), Vector3(28, -3.5, 46), Vector3(30, -2.5, 32), Vector3(32, -1.5, 18), Vector3(34, -0.5, 6), Vector3(34, 0, -10)]},
]
const SKYLIGHT := Vector3(0, 0, 74)
const SKYLIGHT_RADIUS := 3.0
const MOUTH_Z := -8.0


static func sample(x: float, z: float) -> Dictionary:
	var best := {"d": INF, "y": ROCK_TOP, "h": 0.0, "roof": false}
	for room in ROOMS:
		var d := _rect_distance(Vector2(x, z), room.min, room.max)
		if d < best.d:
			best = {"d": d, "y": room.y, "h": room.h, "roof": room.roof}
	for path in PATHS:
		var hit := _path_distance(Vector2(x, z), path.points)
		var d: float = hit.d - path.width / 2.0
		if d < best.d:
			best = {"d": d, "y": hit.y, "h": path.h, "roof": true}
	return best


static func chao(x: float, z: float) -> float:
	var s := sample(x, z)
	if s.d <= 0.0:
		return s.y
	return lerpf(s.y, ROCK_TOP, smoothstep(0.0, WALL_BLEND, s.d))


static func teto(x: float, z: float) -> float:
	var s := sample(x, z)
	if not s.roof or (z < MOUTH_Z and s.y >= -0.5 and x > -13.0 and x < 13.0):
		return NAN
	if Vector2(x, z).distance_to(Vector2(SKYLIGHT.x, SKYLIGHT.z)) < SKYLIGHT_RADIUS:
		return NAN
	var open := 1.0 - smoothstep(-WALL_BLEND, 0.4, s.d)
	return s.y + s.h * open + 0.05


static func topo(x: float, z: float) -> float:
	var s := sample(x, z)
	if not s.roof and s.d <= 0.5:
		return NAN
	if Vector2(x, z).distance_to(Vector2(SKYLIGHT.x, SKYLIGHT.z)) < SKYLIGHT_RADIUS:
		return NAN
	return ROCK_TOP


static func _rect_distance(p: Vector2, lo: Vector2, hi: Vector2) -> float:
	var c := (lo + hi) / 2.0
	var half := (hi - lo) / 2.0
	var q := (p - c).abs() - half
	return Vector2(maxf(q.x, 0.0), maxf(q.y, 0.0)).length() + minf(maxf(q.x, q.y), 0.0)


static func _path_distance(p: Vector2, points: Array) -> Dictionary:
	var best_d := INF
	var best_y := 0.0
	for i in points.size() - 1:
		var a := Vector2(points[i].x, points[i].z)
		var b := Vector2(points[i + 1].x, points[i + 1].z)
		var t := clampf((p - a).dot(b - a) / (b - a).length_squared(), 0.0, 1.0)
		var d := p.distance_to(a.lerp(b, t))
		if d < best_d:
			best_d = d
			best_y = lerpf(points[i].y, points[i + 1].y, t)
	return {"d": best_d, "y": best_y}
