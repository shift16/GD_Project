class_name Dish extends Node2D

# Holds a 2D array of simulated pixels
var grid = []

# The dish is empty by default
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
			array_to_append.append({ SP = "No SP Here", active = false })
		
		grid.append(array_to_append)

# Returns a simulated pixel or empty space at the given location
func get_pixel_from_position(position):
	if position is Vector2:
		var x = position.x
		var y = position.y
		
		# Ensure the positions are actually reachable
		assert(0 <= x and x < size[0], "The x value does not exist within the grid (The size is from 0 to grid_size_x - 1)")
		assert(0 <= y and y < size[1], "The x value does not exist within the grid (The size is from 0 to grid_size_x - 1)")
		
		return grid[x][y]
	else:
		printerr("Positions are 2D points on the dish (Grid)")

# Returns true if the position is valid, false otherwise
func is_valid_position(position):
	if position is Vector2:
		var x = position.x
		var y = position.y
		
		if (0 <= x and x < size[0]) and (0 <= y and y < size[1]):
			return true
		else:
			return false
