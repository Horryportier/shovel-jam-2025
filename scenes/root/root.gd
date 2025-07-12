extends Node


@export var ldtk_world: PackedScene

@onready var world: Node2D = %World

func _ready() -> void:
	var levels: =  ldtk_world.instantiate()
	levels.add_to_group("LdtkWorld")
	world.add_child(levels)
