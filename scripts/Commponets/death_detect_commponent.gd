class_name DeathDetectorCommponent
extends Area2D

const DEATH_COLLISION_MASK: int = 4096

@onready var health_commponent: HealthCommponet = get_parent().get_node_or_null("HealthCommponet")


func _ready() -> void:
	collision_mask = DEATH_COLLISION_MASK
	body_entered.connect(_on_body_entered)
	health_commponent.hp_zero.connect(_on_hp_zero)

func _on_hp_zero() -> void:
	health_commponent.health = health_commponent.max_health
	Game.emit_player_died()

func _on_body_entered(_body: Node2D) -> void:
	Game.emit_player_died()
