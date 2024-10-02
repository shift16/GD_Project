extends Node

var properties: Array[Property] # Holds all of the properties 
var rules: Array = [Rule] # Holds all of the rule objects

	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.color = Color.BLUE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
