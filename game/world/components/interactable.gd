class_name Interactable
extends Area3D

signal used

@export var label := "Usar"
@export var radius := 2.0
@export var once := true

var player_inside := false


func _ready() -> void:
	var shape := CollisionShape3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = radius
	shape.shape = sphere
	add_child(shape)
	body_entered.connect(func(body): if body.is_in_group("player"): _set_inside(true))
	body_exited.connect(func(body): if body.is_in_group("player"): _set_inside(false))
	Global.activate_pressed.connect(_on_activate)


func _set_inside(inside: bool) -> void:
	player_inside = inside
	if inside:
		Dialogue.show_prompt(tr("UI_USE") % tr(label))
	else:
		Dialogue.hide_prompt()


func _on_activate() -> void:
	if not player_inside:
		return
	Dialogue.hide_prompt()
	used.emit()
	if once:
		Global.activate_pressed.disconnect(_on_activate)
		queue_free()
