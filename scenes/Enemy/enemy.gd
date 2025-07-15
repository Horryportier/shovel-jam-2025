extends CharacterBody2D

@export var speed = 450
var direction = 1

@onready var left: RayCast2D = $LEFT
@onready var right: RayCast2D = $RIGHT
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
	if right.is_colliding():
		direction = 1
		sprite.flip_h = true
	if left.is_colliding():
		direction = -1
		sprite.flip_h = false
		
	velocity.x = direction * speed 
	move_and_slide()
