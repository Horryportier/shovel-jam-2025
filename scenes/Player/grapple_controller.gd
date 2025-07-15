extends Node2D

@onready var ray: RayCast2D = $RayCast2D
@onready var rope: Line2D = $Line2D

var launched = false
var target : Vector2

@onready var player:= get_parent()
@export var res_length = 2.0
@export var stifness = 10.0
@export var damping = 2.0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ray.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("GRAPPLE"):
		launch()
	if Input.is_action_just_released("GRAPPLE"):
		retract()
	if launched:
		handle_grapple(delta)
		

func launch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()
	
func retract():
	launched = false
	rope.hide()
	
func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	
	var displacement = target_dist - res_length
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stifness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damping * vel_dot * target_dir
		force = spring_force * damping
	player.velocity += force * delta
	update_rope()
	
func update_rope():
	rope.set_point_position(1, to_local(target))
	
