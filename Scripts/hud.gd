extends Control

@onready var score_label: Label = %ScoreLabel
@onready var pause_button: TextureButton = %PauseButton


func _ready() -> void:
	pause_button.pressed.connect(_on_pause_button_pressed)


func _on_pause_button_pressed() -> void:
	pass # Replace with function body.
