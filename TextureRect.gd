extends TextureRect

var turn = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not turn:
		rotation_degrees += 0.025
		if rotation_degrees >= 9:
			turn = !turn
	elif turn:
		rotation_degrees -= 0.025
		if rotation_degrees <= -9:
			turn = !turn
