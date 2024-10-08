class_name SimulatedPixel extends Node2D

# The properties of an SP
var properties = {
	has_collided = false
}

# The rules of an SP
var rules = {}

# Adds a new property
func add_property(property_name, property_value):
	if property_name is String:
		properties[property_name] = property_value
	else:
		printerr("The name of a property must be a string")

# Removes an existing property
func remove_property(property_name):
	if property_name is String:
		if property_name in properties:
			properties.erase(property_name)
		else:
			# TODO Change "this" to the location of the simulated pixel on the Dish
			printerr("The property " + property_name + " does not exist in " + "this" + " SP") 
	else:
		printerr("The name of a property must be a string")

# Adds a new rule
func add_rule(new_rule):
	if new_rule is Rule:
		rules[new_rule.name] = new_rule
	else:
		printerr("Attempted to add a rule to " + "this" + " SP that is not of type Rule. Instead, it's type " + type_string(typeof(new_rule)))

# Removes an existing rule
func remove_rule(rule_name):
	if rule_name is String:
		if rule_name in rules:
			rules.erase(rule_name)
		else:
			# TODO Add a unique identifier for the SP
			printerr("The rule " + rule_name + " does not exist in this SP")

# Checks all of the rules
# (If all the requirement functions return true, call all of the action functions)
func check_rules():
	for rule in rules:
		rule.check(self, properties)
