extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 12
	for soldier in d.soldiers:
		if is_instance_valid(soldier):
			soldier.queue_free()
	var dawn := d.create_tween().set_parallel()
	dawn.tween_property(d.environment, "background_color", Color(0.26, 0.3, 0.42), 8.0)
	dawn.tween_property(d.environment, "ambient_light_energy", 0.7, 8.0)
	dawn.tween_property(d.environment, "fog_light_color", Color(0.35, 0.37, 0.48), 8.0)
	d.cast.barauna.lie_down()
	d.cast.xexeu.lie_down()
	d.cast.maria.global_position = d.marker("MariaRock")
	d.cast.maria.pose("Sitting_Idle")
	await Dialogue.say([["", "CH01_MARIA_01"]])
	await d.interactable("MariaRock", "CH01_MARIA_02").used
	d.lock_player(true)
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_MARIA_03"],
		["SPEAKER_LAMPIAO", "CH01_MARIA_04"],
		["SPEAKER_LAMPIAO", "CH01_MARIA_05"],
		["SPEAKER_LAMPIAO", "CH01_MARIA_06"],
		["SPEAKER_MARIA", "CH01_MARIA_07"],
		["SPEAKER_MARIA", "CH01_MARIA_08"],
	])
	d.cast.maria.die()
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_MARIA_09"], ["", "CH01_MARIA_10"]])
	d.lock_player(false)
