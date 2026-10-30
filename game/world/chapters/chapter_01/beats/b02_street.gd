extends RefCounted

const VOLLEY_SHOTS := 5


func run(d: Chapter01Director) -> void:
	d.beat = 2
	d.objective("CH01_GOAL_STREET", ["BackDoor", "StreetMiddle", "ViniFarm"])
	for i in 4:
		var soldier := d.spawn_soldier("FarmSoldier_%d" % (i + 4), 0.18, 1.2)
		soldier.alert(Global.player.global_position, 1.0)
	await Dialogue.say([["SPEAKER_SOLDADO", "CH01_STREET_01"], ["", "CH01_STREET_02"]])
	await d.await_trigger("MariaShotTrigger")
	await _maria_shot(d)
	Global.player.walk_speed = d.CARRY_SPEED
	d.cast.maria.walk_to(d.marker("ViniFarm"), 1.1)
	for key in ["triangles", "stars", "drawings"]:
		d.cast[key].walk_to(d.marker("ViniFarm") + Vector3(randf_range(-2, 2), 0, randf_range(-1, 1)), 1.6, true)
	await d.await_trigger("StreetTrigger")
	await Dialogue.say([["SPEAKER_CANGACEIRO", "CH01_STREET_07"], ["SPEAKER_LAMPIAO", "CH01_STREET_08"]])
	await d.await_trigger("HorsesTrigger")
	d.lock_player(true)
	d.cast.maria.global_position = Global.player.global_position + Global.player.camera.global_basis.z * -1.2
	d.cast.maria.look_at_point(Global.player.global_position, 0.1)
	await Dialogue.say([["SPEAKER_MARIA", "CH01_STREET_09"]])
	Global.player.walk_speed = d.WALK_SPEED
	d.objective("")


func _maria_shot(d: Chapter01Director) -> void:
	d.lock_player(true)
	var maria: Node3D = d.cast.maria
	maria.global_position = Global.player.global_position + Global.player.camera.global_basis.z * -1.0
	maria.look_at_point(Global.player.global_position, 0.05)
	await Dialogue.say([["SPEAKER_MARIA", "CH01_STREET_03"]])
	var shooter: Node3D = d.soldiers.filter(func(s): return is_instance_valid(s)).front()
	for i in VOLLEY_SHOTS:
		Effects.gunshot(d, shooter.global_position + Vector3.UP * 1.4)
		await d.get_tree().create_timer(0.09).timeout
	Effects.blood_jet(d, maria.global_position + Vector3.UP * 1.1, 0.6)
	maria.pose("Crouch_Idle")
	GameUI.hit_flash = 0.6
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_STREET_04"],
		["SPEAKER_LAMPIAO", "CH01_STREET_05"],
		["SPEAKER_MARIA", "CH01_STREET_06"],
	])
	d.lock_player(false)
