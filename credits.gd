extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if load_trans.cover:
		load_trans.play_trans()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	audio_mega.get_node("btn_press").play()
	load_trans.play_trans()
	await load_trans.trans_finished
	get_tree().change_scene_to_file("res://main_menu.tscn")
