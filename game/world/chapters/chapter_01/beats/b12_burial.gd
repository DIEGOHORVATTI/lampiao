extends RefCounted

const GRAVES := 4
const DIG_SECONDS := 3.0


func run(d: Chapter01Director) -> void:
	d.beat = 12
	for key in d.cast:
		d.cast[key].queue_free()
	d.cast.clear()
	d.teleport_player("OathPoint", 0.0)
	d.face_player_to("Grave_1")
	_sunrise(d)
	await Dialogue.fade(0.0, 3.0)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_BURIAL_01"]])
	d.lock_player(false)
	d.objective("CH01_GOAL_BURIAL")
	var dug := [0]
	for i in GRAVES:
		var marker_name := "Grave_%d" % (i + 1)
		d.interactable(marker_name, "UI_DIG").used.connect(func():
			await Dialogue.hold("UI_DIG", DIG_SECONDS)
			_dig(d, marker_name)
			dug[0] += 1)
	await d.wait_until(func(): return dug[0] >= GRAVES, 900.0)
	d.lock_player(true)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_BURIAL_02"], ["SPEAKER_LAMPIAO", "CH01_BURIAL_03"]])
	d.lock_player(false)
	d.objective("CH01_GOAL_LEAVE")
	await Dialogue.hold("CH01_BURIAL_ROSARY", 1.5)
	Story.set_flag("rosary", "neck")
	await Dialogue.say([
		["SPEAKER_ELA", "CH01_BURIAL_04"],
		["SPEAKER_ELA", "CH01_BURIAL_05"],
		["SPEAKER_LAMPIAO", "CH01_BURIAL_06"],
	])
	d.objective("")
	var kepi := _kepi(d)
	await d.interactable("Kepi", "CH01_BURIAL_KEPI").used
	kepi.queue_free()
	d.lock_player(true)
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_BURIAL_07"],
		["SPEAKER_LAMPIAO", "CH01_BURIAL_08"],
		["SPEAKER_ELA", "CH01_BURIAL_09"],
	])
	await Dialogue.fade(1.0, 2.0)
	await Dialogue.show_card("CH01_END_CARD", 3.0)
	Story.chapter = 2
	Story.save_game()
	Dialogue.clear()
	Pact.stop()
	d.get_tree().change_scene_to_file("res://game/ui/menu.tscn")


func _sunrise(d: Chapter01Director) -> void:
	var sunrise := d.create_tween().set_parallel()
	sunrise.tween_property(d.environment, "background_color", Color(0.55, 0.42, 0.32), 12.0)
	sunrise.tween_property(d.environment, "ambient_light_energy", 1.1, 12.0)
	sunrise.tween_property(d.environment, "fog_light_color", Color(0.6, 0.45, 0.35), 12.0)


func _dig(d: Chapter01Director, marker_name: String) -> void:
	var grave: Node3D = PropLibrary.build("grave", RandomNumberGenerator.new())
	d.add_child(grave)
	grave.global_position = d.marker(marker_name)


func _kepi(d: Chapter01Director) -> Node3D:
	var cap := MeshInstance3D.new()
	var shape := CylinderMesh.new()
	shape.top_radius = 0.12
	shape.bottom_radius = 0.13
	shape.height = 0.09
	cap.mesh = shape
	cap.material_override = PropLibrary.material("leather")
	d.add_child(cap)
	cap.global_position = d.marker("Kepi") + Vector3.UP * 0.05
	return cap
