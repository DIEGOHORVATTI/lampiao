extends "res://game/world/components/trigger.gd"

@export_enum("jumpscare", "apparition", "footsteps", "knock", "whisper", "breathing", "blackout") var kind := "apparition"
@export var face := "entity"


func _ready() -> void:
	super._ready()
	entered.connect(_trigger_scare)


func _trigger_scare() -> void:
	match kind:
		"jumpscare": Scares.jumpscare(face)
		"apparition": Scares.apparition()
		"blackout": Scares.blackout()
		"footsteps", "knock", "whisper", "breathing": Scares.sound_behind(kind)
