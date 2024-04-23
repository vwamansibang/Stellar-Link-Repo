extends Button

@export var level_num : int
@export var level_scene : String

# Called when the node enters the scene tree for the first time.
func _ready():
	check_if_disabled()
	if disabled:
		text = "X"
		
	self.pressed.connect(_on_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_if_disabled():
	if !auto.full_game_data.has(level_num) or level_num <= 1:
		return
	
	if auto.full_game_data[level_num-1] == true:
		disabled = false

func go_to_level():
	if level_scene.length() <= 0:
		return
	load_trans.play_trans()
	await load_trans.trans_finished
	get_tree().change_scene_to_file(level_scene)


func _on_pressed():
	audio_mega.get_node("btn_press").play()
	if disabled:
		return
	go_to_level()
