extends Line2D

var mouse_pos = Vector2.ZERO
var line_connected = false
var dying = false

var ray_placed = false
var overlap = false
var prevent_repeat = false

@onready var raycast = $RayCast2D
@export var red : Color
@export var white : Color

func _ready():
	auto.carrying_line = true
	add_to_group("lines_group")
	auto.line_cache = self
	
	
# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseMotion:
		if self.points[0] == Vector2.ZERO:
			queue_free()
		mouse_pos = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	raycast.position = to_global(self.points[0])
	raycast.target_position = to_global(Vector2(self.points[1].x - self.points[0].x, self.points[1].y - self.points[0].y ))
	if raycast.is_colliding():
		if raycast.get_collider().name == "planet_area":
			raycast.add_exception(raycast.get_collider())
		else:
			overlap = true
			default_color = red
	else:
		overlap = false
		default_color = white
		
	
	if not line_connected:
		if auto.pinpoint == Vector2.ZERO:
			self.points[1] = mouse_pos
			boing_disconnect()
		else:
			self.points[1] = auto.pinpoint
			if auto.pinpoint != self.points[0]:
				boing_connect()
	
		if Input.is_action_just_released("click"):
			if self.points[0] == self.points[1] or auto.pinpoint == Vector2.ZERO:
				dying = true
				auto.line_cache = null
				auto.carrying_line = false
				fade_away_die()
			else:
				audio_mega.get_node("line_drop").play()
				
				self.points[1] = auto.pinpoint
				line_connected = true
				auto.carrying_line = false
				if overlap:
					auto.line_cache = null
					fade_away_die()
	elif line_connected and overlap:
		if prevent_repeat:
			return
		auto.line_cache = null
		fade_away_die()
		prevent_repeat = true

func fade_away_die():
	auto.carrying_line = false
	var tween_boing = create_tween()
	tween_boing.set_ease(Tween.EASE_IN_OUT)
	tween_boing.set_trans(Tween.TRANS_SINE)
	tween_boing.tween_property(self, "width", 0, 0.36)
	
	audio_mega.get_node("fadefx").play()
	
	await tween_boing.finished
	remove_from_group("lines_group")
	line_connected = false
	self.queue_free()

func boing_connect():
	var tween_con = create_tween()
	tween_con.set_ease(Tween.EASE_OUT)
	tween_con.set_trans(Tween.TRANS_SINE)
	tween_con.tween_property(self, "width", 4, 0.3)

func boing_disconnect():
	if dying:
		return
	var tween_con = create_tween()
	tween_con.set_ease(Tween.EASE_OUT_IN)
	tween_con.set_trans(Tween.TRANS_SINE)
	tween_con.tween_property(self, "width", 2, 0.3)
