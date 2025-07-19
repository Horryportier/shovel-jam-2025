extends Area2D

@export var next_evolution: int
@export var safe_point: int
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var evo: AudioStreamPlayer2D = $Evo


var player: CharacterBody2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	if is_instance_valid(player):
		player.global_position = global_position

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var scene: = Game.get_evolution_scene(next_evolution)
		if scene == null:
			return
		player = Game.get_player()
		anim.play("transform")
		evo.play()
		await anim.animation_finished
		var new_player: CharacterBody2D = scene.instantiate()
		new_player.global_position = global_position
		get_tree().get_first_node_in_group("World").add_child(new_player)
		var old_player = Game.player
		Game.set_player(new_player)
		player = Game.get_player()
		old_player.queue_free.call_deferred()
		Game.current_spawn_point = safe_point
		queue_free()
