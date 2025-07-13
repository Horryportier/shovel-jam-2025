class_name LevelData
extends Node

signal level_beaten

signal level_started


@export var is_level_beaten: bool:
	set(val):
		is_level_beaten = val
		if is_level_beaten:
			level_beaten.emit()

@export var _entities: Array

func _ready() -> void:
	pass


