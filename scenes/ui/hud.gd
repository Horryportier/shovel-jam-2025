extends Control

@onready var health_bar: TextureProgressBar = %HealthBar

var player: CharacterBody2D
var max_health: int

func _ready() -> void:
	Game.player_changed.connect(_on_player_changed)

func _on_player_changed() -> void:
	player = Game.get_player()
	var health_conponent: HealthCommponet = player.get_node_or_null("HealthCommponet")
	if is_instance_valid(health_conponent):
		max_health = health_conponent.max_health
		health_bar.value = remap(health_conponent.health, 0, max_health, 0, 100) 
		health_conponent.hp_changed.connect(_on_hp_changed)


func _on_hp_changed(new_hp: int) -> void:
	var new_vaule: = remap(new_hp, 0, max_health, 0, 100) 
	create_tween().tween_property(health_bar, "value", new_vaule, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	

