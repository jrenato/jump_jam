extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body as Player
		if player.velocity.y > 0:
			player.jump()
