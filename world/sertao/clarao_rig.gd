extends Node

const FLASH := Color(1.0, 0.82, 0.55)
const HANDS_LIGHT := Color(1.0, 0.6, 0.25)

@export var auto_start := true

var clarao: OmniLight3D


func _ready() -> void:
	await get_tree().process_frame
	if auto_start:
		Pacto.start_level()
	var player: Node = Global.player
	clarao = OmniLight3D.new()
	clarao.name = "Clarao"
	clarao.light_color = FLASH
	clarao.light_energy = 0.0
	clarao.omni_range = 24.0
	clarao.omni_attenuation = 0.8
	clarao.position = Vector3(0.2, -0.1, -1.0)
	player.camera.add_child(clarao)
	Global.muzzle_flash.connect(_on_muzzle_flash)

	var hands := Environment.new()
	hands.background_mode = Environment.BG_CLEAR_COLOR
	hands.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	hands.ambient_light_color = HANDS_LIGHT.lerp(Color(0.5, 0.55, 0.75), 0.6)
	hands.ambient_light_energy = 0.3
	hands.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	player.get_node("WeaponSubViewport/SubViewport/Camera3D").environment = hands


func _on_muzzle_flash() -> void:
	clarao.light_energy = 9.0
	var fade := create_tween()
	fade.tween_property(clarao, "light_energy", 0.0, 0.16).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func _exit_tree() -> void:
	Pacto.stop()
