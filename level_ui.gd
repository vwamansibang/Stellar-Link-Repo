extends Control

var prevent_repeat = false
@export var leveltext : String
@export_multiline var descrip : String
@export var tip : String

@onready var levelbar = $Panel/VBoxContainer/label_box/Label
@onready var btn_start = $Panel/VBoxContainer/HBoxContainer/btn_start
@onready var btn_cont = $Panel/VBoxContainer/HBoxContainer/btn_cont
@onready var btn_menu = $Panel/VBoxContainer/HBoxContainer/btn_menu
@onready var textbox = $textbox/Panel/Label
@onready var labeltip = $textbox/Panel/Label2


# Called when the node enters the scene tree for the first time.
func _ready():
	levelbar.text = leveltext
	if descrip.length() <= 0:
		$textbox.hide()
	if tip.length() <= 0:
		labeltip.hide()
		
	labeltip.text = tip
	textbox.text = descrip
	self.position.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if auto.all_points_connected:
		reveal_ui()

func hide_ui():
	if prevent_repeat:
		return
	prevent_repeat = true
	audio_mega.get_node("fadefx").play()
	
	var tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(tween.TRANS_QUAD)
	tween.tween_property(self, "position", self.position + Vector2(0, -192), 1)
	
	await tween.finished
	
	prevent_repeat = false
	levelbar.text = "- - - Level Completed - - -"
	btn_start.hide()
	btn_cont.show()
	btn_menu.show()

func reveal_ui():
	if prevent_repeat:
		return
	prevent_repeat = true
	audio_mega.get_node("fadefx").play()
	
	var tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(tween.TRANS_SPRING)
	tween.tween_property(self, "position", self.position + Vector2(0, 192), 1.1)
	
	await tween.finished
	if auto.all_points_connected:
		return
	prevent_repeat = false

func _on_btn_start_pressed():
#	audio_mega.get_node("btn_press").play()
	hide_ui()


func _on_btn_cont_pressed():
	audio_mega.get_node("btn_press").play()
	var scene = auto.next_scene
	if auto.next_scene == null or scene == null:
		scene = "res://select_level.tscn"
	load_trans.play_trans()
	await load_trans.trans_finished
	get_tree().change_scene_to_file(scene)


func _on_btn_menu_pressed():
	audio_mega.get_node("btn_press").play()
	load_trans.play_trans()
	await load_trans.trans_finished
	audio_mega.ingame = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
