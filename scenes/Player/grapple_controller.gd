extends Node2D

@onready var ray: RayCast2D = $RayCast2D
@onready var rope: Line2D = $Line2D
@onready var player := get_parent()

@onready var claw: Sprite2D = $Claw
@onready var grab_point: StaticBody2D = get_tree().get_first_node_in_group("GrabPoint")

@export var res_length: float = 2.0
@export var stifness: float = 10.0
@export var damping: float = 2.0

var launched: bool = false
var target: Vector2


var target_initial_velocity: Vector2 = Vector2.ZERO

var force: Vector2

func _process(delta: float) -> void:
	ray.look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("GRAPPLE"):
		launch()

	if Input.is_action_just_released("GRAPPLE"):
		player.move_and_slide()
		retract()

	if launched:
		handle_grapple(delta)
	else:
		claw.global_position = ray.global_position
	update_rope()


func launch():
	if ray.is_colliding():
		target_initial_velocity = player.velocity
		launched = true
		target = ray.get_collision_point()
		claw.global_position = target
		rope.show()


func retract():
	launched = false
	rope.hide()


func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)

	var displacement = target_dist - res_length

	if displacement > 0:
		var spring_force_magnitude = stifness * displacement
		var spring_force = target_dir * spring_force_magnitude

		var velocity_along_rope = player.velocity.dot(target_dir)
		var damping_force = -damping * velocity_along_rope * target_dir

		force = spring_force + damping_force 

	player.velocity +=  force * delta
	player.move_and_slide()

func update_rope():
	if launched:
		rope.set_point_position(0, ray.position)
		rope.set_point_position(1, player.to_local(target))
	else:
		rope.set_point_position(0, Vector2.ZERO)
		rope.set_point_position(1, Vector2.ZERO)
