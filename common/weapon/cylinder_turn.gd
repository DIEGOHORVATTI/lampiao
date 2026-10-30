extends Node3D

const STEP := TAU / 6.0


func _ready() -> void:
	owner.fired.connect(_turn)


func _turn() -> void:
	create_tween().tween_property(self, "rotation:z", fposmod(rotation.z, TAU) + STEP, 0.09)
