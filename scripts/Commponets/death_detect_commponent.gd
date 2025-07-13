class_name DeathDetectorCommponent
extends Area2D

const DEATH_COLLISION_MASK: int = 4096

func _ready() -> void:
	collision_mask = DEATH_COLLISION_MASK
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D) -> void:
	Game.emit_player_died()
