extends CanvasLayer

var current_screen: Control = null

@onready var console: Control = %ConsoleLog
@onready var toggle_console: TextureButton = %ToggleConsole
@onready var log_label: Label = %LogLabel

@onready var title_screen: Control = %TitleScreen
@onready var pause_screen: Control = %PauseScreen
@onready var game_over_screen: Control = %GameOverScreen


func _ready() -> void:
	toggle_console.pressed.connect(_on_toggle_console_pressed)
	Signals.log_message.connect(_on_log_message)

	console.visible = false
	register_buttons()
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


func _on_log_message(message: String) -> void:
	log_label.text += "%s\n" % message


func change_screen(new_screen: Control) -> void:
	if current_screen:
		var disappear_tween: Tween = current_screen.disappear()
		await(disappear_tween.finished)
		current_screen.visible = false

	current_screen = new_screen

	if current_screen:
		var appear_tween: Tween = current_screen.appear()
