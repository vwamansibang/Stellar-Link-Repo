extends Node2D

@onready var line = $Line2D
# Called when the node enters the scene tree for the first time.

var new_point = Vector2.ZERO
var line_started = false

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		extend_line()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if line_started:
		line.points[line.get_point_count()-1] = get_viewport().get_mouse_position()
	
func start_new_line():
	line.add_point(get_viewport().get_mouse_position())
	line.add_point(get_viewport().get_mouse_position())
	line_started = true
	print("LINE STARTED")

func extend_line():
	if line_started == false:
		start_new_line()
	elif line_started:
		line.add_point(get_viewport().get_mouse_position())
		print("LINE EXTENDED")
		
