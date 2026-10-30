extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 7
	d.lock_player(true)
	var player_camera: Camera3D = Global.player.camera
	var corpse := d.NPC.new()
	corpse.shirt_color = d.LEATHER
	corpse.hat = "none"
	d.add_child(corpse)
	corpse.global_position = Global.player.global_position
	corpse.model.rotation.y = Global.player.camera_pivot.rotation.y + PI
	var head_camera := Camera3D.new()
	d.add_child(head_camera)
	head_camera.global_transform = player_camera.global_transform
	head_camera.make_current()
	Global.player.visible = false
	Global.player.get_node("WeaponSubViewport").visible = false
	d.set_hud_visible(false)
	Scares.shake(0.05, 0.3)
	GameUI.hit_flash = 1.0
	var fall := d.create_tween().set_parallel()
	fall.tween_property(head_camera, "global_position", d.marker("HeadDrop") + Vector3.UP * 0.15, 1.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	fall.tween_property(head_camera, "rotation", head_camera.rotation + Vector3(0.3, TAU * 1.5, 1.4), 1.1)
	await fall.finished
	GameUI.crack_lens()
	var body_yaw := atan2(corpse.global_position.x - head_camera.global_position.x, corpse.global_position.z - head_camera.global_position.z) + PI
	await d.create_tween().tween_property(head_camera, "rotation", Vector3(0.05, body_yaw, 1.45), 0.6).finished
	Effects.blood_jet(d, corpse.global_position + Vector3.UP * 1.55)
	await d.get_tree().create_timer(1.5).timeout
	corpse.pose("Crouch_Idle")
	Scares.sound_behind("breathing", 1.0)
	var colonel := d.spawn_npc("ColonelHall", d.SUIT, "kepi", false)
	await colonel.look_at_point(head_camera.global_position, 0.1)
	var held_at: Vector3 = colonel.global_position + Vector3(0, 1.3, 0) + colonel.global_position.direction_to(corpse.global_position) * 0.6
	await d.create_tween().tween_property(head_camera, "global_position", held_at, 0.9).finished
	head_camera.look_at(colonel.global_position + Vector3.UP * 1.55)
	head_camera.rotation.z = 0.3
	await Dialogue.say([["SPEAKER_CORONEL", "CH01_BEHEADING_01"]])
	await d.create_tween().tween_property(head_camera, "rotation:y", head_camera.rotation.y + PI * 0.7, 1.4).finished
	await Dialogue.say([
		["SPEAKER_CORONEL", "CH01_BEHEADING_03"],
		["SPEAKER_VINI", "CH01_BEHEADING_04"],
		["SPEAKER_CORONEL", "CH01_BEHEADING_05"],
		["SPEAKER_VINI", "CH01_BEHEADING_06"],
	])
	d.cast.vini.die()
	Effects.blood_jet(d, d.cast.vini.global_position + Vector3.UP * 1.3)
	Effects.blood_pool(d, d.marker("Slab") + Vector3(0, 0.47, 0), 1.6)
	for totem in d.get_tree().get_nodes_in_group("totens"):
		d.light_totem(totem)
		await d.get_tree().create_timer(0.35).timeout
	await Dialogue.say([
		["SPEAKER_ELA", "CH01_BEHEADING_07"],
		["SPEAKER_CORONEL", "CH01_BEHEADING_08"],
		["SPEAKER_ELA", "CH01_BEHEADING_09"],
		["SPEAKER_CORONEL", "CH01_BEHEADING_10"],
	])
	corpse.pose("Idle")
	await d.get_tree().create_timer(0.8).timeout
	await Dialogue.fade(1.0, 0.25)
	head_camera.queue_free()
	corpse.queue_free()
	d.colonel = colonel
