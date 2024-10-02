extends Node

# Requirement 
# 	List of properties it wants
# 	A function to call when those properties exist (Returns true or false)

class_name Requirement

# Checks whether or not the the requirement is being met
var checker_function: Callable
# A list of properties that will be "checked" by the checker function
var desired_properties: Array[String]

func _init(desired: Array[String], checker: Callable) -> void:
	desired_properties = desired
	checker_function = checker
	
func check(props: Array[Property]) -> bool:
	# Ensure that all of the properties that are desired were passed into the function
	# One of the passed props don't need to exist in the desired props
	# For each desired prop, the passed props array must have a property with the same key
	var prop_exists: bool
	for desired_prop in desired_properties:
		# Assume it doesn't exist for convenience
		prop_exists = false
		for passed_prop in props:
			if (desired_prop == passed_prop.key):
				# It exists so the loop can end
				prop_exists = true
				break
		
		if (prop_exists == false):
			printerr("The desired property '%s' does not exist" % desired_prop)
	
	# If no errors occur, then the check function can be called
	return checker_function.call(props)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
