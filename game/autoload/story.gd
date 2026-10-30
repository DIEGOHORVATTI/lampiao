extends Node

const SAVE_PATH := "user://historia.json"

var flags := {}
var mark := 0
var grace := 0
var pamphlets := 0
var chapter := 1


func _ready() -> void:
	load_game()


func set_flag(key: String, value: String) -> void:
	flags[key] = value
	save_game()


func flag(key: String) -> String:
	return flags.get(key, "")


func add_mark() -> void:
	mark = mini(mark + 1, 6)
	save_game()


func add_grace() -> void:
	grace = mini(grace + 1, 6)
	save_game()


func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({"flags": flags, "mark": mark, "grace": grace, "pamphlets": pamphlets, "chapter": chapter}))


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var data = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if data is Dictionary:
		flags = data.get("flags", {})
		mark = int(data.get("mark", 0))
		grace = int(data.get("grace", 0))
		pamphlets = int(data.get("pamphlets", 0))
		chapter = int(data.get("chapter", 1))


func reset() -> void:
	flags = {}
	mark = 0
	grace = 0
	pamphlets = 0
	chapter = 1
	save_game()
