extends Timer

var random_handler = RandomNumberGenerator.new()
var asteroid_scene: PackedScene = preload("res://scenes/asteroid.tscn")
var parent_node: Node2D
var player_ship: PlayerShip
var player_camera: Camera2D
const SPAWN_MAX: float = 1100
const SPAWN_MIN: float = 900

var asteroids: Array[Asteroid] = []

func _ready() -> void:
	parent_node = get_parent()
	player_ship = parent_node.get_node("PlayerShip")
	player_camera = player_ship.get_node("Camera2D")

func construct_asteroid() -> void:
	var aster: Asteroid = asteroid_scene.instantiate()
	var random_spawn: Vector2 = Vector2(
		random_handler.randf_range(SPAWN_MIN, SPAWN_MAX), 
		random_handler.randf_range(SPAWN_MIN, SPAWN_MAX))
	
	var rand_x_is_neg: int = random_handler.randi_range(1, 2)
	var rand_y_is_neg: int = random_handler.randi_range(1, 2)
	
	if rand_x_is_neg == 1:
		random_spawn *= Vector2(-1, 1)
	
	if rand_y_is_neg == 1:
		random_spawn *= Vector2(1, -1)
	
	aster.direction = Vector2(
		random_handler.randf_range(0, 1), 
		random_handler.randf_range(0, 1))

	aster.speed = randf_range(30, 200)
	
	aster.global_position = player_ship.position + random_spawn
	parent_node.add_child(aster)

func _on_timeout() -> void:
	construct_asteroid()
