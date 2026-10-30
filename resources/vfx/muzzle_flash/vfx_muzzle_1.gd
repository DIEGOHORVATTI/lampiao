extends Node3D

const LINGER := 1.6

@export var flash_duration := 0.075
@export var light_energy := 2.2

@onready var burst: MeshInstance3D = $Burst
@onready var light: OmniLight3D = $OmniLight3D
@onready var smoke: GPUParticles3D = $Smoke
@onready var sparks: GPUParticles3D = $Sparks


func _ready() -> void:
	_face_camera()
	smoke.restart()
	sparks.restart()
	_animate()
	get_tree().create_timer(LINGER).timeout.connect(queue_free)


func _face_camera() -> void:
	var camera := get_viewport().get_camera_3d()
	if camera:
		burst.look_at(camera.global_position, camera.global_basis.y)
	burst.rotate_object_local(Vector3.BACK, randf() * TAU)


func _animate() -> void:
	var grown := burst.scale
	burst.scale = grown * 0.45
	light.light_energy = light_energy
	var pop := create_tween().set_parallel()
	pop.tween_property(burst, "scale", grown * randf_range(0.95, 1.15), flash_duration * 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	pop.tween_property(burst, "transparency", 1.0, flash_duration * 0.5).set_delay(flash_duration * 0.5)
	pop.tween_property(light, "light_energy", 0.0, flash_duration * 1.6).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	pop.chain().tween_callback(burst.hide)
