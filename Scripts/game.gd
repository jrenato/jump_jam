extends Node2D

@export var camera_scene: PackedScene
@export var platform_scene: PackedScene

var camera: GameCamera

@onready var player: Player = %Player
@onready var platforms_parent: Node2D = %PlatformsParent


func _ready() -> void:
	camera = camera_scene.instantiate() as GameCamera
	camera.setup_camera(player)
	add_child(camera)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func create_platform(location: Vector2) -> Platform:
	if not platform_scene:
		return null

	var platform: Platform = platform_scene.instantiate() as Platform
	platform.global_position = location
	platforms_parent.add_child(platform)
	return platform
