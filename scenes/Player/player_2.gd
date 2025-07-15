extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var grab_point: Marker2D = $GrabPoint
@onready var grab_area: Area2D = $GrabArea

var held_object: RigidBody2D = null
@export var throw_force: float = 800.0


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if Input.is_action_just_pressed("GRAB"):
		if held_object:
			release_object()
		else:
			try_grab()

	if Input.is_action_just_pressed("THROW") and held_object:
		throw_object()

	if held_object:
		held_object.global_position = grab_point.global_position
		held_object.linear_velocity = Vector2.ZERO
		held_object.rotation = 0


func try_grab():
	for body in grab_area.get_overlapping_bodies():
		if body.is_in_group("Pickable"):
			held_object = body
			held_object.freeze = true
			held_object.gravity_scale = 0
			held_object.linear_velocity = Vector2.ZERO
			held_object.collision_layer = 0
			held_object.collision_mask = 0
			return


func release_object():
	held_object.freeze = false
	held_object.gravity_scale = 1
	held_object.linear_velocity = Vector2.ZERO
	held_object.collision_layer = 1
	held_object.collision_mask = 1
	held_object = null


func throw_object():
	var world_pos = grab_point.global_position
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - world_pos).normalized()

	held_object.freeze = false
	held_object.gravity_scale = 1
	held_object.linear_velocity = Vector2.ZERO
	held_object.collision_layer = 1
	held_object.collision_mask = 1
	held_object.apply_impulse(direction * throw_force)

	held_object = null
