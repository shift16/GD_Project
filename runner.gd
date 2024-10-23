# Main Script

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
	
	

func has_enough_energy_req(props):
	if props["Energy"] > 0:
		return true
	else:
		return false

func is_colliding(props):
	if props["has_collided"]:
		return true
	else:
		return false

func has_no_energy(props):
	if props["Energy"] <= 0:
		return true
	else:
		return false

func has_no_health(props):
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

# The Random Guy
# : Health
# : Energy
# -> MoveRandomly (when energy)

# The Helper Boi
# : Health
# : Energy
# : HealingEffect
# -> MoveRandomly (no energy used)
# -> Give Energy (when collision)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Creates a rule that will move the SP
	var mover_random_rule = Rule.new("Mover")
	# mover_random_rule.add_requirement()
	mover_random_rule.attach_action(mover_random_action)
	
	

var time = 0
var ran_this = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time = time + delta
	
	if time > 1:
		time = time - 1
		$Dish.check_sps()
