class_name Asteroid extends Area2D

@export var direction: Vector2 = Vector2.ZERO
@export var speed: float = 30

var hit_points: int
var damage: int
var spinning_rate: float = randf_range(0.5, 2)

func _ready() -> void:
	hit_points = 10
	damage = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * delta * speed
	set_rotation_degrees(get_rotation_degrees() + spinning_rate)


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerShip:
		body.hit_points -= damage
		self.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is SpaceProjectile:
		hit_points -= 2
		
		if hit_points <= 0:
			self.queue_free()
