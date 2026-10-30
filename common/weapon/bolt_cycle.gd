extends Node3D

@export var delay: float = 0.24
@export var lift_degrees: float = 70.0
@export var travel: float = 0.075

@onready var click: AudioStreamPlayer3D = $Click

var rest_z: float
var tween: Tween


func _ready() -> void:
	rest_z = position.z
	owner.fired.connect(_cycle)


func _cycle() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_interval(delay)
	tween.tween_callback(click.play)
	tween.tween_property(self, "rotation_degrees:z", lift_degrees, 0.07)
	tween.tween_property(self, "position:z", rest_z + travel, 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:z", rest_z, 0.09).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation_degrees:z", 0.0, 0.07)
	tween.tween_callback(click.play)
