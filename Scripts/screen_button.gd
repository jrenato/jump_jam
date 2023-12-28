class_name ScreenButton extends TextureButton

signal clicked(button: TextureButton)


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	clicked.emit(self)
