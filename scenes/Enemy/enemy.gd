extends CharacterBody2D

@export var speed = 450
@export var player_detector_length = 100
@export var attack_delay: float
var direction = 1

@onready var left: RayCast2D = $LEFT
@onready var right: RayCast2D = $RIGHT
@onready var visual: Node2D = $Visual
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var player_detector: RayCast2D = $PlayerDetector
@onready var hitbox: Hitbox2D = $Hitbox2D
@onready var health: HealthCommponet = $HealthCommponet 

var can_attack: bool = true

var is_attacking: bool


func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)
	health.hp_zero.connect(queue_free)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
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
		visual.scale.x = 1
	if left.is_colliding():
		direction = -1
		visual.scale.x = -1
	if !anim.is_playing() and !velocity.is_zero_approx():
		anim.play("walk")
	elif !anim.is_playing() and velocity.is_zero_approx():
		anim.play("RESET")
	player_detector.target_position = Vector2(player_detector_length * direction, 0)
	hitbox.scale = Vector2(direction, 1)
	velocity.x = direction * speed 
	move_and_slide()
