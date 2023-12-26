class_name Player extends CharacterBody2D

@export var gravity: float = 15.0
@export var max_fall_speed: float = 1000.0
@export var move_speed: float = 300.0
@export var friction: float = 50.0
@export var jump_speed: float = -800.0

@export var screen_margin: int = 20

var direction: float
var viewport_size: Vector2
var use_mobile_input: bool = false

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	viewport_size = get_viewport_rect().size
	var os_name: String = OS.get_name()
	if os_name in ["Android", "iOS"]:
		use_mobile_input = true


func _process(delta: float) -> void:
	if velocity.y > 0 and animation_player.assigned_animation != "Fall":
		animation_player.play("Fall")
	elif velocity.y < 0 and animation_player.assigned_animation != "Jump":
		animation_player.play("Jump")


func _physics_process(delta: float) -> void:
	velocity.y = clamp(velocity.y + gravity, jump_speed, max_fall_speed)

	if not use_mobile_input:
		direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

	move_and_slide()

	if global_position.x > viewport_size.x + screen_margin:
		global_position.x = -screen_margin
	elif global_position.x < -screen_margin:
		global_position.x = viewport_size.x + screen_margin


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if event.position.x > viewport_size.x / 2:
				direction = 1.0
			elif event.position.x < viewport_size.x / 2:
				direction = -1.0
		else:
			direction = 0.0


func jump() -> void:
	velocity.y = jump_speed
