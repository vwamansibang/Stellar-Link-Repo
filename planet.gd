extends Node2D

var mouse_overlapped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_overlapped:
		var tween = create_tween()
		tween.tween_property(self, "scale", 2.4, 0.5)
	else:
		var tween = create_tween()
		tween.tween_property(self, "scale", 1, 0.5)

func _on_area_2d_mouse_entered():
	mouse_overlapped = true
	print("Mouse_Overlapped")


func _on_area_2d_mouse_exited():
	mouse_overlapped = false
	print("Mouse_Exited")
