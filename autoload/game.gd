extends Node

signal player_changed
signal player_died

var player: CharacterBody2D:
	set(val):
		if player != val:
			player = val
			player_changed.emit()
		

var current_spawn_point: int = 1

func get_evolution_scene(id: int) -> PackedScene:
	var root: GameRoot = get_tree().get_first_node_in_group("Root")
	if root.player_evolutions.size() <= id or id < 0:
		push_warning("failed to get_evolution")
		return null
	return root.player_evolutions[id]

func set_player(new_player: CharacterBody2D) -> void:
	player = new_player

func get_player() -> CharacterBody2D:
	return player

func emit_player_died() -> void:
	player_died.emit()
