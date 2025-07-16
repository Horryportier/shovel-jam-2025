extends CharacterBody2D

@onready var grab_point: Marker2D = $GrabPoint
@onready var grab_area: Area2D = $GrabArea
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D 

var held_object: RigidBody2D = null
@export var throw_force: float = 800.0

@onready var world: Node2D = get_tree().get_first_node_in_group("World")


@export var speed: float = 320
@export var jump_velocity: float = -640
@export var crouch_jump_ratio: float = 1.5
@export var cayote_jump: float = 0.1

var can_jump: bool = true

var cayote_timer: SceneTreeTimer

var is_crouching: bool 

func _physics_process(delta):
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
	if velocity.is_zero_approx():
		anim.play("idle")
	else:
		anim.play("walk")
	anim.flip_h = velocity.x < 0	
	move_and_slide()
	if Input.is_action_just_pressed("GRAB"):
		if held_object:
			release_object()
		else:
			try_grab()

	if Input.is_action_just_pressed("THROW") and held_object:
		throw_object()



func try_grab():
	for body in grab_area.get_overlapping_bodies():
		if body.is_in_group("Pickable"):
			held_object = body
			held_object.reparent(grab_point, false)
			held_object.global_position = grab_point.global_position
			held_object.freeze = true
			held_object.linear_velocity = Vector2.ZERO
			return


func release_object():
	held_object.reparent(world)
	held_object.freeze = false
	held_object = null


func throw_object():
	var world_pos = grab_point.global_position
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - world_pos).normalized()

	held_object.freeze = false
	held_object.reparent(world)
	held_object.apply_impulse(direction * throw_force)

	held_object = null
