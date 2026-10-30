extends AudioStreamPlayer

const MIX_RATE := 22050.0
const CRICKET_HZ := 4400.0
const SILENCE_RADIUS := 15.0

var playback: AudioStreamGeneratorPlayback
var phase := 0.0
var t := 0.0
var wind := 0.0
var cricket_level := 0.0
var rain_level := 0.0
var rain_noise := 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = MIX_RATE
	generator.buffer_length = 0.15
	stream = generator
	volume_db = -14.0
	play()
	playback = get_stream_playback()


func _process(delta: float) -> void:
	var target := 0.0
	if Pact.active and Global.player and not _creature_near() and rain_level == 0.0:
		target = 1.0
	cricket_level = move_toward(cricket_level, target, delta * (0.4 if target > cricket_level else 2.5))
	var frames := playback.get_frames_available()
	for i in frames:
		t += 1.0 / MIX_RATE
		phase = fmod(phase + CRICKET_HZ / MIX_RATE, 1.0)
		var chirp := 1.0 if fmod(t * 14.0, 1.0) < 0.5 and fmod(t, 2.3) < 0.9 else 0.0
		var cricket := sin(phase * TAU) * chirp * 0.18 * cricket_level
		wind = lerpf(wind, randf_range(-1.0, 1.0), 0.02)
		var gust := 0.5 + 0.5 * sin(t * 0.21) * sin(t * 0.13)
		var white := randf_range(-1.0, 1.0)
		var hiss := white - rain_noise
		rain_noise = white
		var sample := cricket + wind * 0.35 * gust + hiss * 0.12 * rain_level
		playback.push_frame(Vector2(sample, sample))


func _creature_near() -> bool:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.is_alive and enemy.global_position.distance_to(Global.player.global_position) < SILENCE_RADIUS:
			return true
	return false
