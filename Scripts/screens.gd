extends CanvasLayer

@export var fadeout_duration: float = 0.5

var current_screen: Control = null

@onready var console: Control = %ConsoleLog
@onready var toggle_console: TextureButton = %ToggleConsole
@onready var log_label: Label = %LogLabel

@onready var title_screen: BaseScreen = %TitleScreen
@onready var pause_screen: BaseScreen = %PauseScreen
@onready var game_over_screen: BaseScreen = %GameOverScreen


func _ready() -> void:
	toggle_console.pressed.connect(_on_toggle_console_pressed)

	console.visible = false

	register_buttons()

	title_screen.fadeout_duration = fadeout_duration
	pause_screen.fadeout_duration = fadeout_duration
	game_over_screen.fadeout_duration = fadeout_duration
	change_screen(title_screen)


func register_buttons() -> void:
	var buttons: Array[Node] = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		if button is ScreenButton:
			button.clicked.connect(_on_screen_button_pressed)


func _on_screen_button_pressed(button: ScreenButton) -> void:
	match button.name:
		"TitlePlay":
			change_screen(pause_screen)
		"PauseRetry":
			change_screen(game_over_screen)
		"PauseBack":
			pass
		"PauseClose":
			pass
		"GameOverRetry":
			change_screen(title_screen)
		"GameOverBack":
			pass


func _on_toggle_console_pressed() -> void:
	console.visible = not console.visible


func change_screen(new_screen: Control) -> void:
	if current_screen:
		var disappear_tween: Tween = current_screen.disappear()
		await(disappear_tween.finished)
		current_screen.visible = false

	current_screen = new_screen

	if current_screen:
		var appear_tween: Tween = current_screen.appear()
		await(appear_tween.finished)
		get_tree().call_group("buttons", "set_disabled", false)
