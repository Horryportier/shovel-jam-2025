extends Camera2D

var hooks: Array = []

func _ready() -> void:
	get_tree().get_first_node_in_group("Root").level_loaded.connect(_on_level_loaded)

func _on_level_loaded() -> void:
	hooks = get_tree().get_nodes_in_group("CameraHook")

func _find_closest_point() -> Vector2:
	var player = Game.get_player()
	if !is_instance_valid(player): 
		return	Vector2.ZERO
	var player_pos = player.global_position
	var closest: Vector2 = hooks.front().global_position if !hooks.is_empty() else Vector2.ZERO
	for marker: Marker2D in hooks:
		if closest.distance_to(player_pos) > marker.global_position.distance_to(player_pos):
			closest = marker.global_position
	return closest

func _process(_delta: float) -> void:
	global_position = _find_closest_point() 
