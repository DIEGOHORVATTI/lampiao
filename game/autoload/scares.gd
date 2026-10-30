extends CanvasLayer

const RATE := 22050
const FACES := {
	"entity": "res://resources/ui/scares/entity.jpg",
	"maria": "res://resources/ui/scares/maria.jpg",
	"eaten_soldier": "res://resources/ui/scares/eaten_soldier.jpg",
	"moon": "res://resources/ui/scares/moon.jpg",
}
const UNDEAD := preload("res://enemies/undead.tscn")
const FOOTSTEP := preload("res://player/sfx/footstep_ground.ogg")

var face_rect: TextureRect
var sounds := {}


func _ready() -> void:
	layer = 18
	process_mode = Node.PROCESS_MODE_ALWAYS
	face_rect = TextureRect.new()
	face_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	face_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	face_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	face_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	face_rect.visible = false
	add_child(face_rect)
	sounds["stinger"] = _wav(_stinger(1.4))
	sounds["knock"] = _wav(_knock())
	sounds["whisper"] = _wav(_whisper(2.2))
	sounds["breathing"] = _wav(_breath(3.0))


func jumpscare(face := "entity", seconds := 0.45) -> void:
	face_rect.texture = load(FACES[face]) if ResourceLoader.exists(FACES[face]) else null
	face_rect.visible = true
	face_rect.pivot_offset = get_viewport().get_visible_rect().size / 2.0
	face_rect.scale = Vector2.ONE
	face_rect.modulate = Color(1, 1, 1, 1)
	_play(sounds["stinger"], 4.0)
	shake(0.35, 0.5)
	GameUI.hit_flash = 1.0
	if OS.has_feature("mobile"):
		Input.vibrate_handheld(350)
	var zoom := create_tween().set_parallel()
	zoom.tween_property(face_rect, "scale", Vector2.ONE * 1.18, seconds).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	zoom.tween_property(face_rect, "modulate:a", 0.0, 0.12).set_delay(seconds)
	await zoom.finished
	face_rect.visible = false


func shake(strength: float, seconds: float) -> void:
	var camera: Camera3D = Global.player.camera if Global.player else null
	if not camera:
		return
	var elapsed := 0.0
	while elapsed < seconds:
		if not is_instance_valid(camera):
			return
		var falloff := 1.0 - elapsed / seconds
		camera.h_offset = randf_range(-strength, strength) * falloff
		camera.v_offset = randf_range(-strength, strength) * falloff
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	if not is_instance_valid(camera):
		return
	camera.h_offset = 0.0
	camera.v_offset = 0.0


func apparition(distance := 7.0, seconds := 1.6) -> Node3D:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var forward := -camera.global_basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var side := 1.0 if randf() < 0.5 else -1.0
	var start_dir := forward.rotated(Vector3.UP, side * deg_to_rad(40.0))
	var end_dir := forward.rotated(Vector3.UP, side * deg_to_rad(75.0))
	var base := Global.player.global_position
	var shadow: CharacterBody3D = UNDEAD.instantiate()
	shadow.show_health_bar = false
	shadow.eye_glow = Color(0.95, 0.95, 0.9)
	get_tree().current_scene.add_child(shadow)
	shadow.remove_from_group("enemies")
	shadow.set_physics_process(false)
	shadow.global_position = base + start_dir * distance
	shadow.character_root.look_at(base + end_dir * distance, Vector3.UP)
	shadow.character_root.rotate_y(PI)
	shadow.animation_tree.set("parameters/conditions/move", true)
	shadow.animation_tree.get("parameters/playback").start("walk")
	_play_3d(FOOTSTEP, shadow.global_position, -2.0)
	var walk := create_tween()
	walk.tween_property(shadow, "global_position", base + end_dir * distance, seconds)
	walk.tween_callback(shadow.queue_free)
	return shadow


func sound_behind(kind := "footsteps", distance := 3.0) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var behind := camera.global_position + camera.global_basis.z * distance
	match kind:
		"footsteps":
			for i in 4:
				_play_3d(FOOTSTEP, behind, 0.0)
				await get_tree().create_timer(0.45).timeout
		_:
			_play_3d(sounds[kind], behind, 4.0)


func blackout(radius := 18.0, seconds := 3.0) -> void:
	var center := Global.player.global_position
	var lights: Array[OmniLight3D] = []
	for light in get_tree().current_scene.find_children("*", "OmniLight3D", true, false):
		if light.is_visible_in_tree() and light.global_position.distance_to(center) < radius and light.name != "Clarao":
			lights.append(light)
	for light in lights:
		light.set_meta("energia", light.light_energy)
		light.set_process(false)
	for blink in [0.0, 0.5, 0.0, 0.25, 0.0]:
		for light in lights:
			light.light_energy = light.get_meta("energia") * blink
		await get_tree().create_timer(0.08).timeout
	await get_tree().create_timer(seconds).timeout
	for light in lights:
		if is_instance_valid(light):
			light.light_energy = light.get_meta("energia")
			light.set_process(true)


func _play(stream: AudioStream, volume_db := 0.0) -> void:
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.volume_db = volume_db
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)


func _play_3d(stream: AudioStream, at: Vector3, volume_db := 0.0) -> void:
	var p := AudioStreamPlayer3D.new()
	p.stream = stream
	p.volume_db = volume_db
	get_tree().current_scene.add_child(p)
	p.global_position = at
	p.play()
	p.finished.connect(p.queue_free)


func _wav(samples: PackedFloat32Array) -> AudioStreamWAV:
	var data := PackedByteArray()
	data.resize(samples.size() * 2)
	for i in samples.size():
		data.encode_s16(i * 2, int(clampf(samples[i], -1.0, 1.0) * 32000.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = RATE
	wav.data = data
	return wav


func _stinger(seconds: float) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	out.resize(int(RATE * seconds))
	var freqs := [196.0, 207.65, 293.66, 311.13, 466.16, 587.33]
	for i in out.size():
		var t := float(i) / RATE
		var env := minf(t / 0.008, 1.0) * exp(-t * 2.6)
		var v := 0.0
		for f in freqs:
			var wobble: float = f * (1.0 + 0.012 * sin(TAU * 6.0 * t))
			v += (fmod(t * wobble, 1.0) * 2.0 - 1.0) * 0.16
		v += randf_range(-1.0, 1.0) * exp(-t * 18.0) * 0.6
		v += sin(TAU * 42.0 * t) * exp(-t * 4.0) * 0.7
		out[i] = v * env
	return out


func _knock() -> PackedFloat32Array:
	var out := PackedFloat32Array()
	out.resize(int(RATE * 0.12))
	for i in out.size():
		var t := float(i) / RATE
		out[i] = (sin(TAU * 170.0 * t) * 0.7 + randf_range(-0.3, 0.3)) * exp(-t * 45.0)
	return out


func _whisper(seconds: float) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	out.resize(int(RATE * seconds))
	var previous := 0.0
	for i in out.size():
		var t := float(i) / RATE
		var white := randf_range(-1.0, 1.0)
		var hiss := white - previous
		previous = white
		var syllables := pow(absf(sin(TAU * 3.3 * t + sin(TAU * 0.7 * t) * 2.0)), 3.0)
		var env := minf(t / 0.3, 1.0) * minf((seconds - t) / 0.4, 1.0)
		out[i] = hiss * syllables * env * 0.45
	return out


func _breath(seconds: float) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	out.resize(int(RATE * seconds))
	var smooth := 0.0
	for i in out.size():
		var t := float(i) / RATE
		smooth = lerpf(smooth, randf_range(-1.0, 1.0), 0.08)
		var cycle := pow(maxf(0.0, sin(TAU * 0.55 * t)), 2.0)
		out[i] = smooth * cycle * 0.9
	return out
