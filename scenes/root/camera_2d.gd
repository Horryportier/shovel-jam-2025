extends Camera2D

@export var smoothing_exponent: float = -20
@export var use_somoothing: bool = false

var hooks: Array = []

func _ready() -> void:
	get_tree().get_first_node_in_group("Root").level_loaded.connect(_on_level_loaded)

func _on_level_loaded() -> void:
	hooks = get_tree().get_nodes_in_group("CameraHook")
	global_position = _find_closest_point()

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

func _process(delta: float) -> void:
	if use_somoothing:
		global_position = lerp(global_position,  _find_closest_point(), 1.0 - exp(smoothing_exponent * delta))
	else:
		global_position = _find_closest_point()
