extends Node2D

@export var spawn_timer: float
@export var spike_scene: PackedScene

@onready var  timer: Timer  = $Timer
@onready var  sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	timer.wait_time = spawn_timer
	timer.timeout.connect(_on_timer_time_out)


func _on_timer_time_out() -> void:
	var world: = get_tree().get_first_node_in_group("World")
	var spike: = spike_scene.instantiate()
	spike.global_position = global_position
	world.add_child(spike)

