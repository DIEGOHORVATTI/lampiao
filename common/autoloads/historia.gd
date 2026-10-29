extends Node

const SAVE_PATH := "user://historia.json"

var flags := {}
var marca := 0
var graca := 0
var folhetos := 0
var capitulo := 1


func _ready() -> void:
	load_game()


func set_flag(key: String, value: String) -> void:
	flags[key] = value
	save_game()


func flag(key: String) -> String:
	return flags.get(key, "")


func add_marca() -> void:
	marca = mini(marca + 1, 6)
	save_game()


func add_graca() -> void:
	graca = mini(graca + 1, 6)
	save_game()


func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({"flags": flags, "marca": marca, "graca": graca, "folhetos": folhetos, "capitulo": capitulo}))


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var data = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if data is Dictionary:
		flags = data.get("flags", {})
		marca = int(data.get("marca", 0))
		graca = int(data.get("graca", 0))
		folhetos = int(data.get("folhetos", 0))
		capitulo = int(data.get("capitulo", 1))


func reset() -> void:
	flags = {}
	marca = 0
	graca = 0
	folhetos = 0
	capitulo = 1
	save_game()
