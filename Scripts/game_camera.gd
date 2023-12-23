class_name GameCamera extends Camera2D

var viewport_size: Vector2
var player: Player
var limit_distance: int = 420

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2

	limit_bottom = floor(viewport_size.y)
	limit_left = 0
	limit_right = floor(viewport_size.x)


func _process(delta: float) -> void:
	if not player:
		pass

	if limit_bottom > player.global_position.y + limit_distance:
		limit_bottom = floor(player.global_position.y + limit_distance)


func _physics_process(delta: float) -> void:
	if not player:
		pass

	global_position.y = player.global_position.y


func setup_camera(_player: Player) -> void:
	if _player:
		player = _player
