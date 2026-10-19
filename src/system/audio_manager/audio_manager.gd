extends Node

const NORMAL_MUSIC = preload("res://assets/audio/normal_mode.mp3")
const GHOST_MUSIC = preload("res://assets/audio/ghost_mode.mp3")
const PICKUP_SFX = preload("res://assets/audio/pick_up_and_put_down.mp3")

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

func _ready() -> void:
	play_normal_music()

func play_normal_music() -> void:
	if music_player.stream != NORMAL_MUSIC:
		music_player.stream = NORMAL_MUSIC
		music_player.play()

func play_ghost_music() -> void:
	if music_player.stream != GHOST_MUSIC:
		music_player.stream = GHOST_MUSIC
		music_player.play()

func play_pickup_sfx() -> void:
	sfx_player.stream = PICKUP_SFX
	sfx_player.play()
