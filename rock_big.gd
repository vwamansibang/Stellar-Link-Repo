extends Node2D

var turn = false
var floating = true
var origin = Vector2.ZERO

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	origin = self.position
	var offset = rng.randi_range(-5,5)
	self.position.y += offset
	self.rotation_degrees -= offset*3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not turn:
		rotation_degrees += 0.1
		if rotation_degrees >= 18:
			turn = !turn
	elif turn:
		rotation_degrees -= 0.1
		if rotation_degrees <= -18:
			turn = !turn

	if floating:
		position.y += 0.05
		if position.y >= origin.y + 6:
			floating = !floating
	if not floating:
		position.y -= 0.05
		if position.y <= origin.y - 6:
			floating = !floating
