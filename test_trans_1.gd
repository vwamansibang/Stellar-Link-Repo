extends Node2D

@onready var trans_img = $CanvasLayer/trans

signal trans_finished
var prevent_repeat = false
var cover = false
# Called when the node enters the scene tree for the first time.
func _ready():
	trans_img.offset.x = -192

	
func play_trans():
	if prevent_repeat:
		return
	prevent_repeat = true
	
#	audio_mega.get_node("fadefx").play()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(trans_img, "offset", trans_img.offset + Vector2(288, 0), 0.8)
	
	await tween.finished
	if trans_img.offset.x == 384:
		trans_img.offset.x = -192
	prevent_repeat = false
	if !get_tree().get_nodes_in_group("lines_group").is_empty():
		get_tree().call_group("lines_group", "queue_free")
	if cover:
		auto.all_points_connected = false
	auto.save_game_data()
	cover = !cover
	trans_finished.emit()
