extends Node
# Main Script

# Some predefined actions
func move_randomly_action(sp, props, dish):
	var sp_id = dish.get_sp_id(sp)
	var current_position = dish.get_position_from_id(sp_id)
	var random_direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	
	while !dish.is_valid_position(current_position + random_direction):
		random_direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	
	dish.move_sp(sp_id, current_position + random_direction)

func attack_other_action(sp, props, dish):
	var sp_id = dish.get_sp_id(sp)
	var current_position = dish.get_position_from_id(sp_id)
	var other_sps = dish.get_sps_from_position(current_position)
	var damage = props["Damage"]
	
	for colliding_sp in other_sps.values():
		# Make sure the SP doesn't attack itself
		if dish.get_sp_id(colliding_sp) != sp_id:
			var sp_props = colliding_sp.properties
			sp_props["Health"] = sp_props["Health"] - damage

func die_action(sp, props, dish):
	dish.remove_sp(dish.get_sp_id(sp))

func give_energy_action(sp, props, dish):
	var sp_id = dish.get_sp_id(sp)
	var current_position = dish.get_position_from_id(sp_id)
	var other_sps = dish.get_sps_from_position(current_position)
	var energy_to_give = props["EnergyGiveAmount"]
	
	for colliding_sp in other_sps.values():
		# Make sure the SP doesn't give energy to itself
		if dish.get_sp_id(colliding_sp) != sp_id:
			var sp_props = colliding_sp.properties
			sp_props["Energy"] = sp_props["Energy"] + energy_to_give

func lose_health_when_no_energy(sp, props, dish):
	props["Health"] = props["Health"] - 1
	props["Energy"] = props["Energy"] + 5

# Some predefined requirements
func has_enough_energy_req(props):
	if props["Energy"] > 0:
		return true
	else:
		return false

func is_colliding_req(props):
	if props["has_collided"]:
		return true
	else:
		return false

func has_no_energy_req(props):
	if props["Energy"] <= 0:
		return true
	else:
		return false

func has_no_health_req(props):
	if props["Health"] <= 0:
		return true
	else:
		return false


# I want to create 3 SPs
# The Killer
# The Random Guy
# The Helper Boi

# The Killer
# : Health
# : Damage
# : Energy
# -> ApplyDamage (when collision)
# -> MoveRandomly (when energy)
# -> DieWhenNoHealth (requires health)

# The Random Guy
# : Health
# : Energy
# -> MoveRandomly (when energy)
# -> DieWhenNoHealth (requires health)

# The Helper Boi
# : Health
# : Energy
# : EnergyGiveAmount
# -> MoveRandomly (no energy used)
# -> Give Energy (when collision)
# -> DieWhenNoHealth (requires health)

func createKillerSP(dish, position):
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create the rules
	var MoveRandomly = Rule.new("MoveRandomly", ["Energy"])
	MoveRandomly.add_requirement(has_enough_energy_req)
	MoveRandomly.attach_action(move_randomly_action)
	
	var ApplyDamage = Rule.new("ApplyDamage", ["Damage"], false, true)
	ApplyDamage.add_requirement(is_colliding_req)
	ApplyDamage.attach_action(attack_other_action)
	
	var GiveEnergy = Rule.new("GiveEnergy", ["EnergyGiveAmount"], false, true)
	GiveEnergy.add_requirement(is_colliding_req)
	GiveEnergy.attach_action(give_energy_action)
	
	var DieWhenNoHealth = Rule.new("DieWhenNoHealth", ["Health"], true)
	DieWhenNoHealth.add_requirement(has_no_health_req)
	DieWhenNoHealth.attach_action(die_action)
	
	var LoseHealthWhenNoEnergy = Rule.new("LoseHealthWhenNoEnergy", ["Energy", "Health"])
	LoseHealthWhenNoEnergy.add_requirement(has_no_energy_req)
	LoseHealthWhenNoEnergy.attach_action(lose_health_when_no_energy)
	
	# Create the Toolbox
	var killerToolboxItem = 
	 (createKillerSP, "Killer Cell", Color.RED)
	$Toolbox/HorizontalContainer.add_child(killerToolboxItem)

var time = 0
var ran_this = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time = time + delta
	
	if time > 1:
		time = time - 1
		$Dish.check_sps()
