extends Node2D

@export var camera_scene: PackedScene

var camera: GameCamera

@onready var player: Player = %Player


func _ready() -> void:
	camera = camera_scene.instantiate() as GameCamera
	camera.setup_camera(player)
	add_child(camera)


func _process(delta: float) -> void:
	pass
