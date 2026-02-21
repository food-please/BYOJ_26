extends CharacterBody3D

## The maximum speed the player can move at in meters per second.
@export_range(3.0, 12.0, 0.1) var max_speed := 6.0
## Controls how quickly the player accelerates and turns on the ground.
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0

@onready var _sprite: = $AnimatedSprite3D as AnimatedSprite3D


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input_vector.x, 0.0, input_vector.y)
	
	var dir_suffix: = Directions.vector_to_direction(direction)
	
	if is_equal_approx(direction.length(), 0):
		_sprite.play("idle")
	
	else:
		_sprite.play("move_" + dir_suffix)
	
	var desired_ground_velocity := max_speed * direction
	var steering_vector := desired_ground_velocity - velocity
	steering_vector.y = 0.0
	# We limit the steering amount to ensure the velocity never overshoots the
	# desired velocity.
	var steering_amount: float = min(steering_factor * delta, 1.0)
	velocity += steering_vector * steering_amount
	
	const GRAVITY := 40.0 * Vector3.DOWN
	velocity += GRAVITY * delta
	
	move_and_slide()
