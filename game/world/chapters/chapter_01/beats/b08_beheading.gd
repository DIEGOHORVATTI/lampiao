extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 8
	d.lock_player(true)
	var player_camera: Camera3D = Global.player.camera
	var corpse := d.NPC.new()
	corpse.shirt_color = d.LEATHER
	corpse.hat = "none"
	corpse.carries_rifle = false
	d.add_child(corpse)
	corpse.global_position = Global.player.global_position
	corpse.model.rotation.y = Global.player.camera_pivot.rotation.y + PI
	d.colonel = d.spawn_npc("ColonelBehind", d.SUIT, "kepi", false)
	d.colonel.look_at_point(corpse.global_position, 0.01)
	var escort := [d.spawn_volante("HallSoldier_1"), d.spawn_volante("HallSoldier_2")]
	var head_camera := Camera3D.new()
	d.add_child(head_camera)
	head_camera.global_transform = player_camera.global_transform
	head_camera.make_current()
	Global.player.visible = false
	Global.player.get_node("WeaponSubViewport").visible = false
	d.set_hud_visible(false)
	GameUI.hit_flash = 1.0
	var fall := d.create_tween().set_parallel()
	fall.tween_property(head_camera, "global_position", d.marker("HeadDrop") + Vector3.UP * 0.15, 1.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	fall.tween_property(head_camera, "rotation", head_camera.rotation + Vector3(0.3, TAU * 1.5, 1.4), 1.1)
	await fall.finished
	Effects.blood_jet(d, corpse.global_position + Vector3.UP * 1.55)
	head_camera.look_at(d.colonel.global_position + Vector3.UP * 1.2)
	head_camera.rotation.z = 1.45
	corpse.pose("Crouch_Idle")
	await d.get_tree().create_timer(1.2).timeout
	await Dialogue.say([
		["SPEAKER_CORONEL", "CH01_BEHEADING_01"],
		["SPEAKER_CORONEL", "CH01_BEHEADING_02"],
		["SPEAKER_VINI", "CH01_BEHEADING_03"],
		["SPEAKER_CORONEL", "CH01_BEHEADING_04"],
		["SPEAKER_VINI", "CH01_BEHEADING_05"],
	])
	d.colonel.look_at_point(d.cast.vini.global_position, 0.1)
	Effects.gunshot(d, d.colonel.global_position + Vector3.UP * 1.4)
	d.cast.vini.die()
	Effects.blood_jet(d, d.cast.vini.global_position + Vector3.UP * 0.4, 1.5)
	Effects.blood_pool(d, d.cast.vini.global_position + Vector3.UP * 0.02, 1.2)
	await Dialogue.say([["SPEAKER_CORONEL", "CH01_BEHEADING_06"]])
	_pulse(d, corpse)
	var held_at: Vector3 = d.colonel.global_position + Vector3(0, 1.3, 0) + d.colonel.global_position.direction_to(head_camera.global_position) * 0.6
	await d.create_tween().tween_property(head_camera, "global_position", held_at, 0.9).finished
	head_camera.look_at(d.colonel.global_position + Vector3.UP * 1.55)
	head_camera.rotation.z = 0.3
	await Dialogue.say([["SPEAKER_CORONEL", "CH01_BEHEADING_07"]])
	_black_mist(d)
	await Dialogue.say([
		["SPEAKER_ELA", "CH01_BEHEADING_08"],
		["SPEAKER_CORONEL", "CH01_BEHEADING_09"],
		["SPEAKER_ELA", "CH01_BEHEADING_10"],
		["SPEAKER_CORONEL", "CH01_BEHEADING_11"],
		["SPEAKER_CORONEL", "CH01_BEHEADING_12"],
		["SPEAKER_ELA", "CH01_BEHEADING_13"],
		["SPEAKER_ELA", "CH01_BEHEADING_14"],
		["SPEAKER_ELA", "CH01_BEHEADING_15"],
	])
	corpse.pose("Idle")
	Scares.jumpscare("entity")
	await d.get_tree().create_timer(0.8).timeout
	await Dialogue.fade(1.0, 0.25)
	head_camera.queue_free()
	corpse.queue_free()
	for soldier in escort:
		soldier.queue_free()


func _pulse(d: Chapter01Director, corpse: Node3D) -> void:
	for i in 4:
		Scares.shake(0.05, 0.15)
		var beat := d.create_tween()
		beat.tween_property(corpse.model, "scale", Vector3.ONE * 1.04, 0.12)
		beat.tween_property(corpse.model, "scale", Vector3.ONE, 0.3)
		await d.get_tree().create_timer(0.9).timeout


func _black_mist(d: Chapter01Director) -> void:
	var mist := d.create_tween().set_parallel()
	mist.tween_property(d.environment, "fog_density", 0.12, 6.0)
	mist.tween_property(d.environment, "fog_light_color", Color(0.01, 0.0, 0.0), 6.0)
