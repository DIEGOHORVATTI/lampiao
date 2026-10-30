extends RefCounted

const NEAR := 2.2


func run(d: Chapter01Director) -> void:
	d.beat = 5
	d.lock_player(true)
	await Dialogue.fade(1.0, 2.0)
	d.cast.vini.visible = false
	await _moon_with_eye(d)
	for key in ["maria", "triangles", "stars"]:
		d.cast[key].lie_down()
	d.teleport_player("LampiaoMat", 180.0)
	d.face_player_to("Maria")
	Dialogue.fade(0.0, 0.8)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_POISON_01"]])
	d.lock_player(false)
	d.objective("CH01_GOAL_BAND")
	await d.wait_until(func(): return _near(d.cast.maria), 120.0)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_POISON_02"], ["SPEAKER_LAMPIAO", "CH01_POISON_03"]])
	await d.wait_until(func(): return _near(d.cast.triangles) or _near(d.cast.stars), 120.0)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_POISON_04"]])
	d.objective("")
	d.lock_player(true)
	d.cast.vini.visible = true
	d.cast.vini.global_position = d.marker("Vini")
	await d.cast.vini.walk_to(Global.player.global_position + Global.player.global_position.direction_to(d.marker("Vini")) * 1.6, 1.8, true)
	d.cast.vini.look_at_point(Global.player.global_position, 0.1)
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_POISON_05"],
		["SPEAKER_VINI", "CH01_POISON_06"],
		["SPEAKER_VINI", "CH01_POISON_07"],
		["SPEAKER_LAMPIAO", "CH01_POISON_08"],
		["SPEAKER_VINI", "CH01_POISON_09"],
	])
	Scares.shake(0.04, 2.5)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_POISON_10"], ["SPEAKER_LAMPIAO", "CH01_POISON_11"]])
	await _colonel_arrives(d)


func _moon_with_eye(d: Chapter01Director) -> void:
	Scares.face_rect.texture = load(Scares.FACES["moon"])
	Scares.face_rect.modulate.a = 0.0
	Scares.face_rect.scale = Vector2.ONE
	Scares.face_rect.visible = true
	await d.create_tween().tween_property(Scares.face_rect, "modulate:a", 1.0, 2.0).finished
	await d.create_tween().tween_property(Scares.face_rect, "scale", Vector2.ONE * 1.25, 4.0).finished
	Scares.face_rect.visible = false
	Scares.shake(0.2, 0.4)


func _colonel_arrives(d: Chapter01Director) -> void:
	await Dialogue.fade(1.0, 0.4)
	d.teleport_player("Vini", 180.0)
	d.face_player_to("ColonelAtMouth")
	d.cast.vini.global_position = d.marker("Vini") + Vector3(1.2, 0, 0.5)
	d.colonel = d.spawn_npc("ColonelAtMouth", d.SUIT, "kepi", false)
	d.colonel.look_at_point(d.marker("Vini"), 0.01)
	d.cast.mouth_soldiers = []
	for i in 3:
		var soldier := d.spawn_volante("MouthSoldier_%d" % (i + 1))
		soldier.look_at_point(d.marker("Vini"), 0.01)
		d.cast.mouth_soldiers.append(soldier)
	await Dialogue.fade(0.0, 0.4)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_COLONEL_01"]])
	for i in 3:
		Effects.gunshot(d, d.colonel.global_position + Vector3.UP * 1.4)
		await d.get_tree().create_timer(0.3).timeout
	await Dialogue.say([["SPEAKER_CORONEL", "CH01_COLONEL_02"], ["SPEAKER_LAMPIAO", "CH01_COLONEL_03"]])


func _near(npc: Node3D) -> bool:
	return Global.player.global_position.distance_to(npc.global_position) < NEAR
