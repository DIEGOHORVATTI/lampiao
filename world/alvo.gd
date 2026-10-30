extends StaticBody3D

signal atingido

@export var tamanho := Vector3(0.7, 1.8, 0.7)


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = tamanho
	shape.shape = box
	shape.position.y = tamanho.y / 2.0
	add_child(shape)


func get_damage(_amount: float, _direction: Vector3) -> void:
	atingido.emit()
