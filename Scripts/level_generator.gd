extends Node2D

@export var player: Player
@export var platform_scene: PackedScene = preload("res://Scenes/platform.tscn")
@export var platform_width: int = 136
@export var ground_y_offset: int = 62
@export var y_distance_between_platforms: int = 100
@export var start_level_size: int = 10
@export var threshold_margin_count: int = 6

var viewport_size: Vector2
var start_platform_y: int
var max_x_position: int
var generated_platform_count: int = 0

@onready var platforms_parent: Node2D = %PlatformsParent


func _ready() -> void:
	viewport_size = get_viewport_rect().size

	max_x_position = floor(viewport_size.x - platform_width)
	start_platform_y = viewport_size.y - floor(y_distance_between_platforms * 2)

	generate_level(start_platform_y, true, start_level_size)


func _process(delta: float) -> void:
	if not player:
		return

	var player_y: float = player.global_position.y
	var end_of_level_position: int = start_platform_y - (y_distance_between_platforms * generated_platform_count)
	var threshold: int = end_of_level_position + (y_distance_between_platforms * threshold_margin_count)
	if player_y <= threshold:
		generate_level(end_of_level_position, false, start_level_size)


func create_platform(location: Vector2) -> Platform:
	if not platform_scene:
		return null

	var platform: Platform = platform_scene.instantiate() as Platform
	platform.global_position = location
	platforms_parent.add_child(platform)
	return platform


func create_ground_platforms() -> void:
	var ground_platform_count: int = floor(viewport_size.x / platform_width) + 1

	for i in ground_platform_count:
		var ground_location: Vector2 = Vector2.ZERO
		ground_location.x = platform_width * i
		ground_location.y = viewport_size.y - ground_y_offset
		create_platform(ground_location)


func generate_level(start_y: float, generate_ground: bool, level_size: int) -> void:
	if generate_ground:
		create_ground_platforms()

	for i in level_size:
		var location: Vector2 = Vector2.ZERO
		location.x = randf_range(0, max_x_position)
		location.y = start_y - (y_distance_between_platforms * i)
		create_platform(location)
		generated_platform_count += 1
