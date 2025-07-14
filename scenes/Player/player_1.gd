extends CharacterBody2D


@onready var collision_shape = $CollisionShape2D  # Update this path if needed!

@export var speed: float = 320
@export var jump_velocity: float = -640
@export var crouch_jump_ratio: float = 1.5
@export var cayote_jump: float = 0.1

var can_jump: bool = true

var cayote_timer: SceneTreeTimer

var is_crouching: bool 

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		if cayote_timer == null:
			cayote_timer = get_tree().create_timer(cayote_jump)
			cayote_timer.timeout.connect(func () -> void: can_jump = false)
		velocity += get_gravity() * delta
	else: 
		if cayote_timer != null:
			cayote_timer = null
			can_jump = true	# Jump

	if Input.is_action_just_pressed("JUMP") and can_jump:
		if is_crouching:
			velocity.y = jump_velocity * crouch_jump_ratio
		else:
			velocity.y = jump_velocity

	# Movement
	var direction := Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	is_crouching = Input.is_action_pressed("CROUCH")
	if Input.is_action_pressed("CROUCH"):  
		collision_shape.rotation = deg_to_rad(90)
	else:
		# Reset to vertical
		collision_shape.rotation = deg_to_rad(0)

	move_and_slide()
