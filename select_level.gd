extends Control

@onready var unlock_text = $VBoxContainer/Label
@onready var grid = $VBoxContainer/GridContainer
@onready var thanktext = $VBoxContainer/MarginContainer/VBoxContainer/thankyou

func _ready():
	
	audio_mega.ingame = false
	auto.current_lvl = 0
	check_unlock()
	
	if load_trans.cover:
		load_trans.play_trans()

func _on_menu_btn_pressed():
	audio_mega.get_node("btn_press").play()
	load_scene("res://main_menu.tscn")
	
func load_scene(scene):
	load_trans.play_trans()
	await load_trans.trans_finished
	get_tree().change_scene_to_file(scene)

func check_unlock():
	if auto.full_game_data.has(4) and auto.full_game_data[4] == true:
		unlock_text.hide()
		grid.show()
	if auto.full_game_data.has(16) and auto.full_game_data[16] == true:
		thanktext.show()

func _on_reset_btn_pressed():
	audio_mega.get_node("btn_press").play()
	auto.reset_game_data()
	load_scene("res://select_level.tscn")
