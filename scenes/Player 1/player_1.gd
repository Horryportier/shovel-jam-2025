extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0

@onready var collision_shape = $CollisionShape2D  # Update this path if needed!

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var direction := Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Crouch logic
	if Input.is_action_pressed("CROUCH"):  # Replace with your own "CROUCH" action, like "crouch"
		# Rotate to horizontal
		collision_shape.rotation = deg_to_rad(90)
	else:
		# Reset to vertical
		collision_shape.rotation = deg_to_rad(0)

	move_and_slide()
