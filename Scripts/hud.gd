extends Control

var safe_area: Rect2i
var safe_area_top: int
var bg_margin: int = 10

@onready var top_bar_bg: ColorRect = %TopBarBG
@onready var top_bar: Control = %TopBar
@onready var score_label: Label = %ScoreLabel
@onready var pause_button: TextureButton = %PauseButton


func _ready() -> void:
	var os_name: String = OS.get_name()

	if os_name in ["Android", "iOS"]:
		adjust_safe_area()

	pause_button.pressed.connect(_on_pause_button_pressed)


func adjust_safe_area() -> void:
	safe_area = DisplayServer.get_display_safe_area()
	safe_area_top = safe_area.position.y
	top_bar.position.y += safe_area_top
	top_bar_bg.size.y += safe_area_top + bg_margin

	Signals.add_log_msg("Window Size %s" % DisplayServer.window_get_size())
	Signals.add_log_msg("Safe Area %s" % safe_area)
	Signals.add_log_msg("Safe Area Top %s" % safe_area_top)
	Signals.add_log_msg("Top Bar position %s" % top_bar.position)
	Signals.add_log_msg("Top Bar BG size %s" % top_bar_bg.size)


func _on_pause_button_pressed() -> void:
	pass
