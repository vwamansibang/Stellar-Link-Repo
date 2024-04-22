extends Node2D

var prevent_repeat = false
var line_arr
var planet_arr
var drone_arr
var bodies_arr
var line_connections = {}
var point_to_lines = {}
var point_to_points = {}

var planet_cnt = 0
var total_lines = 0

@export var current_lvl_int = 0
@export var next_lvl : String
@export var self_lvl : String

func _ready():
	auto.current_lvl = current_lvl_int
	if next_lvl.length() != 0:
		auto.next_scene = next_lvl
	else:
		auto.next_scene = null
	
	if load_trans.cover:
		load_trans.play_trans()
	
	line_arr = get_tree().get_nodes_in_group("lines_group")
	if !line_arr.is_empty():
		get_tree().call_group("lines_group", "queue_free")
	planet_arr = get_tree().get_nodes_in_group("planets_group")
	drone_arr = get_tree().get_nodes_in_group("drones_group")
	bodies_arr = planet_arr.duplicate()
	for drone in drone_arr:
		if drone.name != "planet_area":
			bodies_arr.append(drone)
		
	
	line_connections = {}
	point_to_lines = {}
	point_to_points = {}
	for body in bodies_arr:
		point_to_lines[body.name] = []
		point_to_points[body.name] = []
	
	auto.all_points_connected = false
#	print(line_connections)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		reset_scene()
	
	line_arr = get_tree().get_nodes_in_group("lines_group")
	drone_arr = get_tree().get_nodes_in_group("drones_group")
	bodies_arr = planet_arr.duplicate()
	for drone in drone_arr:
		if drone.name != "planet_area":
			bodies_arr.append(drone)
	
	if Input.is_action_just_pressed("clear") and not prevent_repeat and not auto.all_points_connected:
		get_tree().call_group("lines_group", "fade_away_die")
		renew_line_connections()
		prevent_repeat = true
	
	line_arr = get_tree().get_nodes_in_group("lines_group")
	
	if line_arr.size() != total_lines:
		if check_lines_all_connected():
			total_lines = line_arr.size()
#			print(total_lines)
			renew_line_connections()
#			print("----Line Connections----")
#			print(line_connections, "\n")
			renew_point_to_lines()
#			print("----Point to Lines----")
#			print(point_to_lines, "\n")
			renew_point_to_points()
#			print("----Point to Points----")
#			print(point_to_points, "\n")
			auto.all_points_connected = check_if_all_points_connected()
#			print(auto.all_points_connected)
	if line_arr.is_empty():
		prevent_repeat = false
	if Input.is_action_just_pressed("undo"):
		if line_arr.is_empty(): 
			return
		else:
			line_arr[-1].fade_away_die()
			renew_line_connections()
			
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	
func check_lines_all_connected():
	for line in line_arr:
		if line.line_connected and !line.overlap:
			continue
		else:
			return false
	return true

func renew_line_connections():
	line_connections = {}
	for body in bodies_arr:
		point_to_lines[body] = []
		point_to_points[body] = []
		
	for line in line_arr:
		var line_endpoints = []
		for body in bodies_arr:
			if line.points.has(body.position):
				line_endpoints.append(body.name)
		line_connections[line.get_index()] = line_endpoints

func renew_point_to_lines():
	for body in bodies_arr:
		point_to_lines[body.name] = []
	for point in point_to_lines:
		for line in line_connections:
			if line_connections[line].has(point):
				if !point_to_lines[point].has(line):
					point_to_lines[point].append(line)
	
func renew_point_to_points():
	for body in bodies_arr:
		point_to_points[body.name] = []
	for pointaa in point_to_points:
		for line in point_to_lines[pointaa]:
			if !line_connections.has(line):
				break
			for item in line_connections[line]:
				if pointaa == item:
					continue
				point_to_points[pointaa].append(item)
	
func check_if_all_points_connected():
	var check_list = []
	for key in point_to_lines:
		check_list.append(key)
	var planet_list = planet_arr
	var check = []
	var queue = []
	
	#look for all branches
	queue.append(check_list[0])
	while !queue.is_empty():
		for item in point_to_points[queue[0]]:
			if !check.has(item):
				queue.append(item)
		check.append(queue.pop_front())
#		print("queue: ", queue)
#		print("check: ", check)
		
	for item in planet_list:
		if check.has(item.name):
			continue
		else:
			return false
	return true

func reset_scene():
	if auto.all_points_connected:
		return
	load_trans.play_trans()
	await  load_trans.trans_finished
	get_tree().change_scene_to_file(self_lvl) #<--- wont change file
