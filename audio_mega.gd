extends Node

var ingame = false
var current_state = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$main_menu.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ingame == current_state:
		return
	else:
		if ingame:
			$main_menu.stop()
			$ingame.play()
		elif !ingame:
			$ingame.stop()
			$main_menu.play()
		current_state = ingame
		
