class_name Dish extends Node2D

# Holds a 2D array of simulated pixels
var grid = []

# The dish is by default empty
var size = [0, 0]

@onready var SimulatedPixelScene = preload("res://simulated_pixel_scene.tscn")

# The dish should store the size of itself since it's a grid and should provide functions for creating SPs, moving SPs and deleting SPs
func _init(grid_size_x = 10, grid_size_y = 10, cell_size_x = 10, cell_size_y = 10):
	# Force the data type of all of the parameters
	assert(
		grid_size_x is int and 
		grid_size_y is int and 
		cell_size_x is int and 
		cell_size_y is int,
		"grid_size_x, grid_size_y, cell_size_x, and cell_size_y must be integers"
	)
	
	size = [grid_size_x, grid_size_y]
	for x in range(grid_size_x):
		var array_to_append = []
		for y in range(grid_size_y):
			array_to_append.append({ SP = SimulatedPixelScene.instantiate(), Active = false })
		
		grid.append(array_to_append)

# Returns a simulated pixel for the dish
func get_pixel_from_position(position):
	if position is Array:
		if position.size() == 2:
			var x_value = position[0]
			var y_value = position[1]
			# TODO Do logic here
			assert(0 <= x_value and x_value < size[0], "The x value does not exist within the grid (The size is from 0 to grid_size_x - 1)")
			assert(0 <= y_value and y_value < size[1], "The x value does not exist within the grid (The size is from 0 to grid_size_x - 1)")
		else:
			printerr("The size of the position")
