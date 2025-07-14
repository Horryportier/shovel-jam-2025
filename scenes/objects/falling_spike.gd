extends RigidBody2D

const MAX_LIFETIME: float = 10

func _ready() -> void:
	get_tree().create_timer(MAX_LIFETIME).timeout.connect(queue_free)
	get_tree().create_timer(0.5).timeout.connect(_on_invincibility_timeout)
	

func _on_invincibility_timeout() -> void:
	contact_monitor = true
	max_contacts_reported = 100
	body_entered.connect(func (_body: Node2D) -> void: await get_tree().create_timer(0.1).timeout; queue_free())
