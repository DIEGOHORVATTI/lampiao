class_name HitTarget
extends StaticBody3D

signal hit

@export var size := Vector3(0.7, 1.8, 0.7)


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position.y = size.y / 2.0
	add_child(shape)


func get_damage(_amount: float, _direction: Vector3) -> void:
	hit.emit()
