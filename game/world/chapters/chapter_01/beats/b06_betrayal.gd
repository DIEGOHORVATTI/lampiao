extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 6
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_BETRAYAL_01"]])
	d.cast.vini.global_position = d.marker("ViniDuel")
	d.cast.vini.look_at_point(Global.player.global_position, 0.1)
	d.cast.vini.pose("Pistol_Aim_Neutral")
	await Dialogue.say([
		["SPEAKER_VINI", "CH01_BETRAYAL_02"],
		["SPEAKER_LAMPIAO", "CH01_BETRAYAL_03"],
		["SPEAKER_VINI", "CH01_BETRAYAL_04"],
		["SPEAKER_LAMPIAO", "CH01_BETRAYAL_05"],
		["SPEAKER_VINI", "CH01_BETRAYAL_06"],
	])
	Global.player.weapons_manager.switch_weapon(0)
	Dialogue.show_prompt("CH01_BETRAYAL_07")
	var target := d.attach_hit_target(d.cast.vini)
	target.hit.connect(func(): d.vini_hits += 1)
	_vini_attacks(d)
	await d.wait_until(func(): return d.vini_hits >= 2, 180.0)
	Dialogue.hide_prompt()
	d.cast.vini.pose("Crouch_Idle")
	await Dialogue.say([["", "CH01_BETRAYAL_08"]])


func _vini_attacks(d: Chapter01Director) -> void:
	while d.vini_hits < 2 and d.beat == 6:
		await d.get_tree().create_timer(2.2).timeout
		if d.beat != 6 or d.vini_hits >= 2:
			return
		var attack_from: Vector3 = Global.player.global_position + Global.player.global_position.direction_to(d.cast.vini.global_position) * 1.2
		await d.cast.vini.walk_to(attack_from, 2.2, true)
		d.cast.vini.pose("Punch_Cross")
		if d.cast.vini.global_position.distance_to(Global.player.global_position) < 1.8:
			Global.player.get_damage(15.0, d.cast.vini.global_position.direction_to(Global.player.global_position), true)
