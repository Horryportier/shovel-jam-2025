
extends Camera2D

var target_position = Vector2()

func _process(delta):
	var closest_hook = null
	var shortest_distance = INF

	for hook in get_tree().get_nodes_in_group("CameraHook"):
		var dist = hook.global_position.distance_to(global_position)
		if dist < shortest_distance:
			shortest_distance = dist
			closest_hook = hook

	if closest_hook:
		target_position = closest_hook.global_position
		global_position = lerp(global_position, target_position, delta * 3)
