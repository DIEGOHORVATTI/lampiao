extends RefCounted

const MOUTH_FIRE_UNTIL_Z := 14.0
const FOLLOW_DISTANCE := 2.5

var following := true


func run(d: Chapter01Director) -> void:
	d.beat = 6
	d.carry_lantern()
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_TUNNEL_01"]])
	d.lock_player(false)
	d.objective("CH01_GOAL_TUNNEL", ["Campfire", "Tunnel_1", "Tunnel_2", "Tunnel_3", "Tunnel_4", "Tunnel_5"])
	_vini_follows(d)
	_mouth_fire(d)
	await d.wait_until(func(): return Global.player.global_position.z > MOUTH_FIRE_UNTIL_Z, 120.0)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_TUNNEL_02"]])
	d.colonel.queue_free()
	for soldier in d.cast.mouth_soldiers:
		soldier.queue_free()
	d.cast.erase("mouth_soldiers")
	await d.wait_until(func(): return Global.player.global_position.z > d.marker("Tunnel_3").z, 120.0)
	await Dialogue.say([["SPEAKER_VINI", "CH01_TUNNEL_03"], ["SPEAKER_LAMPIAO", "CH01_TUNNEL_04"]])
	await d.await_trigger("DistrustTrigger")
	d.lock_player(true)
	d.objective("")
	following = false
	d.cast.vini.look_at_point(Global.player.global_position, 0.2)
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_TUNNEL_05"],
		["SPEAKER_VINI", "CH01_TUNNEL_06"],
		["SPEAKER_LAMPIAO", "CH01_TUNNEL_07"],
		["SPEAKER_VINI", "CH01_TUNNEL_08"],
		["SPEAKER_LAMPIAO", "CH01_TUNNEL_09"],
		["SPEAKER_VINI", "CH01_TUNNEL_10"],
	])
	d.face_player_to("Tunnel_4")
	Scares.shake(0.15, 0.3)
	d.cast.vini.pose("Crouch_Idle")
	await Dialogue.say([
		["SPEAKER_VINI", "CH01_TUNNEL_11"],
		["SPEAKER_LAMPIAO", "CH01_TUNNEL_12"],
		["SPEAKER_LAMPIAO", "CH01_TUNNEL_13"],
		["SPEAKER_VINI", "CH01_TUNNEL_14"],
	])
	d.face_player_to("ViniHall")
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_TUNNEL_15"]])
	d.cast.vini.pose("Idle")


func _vini_follows(d: Chapter01Director) -> void:
	var vini: Node3D = d.cast.vini
	while following:
		var player_at: Vector3 = Global.player.global_position
		if vini.global_position.distance_to(player_at) > FOLLOW_DISTANCE * 1.6:
			await vini.walk_to(player_at + player_at.direction_to(vini.global_position) * FOLLOW_DISTANCE, 1.8, true)
		else:
			await d.get_tree().create_timer(0.4).timeout


func _mouth_fire(d: Chapter01Director) -> void:
	while following and Global.player.global_position.z < MOUTH_FIRE_UNTIL_Z and is_instance_valid(d.colonel):
		var shooter: Node3D = d.cast.mouth_soldiers.pick_random()
		Effects.gunshot(d, shooter.global_position + Vector3.UP * 1.4)
		await d.get_tree().create_timer(randf_range(0.3, 0.8)).timeout
