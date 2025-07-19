extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
#@onready var health: HealthCommponet = $HealthCommponet

@export var speed: float = 160
@export var jump_velocity: float = -320
@export var cayote_jump: float = 0.1

var can_jump: bool = true

var cayote_timer: SceneTreeTimer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if cayote_timer == null:
			cayote_timer = get_tree().create_timer(cayote_jump)
			cayote_timer.timeout.connect(func () -> void: can_jump = false)
		velocity += get_gravity() * delta
	else: 
		if cayote_timer != null:
			cayote_timer = null
			can_jump = true
	# Handle jump.
	if Input.is_action_just_pressed("JUMP") and can_jump:
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if velocity.is_zero_approx():
		anim.play("idle")
	else:
		anim.play("walk")
	anim.flip_h = velocity.x < 0
	move_and_slide()
