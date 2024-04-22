extends Node2D

@onready var line = $Line2D

var line_started = false
var line_connected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if line_started and not line_connected:
		line.points[line.get_point_count()-1] = get_viewport().get_mouse_position()

func _on_planet_planet_drag(pos):
	if not line_started:
		line.add_point(pos)
		line.add_point(pos)
		line_started = true
	

func _on_planet_mouse_released():
	if not line_connected:
		line.clear_points()
		line_started = false


func _on_planet_overlapped(pos):
	if line_started:
		if line.points[line.get_point_count()-2] != pos:
			line.points[line.get_point_count()-1] = pos
			line_connected = true
			line_started = false
