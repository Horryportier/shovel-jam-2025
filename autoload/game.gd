extends Node

signal player_changed
signal player_died

var player: CharacterBody2D:
	set(val):
		if player != val:
			player = val
			player_changed.emit()
		

func set_player(new_player: CharacterBody2D) -> void:
	player = new_player

func get_player() -> CharacterBody2D:
	return player

func emit_player_died() -> void:
	player_died.emit()
