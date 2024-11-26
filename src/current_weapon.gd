extends RichTextLabel

@onready var the_ship: PlayerShip = get_parent().get_parent().get_node('PlayerShip')

func _process(delta: float) -> void:
	if the_ship != null:
		pass
