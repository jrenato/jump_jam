extends Node

@onready var game: Node2D = %Game
@onready var screens: CanvasLayer = %Screens


func _ready() -> void:
	screens.start_game.connect(_on_start_game)
	game.game_over.connect(_on_game_over)
	

func _on_start_game() -> void:
	game.new_game()


func _on_game_over(score: int, high_score: int) -> void:
	screens.game_over(score, high_score)
