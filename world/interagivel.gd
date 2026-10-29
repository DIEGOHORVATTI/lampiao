extends Area3D

signal usado

@export var texto := "Usar"
@export var raio := 2.0
@export var uma_vez := true

var player_inside := false


func _ready() -> void:
	var shape := CollisionShape3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = raio
	shape.shape = sphere
	add_child(shape)
	body_entered.connect(func(body): if body.is_in_group("player"): _set_inside(true))
	body_exited.connect(func(body): if body.is_in_group("player"): _set_inside(false))
	Global.activate_pressed.connect(_on_activate)


func _set_inside(inside: bool) -> void:
	player_inside = inside
	if inside:
		Dialogo.mostrar_prompt("✋ " + texto)
	else:
		Dialogo.esconder_prompt()


func _on_activate() -> void:
	if not player_inside or Dialogo.talking:
		return
	Dialogo.esconder_prompt()
	usado.emit()
	if uma_vez:
		Global.activate_pressed.disconnect(_on_activate)
		queue_free()
