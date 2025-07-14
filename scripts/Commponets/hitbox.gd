class_name Hitbox2D
extends Area2D

signal hit_hurtbox(hurtbox: Hurtbox2D)

@onready var collision_shape: Variant = get_child(0)

@export var attack_info: int

@export var enable: bool = true:
	set(val):
		enable = val	
		if collision_shape:
			collision_shape.disabled = !enable

@export var damage_repeat  = false
@export var demage_repeat_timeout = 0.1

var _hurtboxes: Array[Hurtbox2D] = []


func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	if damage_repeat:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = demage_repeat_timeout
		timer.one_shot = false
		timer.timeout.connect(repeat_damage)
		timer.start()

func _on_area_entered(area: Area2D):
	if area is not Hurtbox2D:
		return
	if enable:
		hit_hurtbox.emit(area as Hurtbox2D)
	if damage_repeat:
		_hurtboxes.push_back(area)

func _on_area_exited(area: Area2D):
	var index = _hurtboxes.find(area)
	if index >= 0:
		_hurtboxes.remove_at(index)

func repeat_damage():
	if not enable:
		return 
	for hurtbox in _hurtboxes:
		hurtbox.take_dmg(hurtbox.get_final_dmg(attack_info))

