class_name SpaceProjectile extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 250
var relative_unit: PlayerShip

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = position + (direction * delta * (speed + relative_unit.velocity.length()))

func _on_timer_timeout() -> void:
	self.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		area.hit_points -= 3
		self.queue_free()
