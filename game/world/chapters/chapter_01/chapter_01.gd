class_name Chapter01Director
extends ChapterDirector

const SUIT := Color(0.12, 0.12, 0.16)
const UNIFORM := Color(0.6, 0.53, 0.38)
const LEATHER := Color(0.42, 0.3, 0.18)
const MARIA_DRESS := Color(0.35, 0.27, 0.2)
const VINI_SHIRT := Color(0.5, 0.48, 0.4)
const BENEDITO_TIMEOUT := 30.0
const POISONED_SPEED := 2.2
const NORMAL_SPEED := 5.0
const TORCH_SECONDS := 90.0
const FLAME := Color(1.0, 0.6, 0.25)
const FLICKER := preload("res://game/world/components/flicker.gd")
const BEATS := [
	preload("res://game/world/chapters/chapter_01/beats/b01_raid.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b02_escape.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b03_camp.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b04_poison.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b05_gallery.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b06_betrayal.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b07_beheading.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b08_entity_mode.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b09_awakening.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b10_crevice.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b11_benedito.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b12_maria.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b13_burial.gd"),
]

var shots := 0
var poisoned := false
var vini_hits := 0
var ate_carrion := false
var torch_light: OmniLight3D
var colonel: Node3D


func run_chapter() -> void:
	lock_player(true)
	Pact.start_level(0.0)
	Pact.hunger_enabled = false
	Pact.active = false
	Dialogue.fade(1.0, 0.0)
	await Dialogue.show_card("CH01_OPENING_CARD", 6.0)
	await run_beats(BEATS)


func on_player_shot() -> void:
	shots += 1
	if shots == 3 and beat == 1:
		Dialogue.say([["SPEAKER_SOLDADO", "CH01_RAID_SHOT_01"], ["SPEAKER_MARIA", "CH01_RAID_SHOT_02"]])


func set_poisoned(on: bool) -> void:
	poisoned = on
	Global.player.walk_speed = POISONED_SPEED if on else NORMAL_SPEED
	if on:
		_stagger()


func set_vini_torch(on: bool) -> void:
	if torch_light:
		torch_light.queue_free()
	if on:
		torch_light = _flame_light(2.4, 5.0)
		torch_light.position = Vector3(0.3, 2.0, 0.2)
		cast.vini.add_child(torch_light)


func pick_up_torch() -> void:
	var light := _flame_light(2.2, 5.0)
	light.position = Vector3(-0.4, -0.2, -0.3)
	Global.player.camera.add_child(light)
	await get_tree().create_timer(TORCH_SECONDS).timeout
	if is_instance_valid(light):
		light.queue_free()


func spawn_soldier_remains() -> void:
	for i in 4:
		var marker_name := "Remains_%d" % (i + 1)
		var remains: Node3D = PropLibrary.build("corpse", RandomNumberGenerator.new())
		add_child(remains)
		remains.global_position = marker(marker_name)
		Effects.blood_pool(self, marker(marker_name) + Vector3.UP * 0.02, 1.0)
		interactable(marker_name, "UI_EAT").used.connect(_eat_remains.bind(remains))


func light_totem(totem: Node3D) -> void:
	var glow := StandardMaterial3D.new()
	glow.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	glow.albedo_color = Color(2.5, 2.5, 2.4)
	glow.disable_fog = true
	var eyes := totem.find_child("Eyes", true, false)
	if eyes:
		for mesh in eyes.find_children("*", "MeshInstance3D", true, false):
			mesh.material_override = glow


func gallop_camera() -> void:
	var t := 0.0
	while beat == 2:
		t += get_process_delta_time()
		Global.player.camera.v_offset = sin(t * 11.0) * 0.06
		Global.player.camera.h_offset = sin(t * 5.5) * 0.03
		await get_tree().process_frame
	Global.player.camera.v_offset = 0.0
	Global.player.camera.h_offset = 0.0


func _eat_remains(remains: Node3D) -> void:
	Pact.eat()
	Pact.hit_flash = 0.8
	Scares.shake(0.1, 0.7)
	remains.queue_free()
	if not ate_carrion:
		ate_carrion = true
		Dialogue.say([["SPEAKER_ELA", "CH01_CREVICE_EAT_01"], ["SPEAKER_LAMPIAO", "CH01_CREVICE_EAT_02"], ["SPEAKER_ELA", "CH01_CREVICE_EAT_03"]])


func _stagger() -> void:
	while poisoned:
		Global.player.look(Vector2(randf_range(-0.004, 0.004), randf_range(-0.003, 0.003)))
		await get_tree().process_frame


func _flame_light(energy: float, light_range: float) -> OmniLight3D:
	var light := OmniLight3D.new()
	light.light_color = FLAME
	light.light_energy = energy
	light.omni_range = light_range
	light.set_script(FLICKER)
	return light
