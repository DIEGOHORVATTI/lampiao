extends RefCounted

const VOLLEY_SHOTS := 5


func run(d: Chapter01Director) -> void:
	d.beat = 2
	var door := d.marker("BackDoor")
	var soldier := d.spawn_volante("FarmSoldier_5")
	soldier.global_position = door + Vector3(7, 0, 3)
	soldier.look_at_point(door, 0.01)
	soldier.pose("Pistol_Aim_Neutral")
	var face := soldier.global_position + Vector3.UP * 1.6
	d.cut(face + soldier.model.global_basis.z * 1.3 + Vector3(0.3, 0, 0), face)
	await Dialogue.say([["SPEAKER_SOLDADO", "CH01_STREET_01"]])
	d.cut(face + soldier.model.global_basis.z * 0.45, face - Vector3.UP * 0.1)
	await Dialogue.say([["", "CH01_STREET_02"]])
	await _maria_shot(d, soldier)
	await _street(d)
	soldier.queue_free()


func _maria_shot(d: Chapter01Director, soldier: Node3D) -> void:
	var lampiao: Node3D = d.cast.lampiao
	var maria: Node3D = d.cast.maria
	var spot := d.marker("BackDoor") + Vector3(0, 0, 2)
	lampiao.global_position = spot
	lampiao.pose("Idle", 0.0)
	maria.global_position = spot + Vector3(0.9, 0, 0.3)
	maria.look_at_point(soldier.global_position, 0.01)
	d.cut(spot + Vector3(-2.6, 1.4, 1.2), spot + Vector3(0.5, 1.2, 0))
	await Dialogue.say([["SPEAKER_MARIA", "CH01_STREET_03"]])
	for i in VOLLEY_SHOTS:
		Effects.gunshot(d, soldier.global_position + Vector3.UP * 1.4)
		await d.get_tree().create_timer(0.09).timeout
	Effects.blood_jet(d, maria.global_position + Vector3.UP * 1.1, 0.6)
	maria.pose("Crouch_Idle")
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_STREET_04"]])
	await lampiao.look_at_point(maria.global_position, 0.2)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_STREET_05"], ["SPEAKER_MARIA", "CH01_STREET_06"]])


func _street(d: Chapter01Director) -> void:
	var goal := d.marker("StreetMiddle")
	d.cut(goal + Vector3(-1.5, 0.5, 6), goal + Vector3(0, 1.8, -8))
	var start := d.marker("BackDoor") + Vector3(0, 0, 3)
	for key in d.cast:
		d.cast[key].global_position = start + Vector3(randf_range(-1.5, 1.5), 0, randf_range(0, 2))
	d.cast.triangles.walk_to(goal + Vector3(0, 0, 4), 1.8, true)
	d.cast.lampiao.walk_to(goal + Vector3(-0.5, 0, 2), 1.1)
	d.cast.maria.walk_to(goal + Vector3(0.4, 0, 2), 1.1)
	for key in ["stars", "drawings"]:
		d.cast[key].walk_to(goal + Vector3(randf_range(-2, 2), 0, 3), 1.6, true)
	await Dialogue.say([["SPEAKER_CANGACEIRO", "CH01_STREET_07"], ["SPEAKER_LAMPIAO", "CH01_STREET_08"]])
	await d.get_tree().create_timer(1.0).timeout
	var maria: Node3D = d.cast.maria
	var face := maria.global_position + Vector3.UP * 1.55
	d.cut(face + maria.model.global_basis.z * 0.9, face)
	await Dialogue.say([["SPEAKER_MARIA", "CH01_STREET_09"]])
