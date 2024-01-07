extends Node

var sounds: Dictionary = {
	"Click": preload("res://Assets/Sound/Click.wav"),
	"Fall": preload("res://Assets/Sound/Fall.wav"),
	"Jump": preload("res://Assets/Sound/Jump.wav")
}

@onready var sound_players: Array = get_children()


func play(sound_name: String) -> void:
	var sound_to_play: Resource = sounds[sound_name]
	for sound_player in sound_players:
		if not sound_player.is_playing():
			sound_player.stream = sound_to_play
			sound_player.play()
			return
