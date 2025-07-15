extends CharacterBody2D

@export var speed = 450
@export var player_detector_length = 100
@export var attack_delay: float
var direction = 1

@onready var left: RayCast2D = $LEFT
@onready var right: RayCast2D = $RIGHT
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var player_detector: RayCast2D = $PlayerDetector
@onready var hitbox: Hitbox2D = $Hitbox2D


var can_attack: bool = true

var is_attacking: bool


func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_name: String) -> void:
	is_attacking = false
	get_tree().create_timer(attack_delay).timeout.connect(func () -> void: can_attack = true)

func _physics_process(_delta: float) -> void:
	if player_detector.is_colliding() and can_attack:
		is_attacking = true
		can_attack = false
		print("attacking")
		velocity = Vector2.ZERO
		move_and_slide()
		anim.play("attack")
	if is_attacking: 
		return
	if !is_on_floor():
		velocity += get_gravity() 
	if right.is_colliding():
		direction = 1
		sprite.flip_h = true
	if left.is_colliding():
		direction = -1
		sprite.flip_h = false
		
	player_detector.target_position = Vector2(player_detector_length * direction, 0)
	hitbox.scale = Vector2(direction, 1)
	velocity.x = direction * speed 
	move_and_slide()
