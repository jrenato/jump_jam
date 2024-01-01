class_name GameCamera extends Camera2D

var viewport_size: Vector2
var player: Player
var limit_distance: int = 420

@onready var destroyer: Area2D = %Destroyer
@onready var destroyer_shape: CollisionShape2D = %DestroyerShape


func _ready() -> void:
	if player:
		global_position.y = player.global_position.y

	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2.0

	limit_bottom = int(viewport_size.y)
	limit_left = 0
	limit_right = int(viewport_size.x)

	destroyer.position.y = viewport_size.y
	var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
	rectangle_shape.size = Vector2(viewport_size.x, 200)
	destroyer_shape.shape = rectangle_shape


func _process(delta: float) -> void:
	if not player:
		return

	if limit_bottom > player.global_position.y + limit_distance:
		limit_bottom = int(player.global_position.y + limit_distance)

	var overlapping_areas: Array[Area2D] = destroyer.get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		if overlapping_area is Platform:
			overlapping_area.queue_free()


func _physics_process(delta: float) -> void:
	if not player:
		return

	global_position.y = player.global_position.y


func setup_camera(_player: Player) -> void:
	if not _player:
		return

	player = _player
