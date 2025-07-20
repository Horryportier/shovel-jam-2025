extends Control

@export var volume_curve: Curve
@export var brightness_curve: Curve
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var exit_button: TextureButton  = %Exitbutton

@onready var settings_parent: Control  = %Settings
@onready var volume_slider: Slider = %VolumeSlider
@onready var brightness_slider: Slider  = %BrightnessSlider

var player: CharacterBody2D
var max_health: int

func _ready() -> void:
	Game.player_changed.connect(_on_player_changed)
	volume_slider.value_changed.connect(_on_volumen_slider_value_changed)
	brightness_slider.value_changed.connect(_on_brightness_slider_value_changed)
	exit_button.pressed.connect(func () -> void: get_tree().quit())
	settings_parent.visible = false
	volume_slider.value = 75
	brightness_slider.value = 25

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("SETTINGS_TOGGLE"):
		settings_parent.visible = !settings_parent.visible
	
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

func _on_volumen_slider_value_changed(new_value: float) -> void:
	var db: = remap(volume_curve.sample(remap(new_value, 0, 100, 0, 1)), 0, 1, -80, 6)
	AudioServer.set_bus_volume_db(0, db)

func _on_brightness_slider_value_changed(new_value: float) -> void:
	Game.brightness = remap(brightness_curve.sample(remap(new_value, 0, 100, 0, 1)), 0, 1, 1, 3)
