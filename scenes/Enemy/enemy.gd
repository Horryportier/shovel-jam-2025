extends CharacterBody2D

@export var speed = 70
var direction = 1

@onready var left: RayCast2D = $LEFT
@onready var right: RayCast2D = $RIGHT
@onready var sprite: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	if right.is_colliding():
		direction = -1
		sprite.flip_h = true
	if left.is_colliding():
		direction = 1
		sprite.flip_h = false
		
	position.x += direction * speed * delta 
