const SIZE := Vector2(88, 210)
const CENTER := Vector3(0, 0, 65)
const ROCK := 4.0
const FLOOR := -12.0
const TRAIL_HALF_WIDTH := 3.5
const DESCIDA := [Vector3(36, 0, 20), Vector3(28, -3, 32), Vector3(18, -7, 44), Vector3(8, -12, 58)]
const SUBIDA := [Vector3(0, -12, 128), Vector3(6, -6, 145), Vector3(12, -1, 158), Vector3(14, 0, 166)]


static func altura(x: float, z: float) -> float:
	var h := 0.0
	if z >= 52.0 and z <= 150.0:
		h = ROCK
	if absf(x) <= 14.0 and z >= 56.0 and z <= 130.0:
		h = FLOOR
	if x >= -21.0 and x <= -13.0 and z >= 114.0 and z <= 120.0:
		h = FLOOR
	h = minf(h, _trail(x, z, DESCIDA))
	h = minf(h, _trail(x, z, SUBIDA))
	return h


static func _trail(x: float, z: float, points: Array) -> float:
	var p := Vector2(x, z)
	var best := INF
	var best_distance := INF
	for i in points.size() - 1:
		var a := Vector2(points[i].x, points[i].z)
		var b := Vector2(points[i + 1].x, points[i + 1].z)
		var t := clampf((p - a).dot(b - a) / (b - a).length_squared(), 0.0, 1.0)
		var d := p.distance_to(a.lerp(b, t))
		if d < best_distance:
			best_distance = d
			best = lerpf(points[i].y, points[i + 1].y, t)
	return best if best_distance <= TRAIL_HALF_WIDTH else INF
