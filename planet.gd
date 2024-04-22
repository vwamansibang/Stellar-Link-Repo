extends Node2D

signal interact
signal mouse_released
signal planet_drag(pos)
signal overlapped(pos)

var mouse_overlapped = false

@onready var anim = $AnimationPlayer
@onready var icon = $Icon

@export var sprite_img = 0
@export var node_held = false

func _ready():
	icon.frame = sprite_img

func _process(delta):
	if Input.is_action_just_released("click"):
		mouse_released.emit()
		
	#TODO: Node is definitely held, but remote not showing it dunno why
	if node_held:
		planet_drag.emit(self.position)


func _on_area_2d_mouse_entered():
	mouse_overlapped = true
	overlapped.emit(self.position)
	anim.play("selected")

func _on_area_2d_mouse_exited():
	mouse_overlapped = false
	anim.play("unselected")


func _on_button_pressed():
	node_held = true
#	print("node_held = true")
	await mouse_released
#	print("node_held = false")
	node_held = false
