extends Node2D

@export var camera_scene: PackedScene

var camera: GameCamera

@onready var player: Player = %Player


func _ready() -> void:
	create_camera()


func create_camera() -> void:
	camera = camera_scene.instantiate() as GameCamera
	camera.setup_camera(player)
	add_child(camera)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
