extends Node2D

#NOTE TO SELF THIS IS FROM THE DRONE NOT THE PLANET

@export var sprite_img = 0
@export var self_idx = 0

@onready var img = $Sprite2D

var mouse_collided = false
var carried_planet = false
var obj_selected = false
var drop_load = false

var vec1 = Vector2(1.28, 1.28)
var vec2 = Vector2(1, 1)

var ring_hide = Vector2(0.1, 0.1)
var ring_show = Vector2(1, 1)

var astar_idx

var arr = ["None", "Left", "Right"]
var direc = arr[0]
var moving = false
var mos_pos = Vector2.ZERO

var prevent_repeat = false
var append_str = ""

func _ready():
	img.frame = sprite_img
	var name = str(self.name)
	append_str=name[-1]

func _process(delta):
	if get_tree().get_nodes_in_group("drone_lines"+append_str).is_empty():
		prevent_repeat = false
#	if Input.is_action_just_pressed("ui_accept"):
#		kill_list()
	
	if mos_pos != get_global_mouse_position():
		mos_pos = get_global_mouse_position()
	else:
		direc = arr[0]
	
	if direc == arr[0]:
		rotation = lerp_angle(rotation, 0, 2.5 * delta)
	if obj_selected:
		if !get_tree().get_nodes_in_group("drones_group"+append_str).is_empty():
			audio_mega.get_node("ring_shrink").play()
		global_position = lerp(global_position, get_global_mouse_position(), 15 * delta)
		kill_list()
		if direc == arr[2]:
			rotation = lerp_angle(rotation, -12, 5 * delta)
		elif direc == arr[1]:
			rotation = lerp_angle(rotation, 12, 5 * delta)
		
	if not auto.carrying_line:
		carried_planet = false
		drop_load = false
	else:
		drop_load = true
		
	if mouse_collided or carried_planet:
		if not auto.carrying_line:
			carried_planet = true
##		pop_up()
#		planet_select()
	if not mouse_collided:
		if not auto.carrying_line:
#			pop_down()
#			planet_deselect()
			pass
		elif not carried_planet:
#			pop_down()
#			planet_deselect()
			pass
	if auto.line_cache != null and auto.line_cache.points[0] == self.position:
		auto.line_cache.queue_free()
		auto.line_cache = null
		auto.carrying_line = false
	if not auto.carrying_line and auto.line_cache != null:
		if get_tree().get_nodes_in_group("drone_lines"+append_str).has(auto.line_cache):
			return
		if auto.line_cache.points[1] != self.position:
			return
		add_to_list(auto.line_cache)

func _on_area_2d_mouse_entered():
	mouse_collided = true
	auto.pinpoint = position
#	planet_select()

func _on_area_2d_mouse_exited():
	mouse_collided = false
	auto.pinpoint = Vector2.ZERO
#	planet_deselect()
	
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


func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_released("click"):
		obj_selected = false
		direc = arr[0]
	if Input.is_action_just_pressed("click"):
		obj_selected = true
	if event is InputEventMouseMotion and obj_selected:
		if event.relative[0] > 0:
			direc = arr[2]
		if event.relative[0] < 0:
			direc = arr[1]

func add_to_list(line):
	line.add_to_group("drone_lines"+append_str)

func kill_list():
	if not prevent_repeat:
		get_tree().call_group("drone_lines"+append_str, "fade_away_die")
		prevent_repeat = true
	else:
		return
		
#TODO MAKE Drone explode when area collided to other area
#Add Meteors that spin slowly
#ADd line collission


func _on_area_2d_area_entered(area):
	var scene = load("res://explode.tscn")
	var instance = scene.instantiate()
	instance.position = self.position
	instance.rotation = self.rotation
	get_tree().get_root().add_child(instance)
	
	audio_mega.get_node("boomfx").play()
	kill_list()
	queue_free()
