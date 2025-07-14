class_name HealthCommponet
extends Node

signal hp_changed(new_hp: int) 
signal hp_zero

@export var max_health: int

var health: int:
	set(val):
		if health != val:
			health = val
			hp_changed.emit(health)
			if health == 0:
				hp_zero.emit()

func _ready() -> void:
	health = max_health

func take_dmg(amonut: int) -> void:
	health = clamp(health - amonut, 0, max_health)

func heal(amount: int) -> void:
	health = clamp(health + amount, 0, max_health)
