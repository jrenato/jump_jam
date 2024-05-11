class_name Platform extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Jumper:
		var player: Jumper = body as Jumper
		if player.velocity.y > 0:
			player.jump()
