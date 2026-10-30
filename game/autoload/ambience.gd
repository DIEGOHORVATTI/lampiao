extends AudioStreamPlayer

const MIX_RATE := 22050.0

var playback: AudioStreamGeneratorPlayback
var t := 0.0
var wind := 0.0
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


func _process(_delta: float) -> void:
	var frames := playback.get_frames_available()
	for i in frames:
		t += 1.0 / MIX_RATE
		wind = lerpf(wind, randf_range(-1.0, 1.0), 0.02)
		var gust := 0.5 + 0.5 * sin(t * 0.21) * sin(t * 0.13)
		var white := randf_range(-1.0, 1.0)
		var hiss := white - rain_noise
		rain_noise = white
		var sample := wind * 0.35 * gust + hiss * 0.12 * rain_level
		playback.push_frame(Vector2(sample, sample))

