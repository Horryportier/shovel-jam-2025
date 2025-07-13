extends Node

signal level_loaded

@export_group("setup")
@export var ldtk_world: PackedScene
@export var dev_world: PackedScene
@export var is_dev: bool = false
@export var player_scene: PackedScene
@export var player_spawn_pos: Vector2
@export_group("visual")
@export var sky_color_ovre_time: Gradient
@export var time_length: float

@onready var world: Node2D = %World
@onready var sun: DirectionalLight2D = %Sun
@onready var screen_tint: CanvasModulate = %ScreenTint



var player: CharacterBody2D

var time: float

func _ready() -> void:
	if is_dev:
		push_warning("game is in the dev mode if its suposed to be relese then you fucked up otherwise proceed")
		var levels: =  dev_world.instantiate()
		levels.add_to_group("Levels")
		world.add_child(levels)
	else: 
		var levels: =  ldtk_world.instantiate()
		levels.add_to_group("Levels")
		world.add_child(levels)
		player = player_scene.instantiate()
		player.add_to_group("Player")
		player.global_position = player_spawn_pos
		world.add_child(player)
		Game.set_player(player)
		var start_pos: Marker2D = get_tree().get_first_node_in_group("PlayerStartPos")
		if is_instance_valid(start_pos):
			player.global_position = start_pos.global_position
	level_loaded.emit()
	
	screen_tint.color = sky_color_ovre_time.sample(1)
