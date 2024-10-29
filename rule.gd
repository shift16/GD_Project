class_name Rule

# Rule
# 	A list of requirements that need to be checked
# 	A list of actions to call when all of the requirements return true
# 	The scheduler must be able to know if the rule deletes an object and if it checks for the collision property

# An array of functions that will be called when the rule is "checked"
var requirements
# If true, the rule can delete SPs. If not, it can't delete.
var deletes
# If true, the rule checks if the collision property is met. If not, it doesn't check.
var checks_collision_prop
# The name of the rule
var name
# The action function that will be called when all of the rule's requirements are "met" (they return true)
var action
# An array of properties needed for the rule to be checked
var desired_properties

# Called when the Rule object is created
func _init(rule_name = "NOT DEFINED", new_desired_props = [], does_delete = false, does_check_collision_prop = false):
	# Initialize variables
	requirements = []
	action = null # Not initialized here
	desired_properties = null # Not initialized here
	
	if new_desired_props is Array:
		desired_properties = new_desired_props
	else:
		printerr("desired_properties must be an array of strings")
	
	if does_delete is bool:
		deletes = does_delete
	else:
		printerr("does_delete must be a boolean")

	if does_check_collision_prop is bool:
		checks_collision_prop = does_check_collision_prop
	else:
		printerr("checks_collision_prop must be a boolean")

	if rule_name is String:
		if rule_name != "NOT DEFINED":
			name = rule_name
		else:
			printerr("This rule was given no name")
	else:
		printerr("Rules can only be named with strings! Not " + type_string(typeof(rule_name)))

# Allows requirements to be added to the requirements array
func add_requirement(new_requirement):
	if new_requirement is Callable:
		requirements.append(new_requirement)
	else:
		printerr("Requirements must be functions (type Callable), not " + type_string(typeof(new_requirement)))

# Attaches the function that will be executed when all of the requirements are met (returns true)
func attach_action(new_action):
	if new_action is Callable:
		action = new_action
	else:
		printerr("Requirements must be functions (type Callable), not " + type_string(typeof(new_action)))

# Checks that all of the requirements are satisfied and executes the actions if they're satisfied
func check(sp, properties, dish):
	if desired_properties == null and action == null:
		printerr("An action was never attached to this rule")
		
	# Ensure all of the desired properties were passed into the check function
	# Assume true
	var has_desired_properties = true
	for desired_property in desired_properties:
		if desired_property not in properties:
			has_desired_properties = false
	
	if has_desired_properties == true:
		if not (sp is SimulatedPixel):
			printerr("The first parameter to the check function must be a Simulated Pixel (SP)")

		if properties is Dictionary:
			# Assume all of the requirements are satified
			# There is a silent "side effect" here. If the requirements array is empty, then the action will be called regardless
			var is_satisfied = true
			
			var previous_properties = properties.duplicate(true)
			
			for requirement in requirements:
				var is_met = requirement.call(properties)
				
				if is_met is bool:
					if is_met == false:
						# If a requirement is not satisfied, then set to false
						is_satisfied = false
						break
				else:
					printerr("Requirements should return only boolean values not " + type_string(typeof(is_met)))
			
			if is_satisfied == true:
				action.call(sp, properties, dish)
			elif is_satisfied == false:
				# Set the properties back to the values they were before
				for prop_name in previous_properties:
					properties[prop_name] = previous_properties[prop_name]
				# DEBUG
				print("Rule " + name + " was not satisfied for SP " + "SP's unique ID") # TODO Add something to identify SPs
