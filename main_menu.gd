extends Control

var prevent_repeat = false

@onready var title = $TextureRect
@onready var ui = $VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	auto.load_game_data()
	auto.current_lvl = 0
	
	title.position -= Vector2(0, 120)
	ui.position += Vector2(0, 80)
	if load_trans.cover:
		load_trans.play_trans()
	enter_screen()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func enter_screen():
	if prevent_repeat:
		return
	prevent_repeat = true
	var tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(tween.TRANS_SPRING)
	tween.tween_property(title, "position", title.position + Vector2(0, 120), 2.0)
	tween.tween_property(ui, "position", ui.position - Vector2(0, 80), 1.6)
	
	await tween.finished
	prevent_repeat = false

func exit_screen():
	if prevent_repeat:
		return
	prevent_repeat = true
	var tween = create_tween().set_parallel(true)
	tween.set_ease(tween.EASE_IN_OUT)
	tween.set_trans(tween.TRANS_CUBIC)
	tween.tween_property(title, "position", title.position - Vector2(0, 120), 1.6)
	tween.tween_property(ui, "position", ui.position + Vector2(0, 80), 1)
	
	await tween.finished
	prevent_repeat = false
	get_tree().quit()


func _on_button_3_pressed():
	exit_screen()


func _on_button_pressed():
	load_trans.play_trans()
	await load_trans.trans_finished
	get_tree().change_scene_to_file("res://select_level.tscn")
