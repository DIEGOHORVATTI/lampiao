extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 1
	var lampiao := d.spawn_character(d.LAMPIAO, d.marker("LampiaoRaid"))
	d.cast.lampiao = lampiao
	d.cast.triangles = d.spawn_npc("Triangles", d.LEATHER, "half_moon")
	d.cast.triangles.pose("Crouch_Idle")
	d.cast.stars = d.spawn_npc("Stars", d.LEATHER.darkened(0.2), "half_moon")
	d.cast.drawings = d.spawn_npc("Drawings", d.LEATHER.darkened(0.35), "half_moon")
	d.cast.maria = d.spawn_maria("MariaFarm")
	var guard := d.spawn_npc("Guard", d.SHIRT, "none")
	guard.look_at_point(lampiao.global_position, 0.01)
	await lampiao.look_at_point(d.marker("Guard"), 0.01)
	lampiao.pose("Pistol_Aim_Neutral", 0.0)
	await _shot(d, lampiao, guard)
	await _unarmed_soldier(d, lampiao)
	await _run_to_back_door(d)


func _shot(d: Chapter01Director, lampiao: Node3D, guard: Node3D) -> void:
	var at := lampiao.global_position
	d.cut(at + Vector3(2.2, 0.5, -1.4), at + Vector3.UP * 1.4)
	await Dialogue.fade(0.0, 0.3)
	await d.get_tree().create_timer(0.6).timeout
	Effects.gunshot(d, at + Vector3(0.8, 1.4, 0))
	Global.muzzle_flash.emit()
	Scares.shake(0.08, 0.2)
	await d.get_tree().create_timer(0.5).timeout
	d.cut(d.marker("RoomDoor") + Vector3(-1.0, 1.6, 0.4), guard.global_position + Vector3.UP * 1.2)
	guard.die()
	Effects.blood_jet(d, guard.global_position + Vector3.UP * 1.5, 0.8)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_RAID_01"]])


func _unarmed_soldier(d: Chapter01Director, lampiao: Node3D) -> void:
	var soldier := d.spawn_volante("SoldierDoor", false)
	var drawings: Node3D = d.cast.drawings
	d.cut(drawings.global_position + Vector3(-0.5, 1.75, 1.6), d.marker("SoldierHandsUp") + Vector3.UP * 1.3)
	await soldier.walk_path(_from_front_to_corridor(d), 1.4)
	soldier.look_at_point(drawings.global_position, 0.2)
	await drawings.look_at_point(soldier.global_position, 0.2)
	drawings.pose("Pistol_Aim_Neutral")
	await Dialogue.say([["SPEAKER_CANGACEIRO", "CH01_RAID_02"]])
	lampiao.walk_path([d.marker("RoomDoor") + Vector3(-0.6, 0, 0), d.marker("RoomDoor") + Vector3(1.2, 0, 0), drawings.global_position + Vector3(0.2, 0, -2.2)], 2.0, true)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_RAID_03"]])
	Effects.gunshot(d, drawings.global_position + Vector3.UP * 1.3)
	var face := lampiao.global_position + Vector3.UP * 1.6
	d.cut(face + lampiao.model.global_basis.z * 1.1, face)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_RAID_04"]])
	drawings.pose("Idle")
	soldier.walk_path(_from_corridor_to_front(d), 2.0, true)
	d.get_tree().create_timer(2.5).timeout.connect(soldier.queue_free)


func _from_front_to_corridor(d: Chapter01Director) -> Array:
	var side_door := d.marker("SoldierHandsUp") + Vector3(1.0, 0, -1.0)
	return [d.marker("SoldierDoor") + Vector3(0, 0, 2.5), side_door + Vector3(2.0, 0, 0), side_door, d.marker("SoldierHandsUp")]


func _from_corridor_to_front(d: Chapter01Director) -> Array:
	var route := _from_front_to_corridor(d)
	route.reverse()
	route.append(d.marker("SoldierDoor"))
	return route.slice(1)


func _run_to_back_door(d: Chapter01Director) -> void:
	var door := d.marker("BackDoor")
	d.cut(door + Vector3(0.6, 1.4, 1.5), door + Vector3(0, 1.2, -10))
	for key in ["triangles", "stars", "drawings", "maria", "lampiao"]:
		var npc: Node3D = d.cast[key]
		var route: Array = [Vector3(0, npc.global_position.y, npc.global_position.z)]
		if npc.global_position.x < d.marker("RoomDoor").x:
			route = [d.marker("RoomDoor") + Vector3(-0.6, 0, 0), d.marker("RoomDoor") + Vector3(1.2, 0, 0)]
		route.append(door + Vector3(randf_range(-0.6, 0.6), 0, randf_range(0.5, 2.5)))
		npc.walk_path(route, 2.0, true)
	await Dialogue.say([["", "CH01_RAID_05"]])
	await d.get_tree().create_timer(1.5).timeout
