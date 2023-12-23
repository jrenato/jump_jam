extends Node2D

@export var camera_scene: PackedScene
@export var platform_scene: PackedScene
@export var ground_y_offset: int = 62

var camera: GameCamera
var viewport_size: Vector2

@onready var player: Player = %Player
@onready var platforms_parent: Node2D = %PlatformsParent


func _ready() -> void:
	viewport_size = get_viewport_rect().size

	camera = camera_scene.instantiate() as GameCamera
	camera.setup_camera(player)
	add_child(camera)

	create_ground_platforms()


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


func create_ground_platforms() -> void:
	var platform_width: int = 136
	var ground_platform_count: int = floor(viewport_size.x / platform_width) + 1

	for i in ground_platform_count:
		var ground_location: Vector2 = Vector2(platform_width * i, viewport_size.y - ground_y_offset)
		create_platform(ground_location)
