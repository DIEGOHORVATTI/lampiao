extends OmniLight3D

var base_energy := 0.0


func _ready() -> void:
	base_energy = light_energy


func _process(_delta: float) -> void:
	var t := Time.get_ticks_msec() / 1000.0
	light_energy = base_energy * (0.85 + sin(t * 9.0) * 0.06 + randf() * 0.12)
