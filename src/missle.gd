class_name MissleProjectile extends SpaceProjectile

const STEERING_FORCE: float = 30

var target: Asteroid
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func _on_timer_timeout() -> void:
	self.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		area.hit_points -= 5
		self.queue_free()

func get_steering_vector():
	var desired = (target.position - position).normalized() * speed
	return (desired - velocity).normalized() * STEERING_FORCE

func find_closest_asteroid() -> Asteroid:
	var children: Array[Node] = get_parent().get_children()
	var smallest_length: float = INF
	var closest_ast: Asteroid
	
	for node in children:
		if node is Asteroid:
			var dist: float = (node.position - position).length()
			if dist < smallest_length:
				smallest_length = dist
				closest_ast = node
				
	return closest_ast

func _physics_process(delta):
	if target != null:
		acceleration += get_steering_vector()
		velocity += acceleration * delta
		if velocity.length() > speed:
			velocity = velocity.normalized() * speed
		rotation = velocity.angle()
		position += velocity * delta
	else:
		target = find_closest_asteroid()
