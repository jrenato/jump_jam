extends Node2D

@export var camera_scene: PackedScene
@export var player_scene: PackedScene
@export var player_spawn_y_offset: float = 135.0

var camera: GameCamera
var viewport_size: Vector2
var player: Player
var player_spawn_position: Vector2

@onready var level_generator: LevelGenerator = %LevelGenerator
@onready var ground_sprite: Sprite2D = %GroundSprite
@onready var parallax_1: ParallaxLayer = %ParallaxLayer1
@onready var parallax_2: ParallaxLayer = %ParallaxLayer2
@onready var parallax_3: ParallaxLayer = %ParallaxLayer3


func _ready() -> void:
	viewport_size = get_viewport_rect().size
	player_spawn_position.x = viewport_size.x / 2.0
	player_spawn_position.y = viewport_size.y - player_spawn_y_offset

	ground_sprite.global_position.x = viewport_size.x / 2.0
	ground_sprite.global_position.y = viewport_size.y

	setup_parallax_layer(parallax_1)
	setup_parallax_layer(parallax_2)
	setup_parallax_layer(parallax_3)

	new_game()


func new_game() -> void:
	player = player_scene.instantiate() as Player
	add_child(player)
	player.global_position = player_spawn_position

	camera = camera_scene.instantiate() as GameCamera
	camera.setup_camera(player)
	add_child(camera)

	level_generator.player = player


func get_parallax_sprite_scale(parallax_sprite: Sprite2D) -> Vector2:
	var parallax_texture: Texture = parallax_sprite.get_texture()
	var parallax_texture_width: float = parallax_texture.get_width()
	var parallax_scale: float = viewport_size.x / parallax_texture_width
	return Vector2(parallax_scale, parallax_scale)


func setup_parallax_layer(parallax_layer: ParallaxLayer) -> void:
	var parallax_sprite: Sprite2D = parallax_layer.find_child("Sprite2D") as Sprite2D

	if not parallax_sprite:
		return

	parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
	var mirror_y: float = parallax_sprite.get_texture().get_height() * parallax_sprite.scale.y
	parallax_layer.motion_mirroring.y = mirror_y


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
