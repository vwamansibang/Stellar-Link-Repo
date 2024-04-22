extends Node2D

var line_connections = {
	1: ['A','C'],
	2: ['C', 'B'],
	3: ['B', 'A']
}

var point_to_lines = {
	'A': [],
	'B': [],
	'C': [],
	'D': []
}
var point_to_points = {
	'A': [],
	'B': [],
	'C': [],
	'D': []
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("-----Line_Connections-----")
	print(line_connections)
	print("\n")
	
	print("-----Points_to_Lines-----")
	print_points_to_lines()
	print("\n")
	
	print("-----Points_to_points-----")
	print_point_to_points()
	print("\n")
	
	print("-----Print Checks-----")
	is_all_connected()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func print_points_to_lines():
	for point in point_to_lines:
		for line in line_connections:
			if line_connections[line].has(point):
				point_to_lines[point].append(line)
	print(point_to_lines)

func print_point_to_points():
	for pointaa in point_to_points:
		for line in point_to_lines[pointaa]:
			for item in line_connections[line]:
				if pointaa == item:
					continue
				point_to_points[pointaa].append(item)
		
	print(point_to_points)
	
func is_all_connected():
	var check_list = ["A", "B", "C", "D"]
	var check = []
	var queue = []
	
	queue.append(check_list[0])
	while !queue.is_empty():
		for item in point_to_points[queue[0]]:
			if !check.has(item):
				queue.append(item)
			else:
				continue
		check.append(queue.pop_front())
	
	for item in check_list:
		if check.has(item):
			continue
		else:
			print("Not Complete")
			return
	print("All points found")
	return
		
