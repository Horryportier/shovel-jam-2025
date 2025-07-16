class_name OnDmgCommponent
extends Node

@onready var visual: Node2D = get_parent()
@export var health: HealthCommponet


var old_hp: int = 0

func _ready() -> void:
	health.hp_changed.connect(_on_hp_changed)
	old_hp = health.max_health

func _on_hp_changed(new_hp: int) -> void:
	if old_hp > new_hp:
		_animate_hurt()
	old_hp = new_hp

func _animate_hurt(): 
	var tween: = create_tween()
	tween.tween_property(visual, "modulate", Color.RED, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(visual, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	
