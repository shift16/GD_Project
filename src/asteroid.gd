class_name Asteroid extends Area2D

@export var direction: Vector2 = Vector2.ZERO
@export var speed: float = 30

var hit_points: int
var damage: int
var spinning_rate: float = randf_range(0.5, 2)
var scale_factor: float = randf_range(0.75, 6)

func _ready() -> void:
	hit_points = int(scale_factor * 1.5)
	damage = scale_factor
	scale = Vector2(scale_factor, scale_factor)

func _process(delta: float) -> void:
	if hit_points < 0:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * delta * speed
	set_rotation_degrees(get_rotation_degrees() + spinning_rate)

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerShip:
		body.apply_damage(damage)
		self.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is SpaceProjectile or area is MissleProjectile:
		if hit_points <= 0:
			self.queue_free()
