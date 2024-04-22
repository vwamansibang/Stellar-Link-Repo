extends Node2D

@export var sprite_img = 0

@onready var img = $Sprite2D
@onready var ring = $Sprite2D2

var mouse_collided = false
var carried_planet = false
var drop_load = false
var vec1 = Vector2(1.28, 1.28)
var vec2 = Vector2(1, 1)

var ring_hide = Vector2(0.1, 0.1)
var ring_show = Vector2(1, 1)

func _ready():
	img.frame = sprite_img

func _process(_delta):
	if not auto.carrying_line:
		carried_planet = false
		drop_load = false
	else:
		drop_load = true
#	if Input.is_action_just_pressed("ui_accept"):
#		print("SPACEBAR + ", mouse_collided)
#		mouse_collided = !mouse_collided
	if mouse_collided or carried_planet or auto.all_points_connected:
		if not auto.carrying_line:
			carried_planet = true
		pop_up()
		planet_select()
	if not mouse_collided and not auto.all_points_connected	:
		if not auto.carrying_line:
			pop_down()
			planet_deselect()
		elif not carried_planet:
			pop_down()
			planet_deselect()
			
#	if auto.all_points_connected:
#		pop_up()
#		planet_select()
#	elif !auto.all_points_connected:
#		pop_down()
#		planet_deselect()

func _on_area_2d_mouse_entered():
	mouse_collided = true
	auto.pinpoint = position
	planet_select()

func _on_area_2d_mouse_exited():
	mouse_collided = false
	auto.pinpoint = Vector2.ZERO
	planet_deselect()

func _on_button_pressed():
	var loaded_file = load("res://line.tscn")
	var line_scene = loaded_file.instantiate()
	line_scene.points[0] = auto.pinpoint
	line_scene.points[1] = auto.pinpoint
	get_tree().get_root().add_child(line_scene)

func planet_select():
	var tween_select = create_tween()
	tween_select.set_ease(Tween.EASE_OUT)
	tween_select.set_trans(Tween.TRANS_CIRC)
	tween_select.tween_property(ring, "scale", ring_show, 5)
	
	ring.rotation_degrees += 1
	if ring.rotation_degrees == 360:
		ring.rotation_degrees = 0
	
func planet_deselect():
	var tween_select = create_tween()
	tween_select.set_ease(Tween.EASE_OUT_IN)
	tween_select.set_trans(Tween.TRANS_SPRING)
	tween_select.tween_property(ring, "scale", ring_hide, 5)
	
func pop_up():
	var tween_resize = create_tween()
	tween_resize.set_ease(Tween.EASE_OUT)
	tween_resize.set_trans(Tween.TRANS_CIRC)
	tween_resize.tween_property(self, "scale", vec1, 3)

func pop_down():
	var tween_resize = create_tween()
	tween_resize.set_ease(Tween.EASE_OUT_IN)
	tween_resize.set_trans(Tween.TRANS_SPRING)
	tween_resize.tween_property(self, "scale", vec2, 3)
