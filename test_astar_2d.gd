extends Node2D

var astar: AStar2D
var planet_arr = []
var points_arr = []
var drone_arr = []
var drone_points = []

func _ready():
	astar = AStar2D.new()
	planet_arr = get_tree().get_nodes_in_group("planets_group")
	for planet in planet_arr:
		points_arr.append(planet.position)
	
	drone_arr = get_tree().get_nodes_in_group("drones_group")
	var drone_points = []
	for drone in drone_arr:
		drone_points.append(to_global(drone.position))
		
	
	print("----Planet Points----")
	print(points_arr)
	print("----Drone Points----")
	print(drone_points)
	
	var idx = 1
	for point in points_arr:
		astar.add_point(idx, point)
		idx += 1
	for drone in drone_arr:
		astar.add_point(idx, drone.position)
		if drone.astar_idx == 0:
			drone.astar_idx = idx
		idx += 1
	
	astar.connect_points(1, 2)
	astar.connect_points(2, 3)
	
	print("path of 1-2: ", astar.get_point_path(1,2))
	print("path of 2-3: ", astar.get_point_path(2,3))
	print("path of 1-3: ", astar.get_point_path(1,3))
	
#	print("-----After Disconnect------")
#
#	astar.disconnect_points(1, 2)
#	astar.disconnect_points(2, 3)
#	astar.connect_points(1, 3)
#
#	print("path of 1-2: ", astar.get_point_path(1,2))
#	print("path of 2-3: ", astar.get_point_path(2,3))
#	print("path of 1-3: ", astar.get_point_path(1,3))

	print("-----Remove Middle------")
	
	astar.remove_point(2)
	
	print("path of 1-2: ", astar.get_point_path(1,2))
	print("path of 2-3: ", astar.get_point_path(2,3))
	print("path of 1-3: ", astar.get_point_path(1,3))
	
	
	
	print("-----Check movement-----")
	
func _process(delta):
	drone_arr = get_tree().get_nodes_in_group("drones_group")
	for drone in drone_arr:
		if drone.obj_selected:
			for point in astar.get_point_connections(drone.astar_idx):
				astar.disconnect_points(drone.astar_idx, point)
			astar.remove_point(drone.astar_idx)
		else:
			astar.add_point(drone.astar_ix, drone.position)
			
			
			
	#Okay now i get it
	#Get all points and assigned index value in a dictionary
	#everytime a point is moved, disconnect all connections first
	#remove the moving point and add again once it stops
	#get list of lines
	#if line exists, connect the two points' indexes
	#if line gets deleted, disconnect the two points' indexes
		
