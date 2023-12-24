extends Node2D

@export var camera_scene: PackedScene
@export var player_scene: PackedScene
@export var player_spawn_y_offset: float = 135.0

var camera: GameCamera
var player: Player
var player_spawn_position: Vector2

@onready var level_generator: LevelGenerator = %LevelGenerator
@onready var ground_sprite: Sprite2D = %GroundSprite


func _ready() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	player_spawn_position.x = viewport_size.x / 2.0
	player_spawn_position.y = viewport_size.y - player_spawn_y_offset

	ground_sprite.global_position.x = viewport_size.x / 2.0
	ground_sprite.global_position.y = viewport_size.y

	new_game()


func new_game() -> void:
	player = player_scene.instantiate() as Player
	add_child(player)
	player.global_position = player_spawn_position

	camera = camera_scene.instantiate() as GameCamera
	camera.setup_camera(player)
	add_child(camera)

	level_generator.player = player


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
