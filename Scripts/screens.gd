extends CanvasLayer

@onready var console: Control = %ConsoleLog
@onready var toggle_console: TextureButton = %ToggleConsole
@onready var log_label: Label = %LogLabel

func _ready() -> void:
	console.visible = false
	toggle_console.pressed.connect(_on_toggle_console_pressed)

	Signals.log_message.connect(_on_log_message)


func _process(delta: float) -> void:
	pass


func _on_toggle_console_pressed() -> void:
	console.visible = not console.visible


func _on_log_message(message: String) -> void:
	log_label.text += "%s\n" % message
