extends Node2D

signal game_over(score: int, high_score: int)

@export var camera_scene: PackedScene
@export var player_scene: PackedScene
@export var player_spawn_y_offset: float = 135.0

var camera: GameCamera
var viewport_size: Vector2
var player: Player
var player_spawn_position: Vector2
var score: int
var high_score: int
var save_file_path: String = "user://highscore.dat"

@onready var level_generator: LevelGenerator = %LevelGenerator
@onready var ground_sprite: Sprite2D = %GroundSprite
@onready var parallax_1: ParallaxLayer = %ParallaxLayer1
@onready var parallax_2: ParallaxLayer = %ParallaxLayer2
@onready var parallax_3: ParallaxLayer = %ParallaxLayer3

@onready var hud: HUD = %HUD


func _ready() -> void:
	hud.visible = false
	ground_sprite.visible = false

	viewport_size = get_viewport_rect().size
	player_spawn_position.x = viewport_size.x / 2.0
	player_spawn_position.y = viewport_size.y - player_spawn_y_offset

	ground_sprite.global_position.x = viewport_size.x / 2.0
	ground_sprite.global_position.y = viewport_size.y

	setup_parallax_layer(parallax_1)
	setup_parallax_layer(parallax_2)
	setup_parallax_layer(parallax_3)

	load_score()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

	if player and player.velocity.y < 0:
		var temp_score: int = int(viewport_size.y - player.global_position.y)
		if score < temp_score:
			score = temp_score
			hud.set_score(score)


func new_game() -> void:
	reset_game()
	score = 0
	hud.set_score(score)

	player = player_scene.instantiate() as Player
	add_child(player)
	player.global_position = player_spawn_position
	player.died.connect(_on_player_died)

	camera = camera_scene.instantiate() as GameCamera
	camera.setup_camera(player)
	add_child(camera)

	level_generator.player = player
	level_generator.start_generation()

	hud.visible = true
	ground_sprite.visible = true


func reset_game() -> void:
	score = 0

	if player:
		player.queue_free()
		player = null
		level_generator.player = null

	if camera:
		camera.queue_free()
		camera = null

	level_generator.reset_level()
	ground_sprite.visible = false


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


func save_score() -> void:
	var file: FileAccess = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_var(high_score)
	file.close()


func load_score() -> void:
	if not FileAccess.file_exists(save_file_path):
		high_score = 0
		return

	var file: FileAccess = FileAccess.open(save_file_path, FileAccess.READ)
	high_score = file.get_var()
	file.close()


func _on_player_died() -> void:
	hud.visible = false

	if score > high_score:
		high_score = score
		save_score()

	game_over.emit(score, high_score)
