extends RigidBody2D


@onready var hitbox: Hitbox2D = $Hitbox2D


func _physics_process(_delta: float) -> void:
	hitbox.enable = !linear_velocity.is_zero_approx() and get_parent().is_in_group("World")
