extends Node

@export var ldtk_world: PackedScene
@export var dev_world: PackedScene
@export var is_dev: bool = false
@onready var world: Node2D = %World

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
