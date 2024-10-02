extends Node

class_name Rule

# Rule
# 	A list of requirements that need to be checked
# 	A list of actions to call when all of the requirements return true
# 	The scheduler must be able to know if the rule deletes an object and if it's checks for the collision property

# The list of requirements
var requirements: Array[Requirement]
# The list of actions to call
var actions: Array[Callable]
# Determines whether the rule can delete SPs
var can_delete: bool
# Determines whether the rule has a requirement that checks for the collided property
var checks_collided: bool
# A reference to the SP(Simulated Pixel) object
var SP: Node2D

func _init(req: Array[Requirement], acts: Array[Callable], checks_col: bool = false, can_del: bool = false) -> void:
	requirements = req
	actions = acts
	can_delete = can_del
	checks_collided = checks_col

# Returns two if the rule checked all of its requirements and performed its actions
func check(props: Array[Property]) -> bool:	
	for requirement in requirements:
		if requirement.check(props) == false:
			return false
	# This block of code will never run if one of the requirements aren't met	
	
	
	return true

# These two functions expose the properties of the rule object
func does_delete() -> bool:
	return can_delete

func checks_collision() -> bool:
	return checks_collided

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
