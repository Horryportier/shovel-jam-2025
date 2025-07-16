extends Node2D

@export var cycle_duration: float = 4

@onready var anim: AnimationPlayer= $AnimationPlayer
@onready var hitbox: Hitbox2D  = $Hitbox2D
@onready var timer: Timer = $Timer

var is_extended: bool

func _ready() -> void:
	timer.wait_time = cycle_duration
	timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	if is_extended:
		anim.play("extend")
	else: 
		anim.play("hide")
	is_extended = !is_extended
