extends Button

@onready var the_world: Timer = get_parent().get_parent().get_node('WorldGenerator')
@onready var the_player: PlayerShip = get_parent().get_parent().get_node("PlayerShip")

func _on_button_up() -> void:
	self.get_parent().visible = false
	the_world.start()
	the_player.start = true
