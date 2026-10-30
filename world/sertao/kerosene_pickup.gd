extends Area3D

@export var refill := 45.0


func _ready() -> void:
	var can := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.12
	mesh.bottom_radius = 0.12
	mesh.height = 0.32
	mesh.radial_segments = 10
	can.mesh = mesh
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.55, 0.12, 0.08)
	mat.metallic = 0.6
	mat.roughness = 0.5
	mat.emission_enabled = true
	mat.emission = Color(0.9, 0.5, 0.2)
	mat.emission_energy_multiplier = 0.25
	can.material_override = mat
	can.position.y = 0.16
	add_child(can)
	var shape := CollisionShape3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = 1.0
	shape.shape = sphere
	shape.position.y = 0.5
	add_child(shape)
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	rotate_y(delta * 0.8)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Pacto.refill_kerosene(refill)
		queue_free()
