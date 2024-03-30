extends Node

var game_in_progress: bool = false

@onready var game: Node2D = %Game
@onready var screens: CanvasLayer = %Screens
@onready var iap_manager: IAPManager = %IAPManager


func _ready() -> void:
	DisplayServer.window_set_window_event_callback(_on_window_event)

	screens.start_game.connect(_on_start_game)
	screens.delete_level.connect(_on_delete_level)
	game.game_over.connect(_on_game_over)
	game.pause_game.connect(_on_game_pause_game)

	# IAP signals
	iap_manager.unlock_new_skin.connect(_on_iap_manager_unlock_new_skin)
	screens.purchase_skin.connect(_on_screens_purchase_skin)


func _on_start_game() -> void:
	game_in_progress = true
	game.new_game()


func _on_game_over(score: int, high_score: int) -> void:
	game_in_progress = false
	screens.game_over(score, high_score)


func _on_delete_level() -> void:
	game_in_progress = false
	game.reset_game()


func _on_game_pause_game() -> void:
	get_tree().paused = true
	screens.pause_game()


func _on_window_event(event: int) -> void:
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			# Pause game if it's in progress and not already paused
			if game_in_progress and not get_tree().paused:
				_on_game_pause_game()
				Signals.add_log_msg("Lost focus, pausing the game")
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()


# IAP Signals
func _on_iap_manager_unlock_new_skin(skin_name: String) -> void:
	if not game.new_skin_unlocked:
		game.new_skin_unlocked = true
		print("New skin unlocked: %s" % skin_name)


func _on_screens_purchase_skin(skin_name: String) -> void:
	iap_manager.purchase_skin(skin_name)
