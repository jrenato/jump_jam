extends Node

@onready var game: Node2D = %Game
@onready var screens: CanvasLayer = %Screens


func _ready() -> void:
	screens.start_game.connect(_on_start_game)
	screens.delete_level.connect(_on_delete_level)
	game.game_over.connect(_on_game_over)
	game.pause_game.connect(_on_game_pause_game)
	

func _on_start_game() -> void:
	game.new_game()


func _on_game_over(score: int, high_score: int) -> void:
	screens.game_over(score, high_score)


func _on_delete_level() -> void:
	game.reset_game()


func _on_game_pause_game() -> void:
	get_tree().paused = true
	screens.pause_game()
