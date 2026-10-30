class_name Trigger
extends Area3D

signal entered

@export var size := Vector3(6, 4, 6)

var triggered := false


func _ready() -> void:
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position.y = size.y / 2.0
	add_child(shape)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		entered.emit()
		set_deferred("monitoring", false)
