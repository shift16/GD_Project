extends Node

# Test Code
func mover_action(sp, props, dish):
	var sp_id = dish.get_sp_id(sp)
	dish.move_sp(sp_id, dish.get_position_from_id(sp_id) + Vector2(1, 0))

var sp_1
var sp_2
var sp_3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Creates a rule that will move the SP
	var mover_rule = Rule.new("Mover")
	mover_rule.attach_action(mover_action)
	
	sp_1 = $Dish.create_sp(Vector2(5, 5))
	$Dish.activate_sp(sp_1.properties.INTERNAL_ID)
	
	sp_1.add_rule(mover_rule)
	
	sp_2 = $Dish.create_sp(Vector2(4, 5))
	$Dish.activate_sp(sp_2.properties.INTERNAL_ID)
	
	sp_3 = $Dish.create_sp(Vector2(3, 5))
	$Dish.activate_sp(sp_3.properties.INTERNAL_ID)


var time = 0
var ran_this = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time = time + delta
	
	if time > 1:
		time = time - 1
		$Dish.check_sps()
