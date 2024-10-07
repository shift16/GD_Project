class_name Rule

# Rule
# 	A list of requirements that need to be checked
# 	A list of actions to call when all of the requirements return true
# 	The scheduler must be able to know if the rule deletes an object and if it checks for the collision property

# An array of functions that will be called when the rule is "checked"
var requirements = []
# An array of functions that will be called when all of the rule's requirements are "met" (they return true)
var actions = []
# If true, the rule can delete SPs. If not, it can't delete.
var deletes = false
# If true, the rule checks if the collision property is met. If not, it doesn't check.
var checks_collision_prop = false
# The name of the rule
var name

# Called when the Rule object is created
func _init(rule_name = "NOT DEFINED", does_delete = false, does_check_collision_prop = false):
	if does_delete is bool:
		deletes = does_delete
	if does_check_collision_prop is bool:
		checks_collision_prop = does_check_collision_prop

	if rule_name is String:
		if rule_name != "NOT DEFINED":
			name = rule_name
		else:
			printerr("This rule was given no name")
	else:
		printerr("Rules can only be named with strings! Not " + type_string(typeof(rule_name)))
		
# TODO Add function that allow requirements to be added

# Allows requirements to be added to the requirements array
func add_requirement(new_requirement):
	if new_requirement is Callable:
		requirements.append(new_requirement)
	else:
		printerr("Requirements must be functions (type Callable), not " + type_string(typeof(new_requirement)))

# Allow actions to be added to the actions array
func add_action(new_action):
	if new_action is Callable:
		actions.append(new_action)
	else:
		printerr("Requirements must be functions (type Callable), not " + type_string(typeof(new_action)))
