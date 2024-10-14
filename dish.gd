class_name Dish extends Node2D

# Used for generating unique IDs for each SP
var created_sp_id

# Holds a 2D array of simulated pixels
var grid

# A dictionary that keeps track of each SPs cell
var sp_cell_tracker

# The size of the dish
var size

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
	
	# Initialize the variables
	grid = []
	sp_cell_tracker = {}
	created_sp_id = 0
	size = [grid_size_x, grid_size_y]
	for x in range(grid_size_x):
		var array_to_append = []
		for y in range(grid_size_y):
			array_to_append.append({})
		
		grid.append(array_to_append)


# Returns true if the cell is valid, false otherwise
func is_valid_position(position):
	if position is Vector2:
		var x = position.x
		var y = position.y
		
		if (0 <= x and x < size[0]) and (0 <= y and y < size[1]):
			return true
		else:
			return false

# Returns a simulated pixel or empty space at the given location
func get_sps_from_position(position, and_inactive = false):
	assert(and_inactive is bool, "and_inactive must of type bool")
	
	if position is Vector2:
		var x = position.x
		var y = position.y
		
		# Ensure the cells are actually reachable
		if is_valid_position(position):
			if and_inactive:
				return grid[x][y]
			else:
				var return_dict = {}
				var cell_sp_dict = grid[x][y]
				
				for key in cell_sp_dict.keys():
					if cell_sp_dict[key].active:
						return_dict[key] = cell_sp_dict[key]
				
				return return_dict
		else:
			printerr("The position [" + position.x + " " + position.y + " does not exist within this dish")
			# TODO Add an identifier for each dish
	else:
		printerr("Cells must be of type Vector2")

# Returns the cell of the SP based on its ID
func get_cell(sp_id):
	assert(sp_id is String, "The ID of an SP must be a string")
	if sp_cell_tracker.has(sp_id):
		return sp_cell_tracker[sp_id]
	else:
		printerr("The given ID " + sp_id + " does not exist within this dish")

# Checks to see whether an SP is already at the given cell
func cell_occupied(cell):
	assert(cell is Vector2, "Cells must be of type Vector2")
	
	if is_valid_position(cell):
		var cell_content = get_sps_from_position(cell)
		
		if cell_content.size() > 0:
			return true
		else:
			return false
	else:
		printerr("The cell [" + cell.x + " " + cell.y + " is not a valid cell")

# Removes and SP from the dish
func remove_sp(sp_id):
	assert(sp_id is String, "SP IDs must be of type String")
	assert(sp_cell_tracker.has(sp_id), "The given ID " + sp_id + " does not exist within this dish")
	
	var x = sp_cell_tracker[sp_id].x
	var y = sp_cell_tracker[sp_id].y
	var sps_cell = grid[x][y]
	
	sps_cell.erase(sp_id)
	
# Creates a dormant SP and returns it
func create_sp(position):
	assert(position is Vector2, "Positions must be of type Vector2")
	assert(is_valid_position(position), "The position [" + position.x + " " + position.y + "] is invalid")
	# Create the SP
	var new_sp_scene = SimulatedPixelScene.instantiate() # ALLRT This may not work as intended
	var sp = new_sp_scene.get_node(".")
	
	# Update the internal ID system
	created_sp_id = created_sp_id + 1
	var sp_id = created_sp_id
	sp.properties.INTERNAL_ID = sp_id
	
	# Update tracker and Grid
	sp_cell_tracker[sp_id] = position
	grid[position.x][position.y][sp_id] = { "sp": sp, "active": false }
	
	return sp

# Activates the SP (should be called after create_sp)
func activate_sp(sp_id):
	assert(sp_id is String, "SP IDs must be of type String")
	assert(sp_cell_tracker.has(sp_id), "The given ID " + sp_id + " does not exist within this dish")
	
	var sps_position = sp_cell_tracker[sp_id]
	assert(is_valid_position(sps_position), "The position [" + sps_position.x + " " + sps_position.y + "] is invalid")
	
	var sp_list = get_sps_from_position(position, true)
	var sp_to_activate = sp_list[sp_id]
	sp_to_activate.active = true
	
# Moves an SP to another postion
func move_sp(sp_id, new_position):
	assert(new_position is Vector2, "Cells must be of type Vector2")
	assert(sp_id is String, "SP IDs must be of type String")
	assert(sp_cell_tracker.has(sp_id), "The given ID " + sp_id + " does not exist within this dish")
	
	if is_valid_position(new_position):
		# Check the new cell for collisions
		var old_x = sp_cell_tracker[sp_id].x
		var old_y = sp_cell_tracker[sp_id].y
		var old_cell = grid[old_x][old_y]
		
		var moving_sp = old_cell[sp_id]
		
		var moved_to_x = new_position.x
		var moved_to_y = new_position.y
		var moved_to_cell = grid[moved_to_x][moved_to_y]
		
		# Update grid and tracker
		sp_cell_tracker[sp_id] = new_position
		old_cell.erase(sp_id) # Removes the SP from the old cell's list of SPs
		moved_to_cell[sp_id] = moving_sp # Adds the SP to other cell's list of SPs
			
		if cell_occupied(new_position):
			# Collision has occurred!	
			for sp in moved_to_cell:
				sp.properties.has_collided = true
		
	else:
		printerr("The cell [" + new_position.x + " " + new_position.y + " does not exist within this dish")
		# TODO Add an identifier for each dish
