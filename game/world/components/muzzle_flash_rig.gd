extends Node

const FLASH := Color(1.0, 0.82, 0.55)
const HANDS_LIGHT := Color(1.0, 0.6, 0.25)
const VIEWMODEL_LAYER := 2

@export var auto_start := true

var flash: OmniLight3D


func _ready() -> void:
	await get_tree().process_frame
	if auto_start:
		Pact.start_level()
	var player: Node = Global.player
	flash = OmniLight3D.new()
	flash.name = "Clarao"
	flash.light_color = FLASH
	flash.light_energy = 0.0
	flash.omni_range = 24.0
	flash.omni_attenuation = 0.8
	flash.position = Vector3(0.2, -0.1, -1.0)
	flash.light_cull_mask = 0xFFFFF & ~VIEWMODEL_LAYER
	player.camera.add_child(flash)
	Global.muzzle_flash.connect(_on_muzzle_flash)

	var hands := Environment.new()
	hands.background_mode = Environment.BG_CLEAR_COLOR
	hands.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	hands.ambient_light_color = HANDS_LIGHT.lerp(Color(0.5, 0.55, 0.75), 0.6)
	hands.ambient_light_energy = 0.3
	hands.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	player.get_node("WeaponSubViewport/SubViewport/Camera3D").environment = hands


func _on_muzzle_flash() -> void:
	flash.light_energy = 9.0
	var fade := create_tween()
	fade.tween_property(flash, "light_energy", 0.0, 0.16).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func _exit_tree() -> void:
	Pact.stop()
