class_name GameRoot
extends Node

signal level_loaded

@export_group("setup")
@export var ldtk_world: PackedScene
@export var dev_world: PackedScene
@export var is_dev: bool = false
@export var player_evolutions: Array[PackedScene]
@export var player_spawn_pos: Vector2
@export var start_evo: int = 0
@export var start_safe_point: int = 1
@export_group("visual")
@export var sky_color_ovre_time: Gradient
@export var sky_bg_color_ovre_time: Gradient
@export var sun_energy_curve: Curve
@export var day_length: float = 10

@onready var world: Node2D = %World
@onready var sun: DirectionalLight2D = %Sun
@onready var screen_tint: CanvasModulate = %ScreenTint


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
		var player: = player_evolutions[start_evo].instantiate()
		Game.current_spawn_point = start_safe_point
		world.add_child(player)
		Game.set_player(player)
		var start_pos: Marker2D = get_tree().get_first_node_in_group("PlayerStartPos")
		if is_instance_valid(start_pos):
			player.global_position = start_pos.global_position
		if start_safe_point != 1:
			_on_player_died()
	level_loaded.emit()
	Game.player_died.connect(_on_player_died)
	screen_tint.color = sky_color_ovre_time.sample(1)
	Bm.play()

func _process(delta: float) -> void:
	time += delta 
	if time / 60 >= day_length:
		time = 0
	var time_noramlized: = remap(time / 60, 0, day_length, 0, 1)
	var time_color: Color = (sky_color_ovre_time.sample(time_noramlized) * Game.brightness).clamp()
	var bg_time_color:  Color = sky_bg_color_ovre_time.sample(time_noramlized).clamp()
	screen_tint.color = time_color
	sun.energy = sun_energy_curve.sample(time_noramlized)
	sun.rotation =  deg_to_rad(180 + remap(time_noramlized, 0, 1 , 0, 360))
	RenderingServer.set_default_clear_color(bg_time_color)

func _on_player_died() -> void:
	var player = Game.get_player()
	var safe_points: =  get_tree().get_nodes_in_group("SafePoint")
	var filteled: = safe_points.filter(func (x: Node) -> bool: return x.safe_point_id == Game.current_spawn_point)
	if filteled.is_empty():
		player.global_position = get_tree().get_first_node_in_group("PlayerStartPos").global_position
	else:
		player.global_position = filteled.front().global_position
