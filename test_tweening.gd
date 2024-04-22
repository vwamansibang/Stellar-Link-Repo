extends Node2D

@onready var png = $Icon
@onready var txt = $Label

var start = true
var turn_left = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(png, "position", event.position, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

func _process(delta):
	if not turn_left:
#		var tween_right = create_tween()
#		tween_right.tween_property(txt, "rotation_degrees", 90, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
#
#		await tween_right.finished
		rotation_degrees += 1
		if rotation_degrees == 18:
			turn_left = true
	elif turn_left:
#		var tween_left = create_tween()
#		tween_left.tween_property(txt, "rotation_degrees", -90, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
#
#		await tween_left.finished
		rotation_degrees -= 1
		if rotation_degrees == -18:
			turn_left = false
