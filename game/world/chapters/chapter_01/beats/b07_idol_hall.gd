extends RefCounted

const VINI_DAMAGE := 12.0
const HITS_TO_END := 3
const ATTACK_INTERVAL := 2.0

var vini_blows := 0


func run(d: Chapter01Director) -> void:
	d.beat = 7
	d.lock_player(false)
	d.objective("CH01_GOAL_HALL", ["Tunnel_5", "ViniHall", "HallView"])
	d.cast.vini.walk_to(d.marker("ViniHall"), 1.4)
	await d.await_trigger("HallTrigger")
	await Dialogue.say([["SPEAKER_VINI", "CH01_HALL_01"]])
	await d.wait_until(func(): return Global.player.global_position.distance_to(d.marker("HallView")) < 2.5, 8.0)
	d.objective("")
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_HALL_02"]])
	d.lock_player(true)
	d.teleport_player("LampiaoDuel", 0.0)
	d.cast.vini.global_position = d.marker("ViniDuel")
	d.cast.vini.look_at_point(Global.player.global_position, 0.05)
	d.face_player_to("ViniDuel")
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_HALL_03"]])
	d.cast.vini.pose("Pistol_Aim_Neutral")
	await d.get_tree().create_timer(0.8).timeout
	await Dialogue.say([
		["SPEAKER_VINI", "CH01_HALL_04"],
		["SPEAKER_VINI", "CH01_HALL_05"],
		["SPEAKER_VINI", "CH01_HALL_06"],
	])
	d.drop_lantern()
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_HALL_07"]])
	Effects.gunshot(d, d.cast.vini.global_position + Vector3.UP * 1.4)
	Scares.shake(0.12, 0.25)
	await _fight(d)


func _fight(d: Chapter01Director) -> void:
	Global.player.weapons_manager.switch_weapon(0)
	var god := d.start_god_mode()
	d.objective("CH01_GOAL_FIGHT")
	d.vini_hits = 0
	d.attach_hit_target(d.cast.vini).hit.connect(func(): d.vini_hits += 1)
	d.lock_player(false)
	Dialogue.say([["SPEAKER_VINI", "CH01_FIGHT_01"]])
	_vini_attacks(d)
	await d.wait_until(func(): return d.vini_hits >= HITS_TO_END, 120.0)
	d.objective("")
	d.lock_player(true)
	god.queue_free()


func _vini_attacks(d: Chapter01Director) -> void:
	var vini: Node3D = d.cast.vini
	while d.vini_hits < HITS_TO_END and d.beat == 7:
		await d.get_tree().create_timer(ATTACK_INTERVAL).timeout
		if d.vini_hits >= HITS_TO_END:
			return
		var player_at: Vector3 = Global.player.global_position
		await vini.walk_to(player_at + player_at.direction_to(vini.global_position) * 1.2, 2.2, true)
		vini.pose("Punch_Cross")
		if vini.global_position.distance_to(Global.player.global_position) < 1.8:
			Global.player.get_damage(VINI_DAMAGE, vini.global_position.direction_to(Global.player.global_position), true)
			vini_blows += 1
			if vini_blows == 2:
				d.set_glasses(false)
				Scares.shake(0.2, 0.4)
