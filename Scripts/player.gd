class_name Player extends CharacterBody2D

signal died

@export var gravity: float = 15.0
@export var max_fall_speed: float = 1000.0
@export var move_speed: float = 300.0
@export var friction: float = 50.0
@export var jump_speed: float = -800.0

@export var screen_margin: int = 20

var dead: bool = false
var direction: float
var viewport_size: Vector2
var use_mobile_input: bool = false

var fall_animation: String = "Fall"
var jump_animation: String = "Jump"

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var visible_notifier: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D
@onready var collision_shape: CollisionShape2D = %CollisionShape2D
@onready var sprite = %Sprite2D


func _ready() -> void:
	visible_notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)

	viewport_size = get_viewport_rect().size
	var os_name: String = OS.get_name()
	if os_name in ["Android", "iOS"]:
		use_mobile_input = true


func _process(delta: float) -> void:
	if velocity.y > 0 and animation_player.assigned_animation != fall_animation:
		animation_player.play(fall_animation)
	elif velocity.y < 0 and animation_player.assigned_animation != jump_animation:
		animation_player.play(jump_animation)


func _physics_process(delta: float) -> void:
	velocity.y = clamp(velocity.y + gravity, jump_speed, max_fall_speed)

	if not dead:
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
	SoundFX.play("Jump")


func die() -> void:
	if not dead:
		SoundFX.play("Fall")
		dead = true
		collision_shape.set_deferred("disabled", true)
		died.emit()


func use_new_skin() -> void:
	fall_animation = "Fall_Red"
	jump_animation = "Jump_Red"
	if sprite:
		sprite.texture = preload("res://Assets/Textures/Character/Skin2Idle.png")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()
