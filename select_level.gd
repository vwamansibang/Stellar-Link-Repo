extends Control

@onready var unlock_text = $VBoxContainer/Label
@onready var grid = $VBoxContainer/GridContainer

func _ready():
	auto.current_lvl = 0
	check_unlock()
	
	if load_trans.cover:
		load_trans.play_trans()

func _on_menu_btn_pressed():
	load_scene("res://main_menu.tscn")
	
func load_scene(scene):
	load_trans.play_trans()
	await load_trans.trans_finished
	get_tree().change_scene_to_file(scene)

func check_unlock():
	if auto.full_game_data.has(4) and auto.full_game_data[4] == true:
		unlock_text.hide()
		grid.show()

func _on_reset_btn_pressed():
	auto.reset_game_data()
	load_scene("res://select_level.tscn")
