extends Node2D

@export var up_force: float
@export var on_time: float

@onready var area:  Area2D = $Area2D
@onready var particles: GPUParticles2D  = $GPUParticles2D

var bodies: Array

var is_on: bool = true

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	start_loop()
	
func start_loop() -> void:
	is_on = !is_on
	particles.emitting = is_on
	get_tree().create_timer(on_time).timeout.connect(start_loop)

func _physics_process(delta: float) -> void:
	if !is_on:
		return
	for body: CharacterBody2D in bodies:
		body.velocity.y += up_force * delta
		body.move_and_slide()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		bodies.append(body)

func _on_body_exited(body: Node2D) -> void:
	bodies.erase(body)
