class_name Chapter01Director
extends ChapterDirector

const SUIT := Color(0.12, 0.12, 0.16)
const LEATHER := Color(0.42, 0.3, 0.18)
const SHIRT := Color(0.85, 0.83, 0.78)
const VINI_SHIRT := Color(0.5, 0.48, 0.4)
const LAMPIAO := preload("res://resources/characters/lampiao/lampiao.tscn")
const MARIA := preload("res://resources/characters/maria/maria.tscn")
const VOLANTE := preload("res://resources/characters/volante/volante.tscn")
const LANTERN_LIGHT := Color(1.0, 0.72, 0.4)
const FLICKER := preload("res://game/world/components/flicker.gd")
const BEATS := [
	preload("res://game/world/chapters/chapter_01/beats/b00_opening.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b01_raid.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b02_street.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b03_ride.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b04_camp.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b05_poison.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b06_tunnel.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b07_idol_hall.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b08_beheading.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b09_entity.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b10_rosary.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b11_return.gd"),
	preload("res://game/world/chapters/chapter_01/beats/b12_burial.gd"),
]

var vini_hits := 0
var galloping := false
var night_fog_density: float
var night_fog_color: Color
var lantern: OmniLight3D
var colonel: Node3D


func run_chapter() -> void:
	night_fog_density = environment.fog_density
	night_fog_color = environment.fog_light_color
	lock_player(true)
	Pact.start_level(0.0)
	Pact.hunger_enabled = false
	Pact.active = false
	Dialogue.fade(1.0, 0.0)
	await run_beats(BEATS)


func spawn_character(scene: PackedScene, at: Vector3, armed := true) -> Node3D:
	var npc := NPC.new()
	npc.character = scene
	npc.carries_rifle = armed
	add_child(npc)
	npc.global_position = at
	return npc


func spawn_maria(marker_name: String) -> Node3D:
	return spawn_character(MARIA, marker(marker_name), false)


func spawn_volante(marker_name: String, armed := true) -> Node3D:
	return spawn_character(VOLANTE, marker(marker_name), armed)


func carry_lantern() -> void:
	lantern = OmniLight3D.new()
	lantern.light_color = LANTERN_LIGHT
	lantern.light_energy = 1.8
	lantern.omni_range = 7.0
	lantern.shadow_enabled = true
	lantern.position = Vector3(0.35, -0.35, -0.4)
	lantern.set_script(FLICKER)
	Global.player.camera.add_child(lantern)


func drop_lantern() -> void:
	var at := Global.player.global_position + Vector3.UP * 0.25
	lantern.reparent(self)
	lantern.global_position = at
	lantern.light_energy = 1.2


func set_glasses(on: bool) -> void:
	var attributes := CameraAttributesPractical.new()
	attributes.dof_blur_far_enabled = not on
	attributes.dof_blur_far_distance = 2.5
	attributes.dof_blur_far_transition = 3.0
	attributes.dof_blur_near_enabled = false
	attributes.dof_blur_amount = 0.12
	Global.player.camera.attributes = null if on else attributes


func restore_night() -> void:
	environment.fog_density = night_fog_density
	environment.fog_light_color = night_fog_color
	environment.adjustment_enabled = false


func gallop_camera() -> void:
	galloping = true
	var t := 0.0
	while galloping and is_instance_valid(cinematic_camera):
		t += get_process_delta_time()
		cinematic_camera.v_offset = sin(t * 11.0) * 0.06
		cinematic_camera.h_offset = sin(t * 5.5) * 0.03
		await get_tree().process_frame

