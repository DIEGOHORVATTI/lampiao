class_name Effects

const BLOOD := Color(0.04, 0.0, 0.0)
const GUNSHOT_SOUND := preload("res://resources/sfx/weapons/pistol.wav")
const BLOOD_SPLASH := preload("res://resources/textures/decal_bloodsplash_1.png")
const TRAIL_SPACING := 2.2


static func blood_jet(parent: Node3D, at: Vector3, seconds := 3.0) -> void:
	var blood := CPUParticles3D.new()
	blood.amount = 90
	blood.lifetime = 1.4
	blood.direction = Vector3.UP
	blood.spread = 18.0
	blood.initial_velocity_min = 3.0
	blood.initial_velocity_max = 5.5
	blood.gravity = Vector3(0, -9.8, 0)
	var drop := SphereMesh.new()
	drop.radius = 0.035
	drop.height = 0.07
	drop.material = _flat(BLOOD, 1.0)
	blood.mesh = drop
	parent.add_child(blood)
	blood.global_position = at
	parent.get_tree().create_timer(seconds).timeout.connect(func(): blood.emitting = false)
	parent.get_tree().create_timer(seconds + 2.0).timeout.connect(blood.queue_free)


static func blood_pool(parent: Node3D, at: Vector3, radius: float) -> void:
	var pool := MeshInstance3D.new()
	var disc := CylinderMesh.new()
	disc.top_radius = radius
	disc.bottom_radius = radius
	disc.height = 0.01
	pool.mesh = disc
	pool.material_override = _flat(Color(0.05, 0.0, 0.0), 0.1)
	parent.add_child(pool)
	pool.global_position = at
	pool.scale = Vector3(0.1, 1, 0.1)
	pool.create_tween().tween_property(pool, "scale", Vector3.ONE, 2.0)


static func blood_trail(parent: Node3D, points: Array) -> Node3D:
	var trail := Node3D.new()
	parent.add_child(trail)
	for i in points.size() - 1:
		var a: Vector3 = points[i]
		var b: Vector3 = points[i + 1]
		var steps := maxi(1, int(a.distance_to(b) / TRAIL_SPACING))
		for step in steps:
			var drop := Decal.new()
			drop.texture_albedo = BLOOD_SPLASH
			drop.modulate = Color(0.45, 0.02, 0.02)
			var size := randf_range(0.5, 0.9)
			drop.size = Vector3(size, 1.2, size)
			trail.add_child(drop)
			drop.global_position = a.lerp(b, float(step) / steps) + Vector3(randf_range(-0.3, 0.3), 0.3, randf_range(-0.3, 0.3))
			drop.rotation.y = randf() * TAU
	return trail


static func gunshot(parent: Node3D, from: Vector3) -> void:
	var flash := OmniLight3D.new()
	flash.light_color = Color(1.0, 0.75, 0.4)
	flash.light_energy = 7.0
	flash.omni_range = 14.0
	parent.add_child(flash)
	flash.global_position = from
	flash.create_tween().tween_property(flash, "light_energy", 0.0, 0.15)
	parent.get_tree().create_timer(0.3).timeout.connect(flash.queue_free)
	var sound := AudioStreamPlayer3D.new()
	sound.stream = GUNSHOT_SOUND
	parent.add_child(sound)
	sound.global_position = from
	sound.play()
	sound.finished.connect(sound.queue_free)


static func rockfall(parent: Node3D, base: Vector3, count: int) -> void:
	for i in count:
		var rock: Node3D = PropLibrary.build("rock", RandomNumberGenerator.new())
		parent.add_child(rock)
		rock.global_position = base + Vector3(randf_range(-1.5, 1.5), 3.5, randf_range(-1.0, 1.0))
		rock.create_tween().tween_property(rock, "global_position:y", base.y + randf_range(0.0, 0.8), 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).set_delay(i * 0.12)


static func _flat(color: Color, roughness: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	return material
