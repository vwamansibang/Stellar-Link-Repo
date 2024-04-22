extends Node2D

@onready var label = $Label

var arr = ["None", "Left", "Right"]
var direc = arr[0]
var moving = false
var mos_pos = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "Direction: "+direc

func _input(event):
	moving = false
	if event is InputEventMouseMotion:
#		print(event.velocity)
		if event.relative[0] > 0:
			direc = arr[2]
		if event.relative[0] < 0:
			direc = arr[1]
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mos_pos != get_global_mouse_position():
		moving = true
		mos_pos = get_global_mouse_position()
	else:
		moving = false
		direc = arr[0]
	label.text = "Direction: "+direc
	
