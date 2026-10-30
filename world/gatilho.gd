extends Area3D

signal entrou

@export var tamanho := Vector3(6, 4, 6)


func _ready() -> void:
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = tamanho
	shape.shape = box
	shape.position.y = tamanho.y / 2.0
	add_child(shape)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		entrou.emit()
		set_deferred("monitoring", false)
