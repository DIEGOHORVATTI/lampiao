extends Node

const FLAME := Color(1.0, 0.6, 0.25)
const LANTERN_ENERGY := 2.2
const LANTERN_RANGE := 11.0

@export var auto_start := true

var lantern: OmniLight3D
var clarao: OmniLight3D
var lit := true


func _ready() -> void:
	await get_tree().process_frame
	var player: Node = Global.player
	if auto_start:
		Pacto.start_level()
	lantern = OmniLight3D.new()
	lantern.name = "Lampiao"
	lantern.light_color = FLAME
	lantern.light_energy = 2.2
	lantern.omni_range = 11.0
	lantern.omni_attenuation = 1.4
	lantern.position = Vector3(0.3, 0.15, 0.25)
	lantern.set_script(preload("res://world/sertao/flicker.gd"))
	player.camera.add_child(lantern)
	clarao = OmniLight3D.new()
	clarao.name = "Clarao"
	clarao.light_color = Color(1.0, 0.82, 0.55)
	clarao.light_energy = 0.0
	clarao.omni_range = 24.0
	clarao.omni_attenuation = 0.8
	clarao.position = Vector3(0.2, -0.1, -1.0)
	player.camera.add_child(clarao)
	Global.muzzle_flash.connect(_on_muzzle_flash)

	var hands := Environment.new()
	hands.background_mode = Environment.BG_CLEAR_COLOR
	hands.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	hands.ambient_light_color = FLAME.lerp(Color.WHITE, 0.45)
	hands.ambient_light_energy = 0.32
	hands.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	player.get_node("WeaponSubViewport/SubViewport/Camera3D").environment = hands


func _on_muzzle_flash() -> void:
	clarao.light_energy = 9.0
	var fade := create_tween()
	fade.tween_property(clarao, "light_energy", 0.0, 0.16).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func set_lit(value: bool) -> void:
	lit = value
	if lantern:
		lantern.visible = value


func _process(_delta: float) -> void:
	if lantern:
		lantern.visible = lit
		lantern.base_energy = LANTERN_ENERGY * Pacto.light_factor()
		lantern.omni_range = LANTERN_RANGE * lerpf(0.5, 1.0, Pacto.light_factor())


func _exit_tree() -> void:
	Pacto.stop()
