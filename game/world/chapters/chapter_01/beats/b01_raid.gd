extends RefCounted

const GUARD_FIRE_INTERVAL := 1.6
const GUARD_DAMAGE := 4.0


func run(d: Chapter01Director) -> void:
	d.beat = 1
	d.teleport_player("LampiaoRaid", 0.0)
	d.cast.triangles = d.spawn_npc("Triangles", d.LEATHER, "half_moon")
	d.cast.triangles.pose("Crouch_Idle")
	d.cast.stars = d.spawn_npc("Stars", d.LEATHER.darkened(0.2), "half_moon")
	d.cast.drawings = d.spawn_npc("Drawings", d.LEATHER.darkened(0.35), "half_moon")
	d.cast.maria = d.spawn_maria("MariaFarm")
	var guard := d.spawn_npc("Guard", d.SHIRT, "none")
	guard.look_at_point(d.marker("LampiaoRaid"), 0.01)
	d.face_player_to("Guard")
	Global.player.weapons_manager.switch_weapon(2)
	d.set_hud_visible(true)
	await Dialogue.fade(0.0, 0.4)
	d.lock_player(false)
	d.objective("CH01_GOAL_RAID")
	var target := d.attach_hit_target(guard)
	var alive := [true]
	target.hit.connect(func():
		alive[0] = false
		guard.die())
	while alive[0]:
		Effects.gunshot(d, guard.global_position + Vector3.UP * 1.4)
		Global.player.get_damage(GUARD_DAMAGE, Vector3.ZERO, true)
		await d.get_tree().create_timer(GUARD_FIRE_INTERVAL).timeout
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_RAID_01"]])
	await _unarmed_soldier(d)
	await Dialogue.say([["", "CH01_RAID_05"]])
	for key in ["triangles", "stars", "drawings", "maria"]:
		d.cast[key].walk_to(d.marker("BackDoor") + Vector3(randf_range(-1.0, 1.0), 0, randf_range(0.0, 3.0)), 1.8, true)
	d.lock_player(false)
	d.objective("CH01_GOAL_RAID", ["RoomDoor", "SoldierHandsUp", "BackDoor"])
	await d.await_trigger("BackDoorTrigger")


func _unarmed_soldier(d: Chapter01Director) -> void:
	d.lock_player(true)
	var soldier := d.spawn_volante("SoldierDoor", false)
	await soldier.walk_to(d.marker("SoldierHandsUp"), 1.4)
	d.face_player_to("SoldierHandsUp")
	d.cast.drawings.look_at_point(soldier.global_position, 0.2)
	d.cast.drawings.pose("Pistol_Aim_Neutral")
	await Dialogue.say([["SPEAKER_CANGACEIRO", "CH01_RAID_02"]])
	Effects.gunshot(d, d.cast.drawings.global_position + Vector3.UP * 1.3)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_RAID_03"], ["SPEAKER_LAMPIAO", "CH01_RAID_04"]])
	d.cast.drawings.pose("Idle")
	soldier.walk_to(d.marker("SoldierDoor"), 2.0, true)
	d.get_tree().create_timer(2.5).timeout.connect(soldier.queue_free)
