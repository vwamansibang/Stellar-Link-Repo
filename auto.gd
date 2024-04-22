extends Node

var random_num = 8
var pinpoint = Vector2.ZERO
var mouse_hold = false
var carrying_line = false
var hover = false
var all_points_connected = false
var level_done = false

var next_scene = null

var alert = false

var line_cache = null

var current_lvl = 0

var full_game_data = {}
var game_file = "user://save.dat"

func save_game_data():
#	print("save_game: ")
#	print(full_game_data)
	var file = FileAccess.open(game_file, FileAccess.WRITE)
	file.store_var(full_game_data)
	
func load_game_data():
	var file = FileAccess.open(game_file, FileAccess.READ)
	if FileAccess.file_exists(game_file):
		var loaded_data = file.get_var()
#		print("loaded data:")
#		print(loaded_data)
		for key in loaded_data:
			full_game_data[key] = loaded_data[key]
	else:
		reset_game_data()

func _ready():
	load_game_data()


func _process(delta):
	if auto.all_points_connected == true and current_lvl > 0:
#		print("level_complete")
		full_game_data[current_lvl] = true
		save_game_data()
		load_game_data()

func reset_game_data():
	for x in range(16):
		full_game_data[x+1] = false
	save_game_data()
