extends CharacterBody2D

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var grapple_controller: Node2D = $GrappleController



@export var speed: float = 320
@export var jump_velocity: float = -640
@export var crouch_jump_ratio: float = 1.5
@export var cayote_jump: float = 0.1
@export var gravity: float = 1600.0

var can_jump: bool = true
var cayote_timer: SceneTreeTimer
var is_crouching: bool = false

var ACCELERATION = 0.1
const DECELERATION = 0.1



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if cayote_timer == null:
			cayote_timer = get_tree().create_timer(cayote_jump)
			cayote_timer.timeout.connect(func () -> void: can_jump = false)
		velocity.y += gravity * delta
	else:
		if cayote_timer != null:
			cayote_timer = null
		can_jump = true

	if Input.is_action_just_pressed("JUMP") and can_jump:
		if is_crouching:
			velocity.y = jump_velocity * crouch_jump_ratio
		else:
			velocity.y = jump_velocity

	var direction := Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = lerp (velocity.x, direction * speed, ACCELERATION)
	else:
		velocity.x = lerp (velocity.x, 0.0, DECELERATION)
		#velocity.x = move_toward(velocity.x, 0, speed)

	is_crouching = Input.is_action_pressed("CROUCH")
	if is_crouching:
		collision_shape.rotation = deg_to_rad(90)
	else:
		collision_shape.rotation = deg_to_rad(0)

	move_and_slide()
