extends Node

const NORMAL_MUSIC = preload("res://assets/audio/normal_mode.mp3")
const GHOST_MUSIC = preload("res://assets/audio/ghost_mode.mp3")
const PICKUP_SFX = preload("res://assets/audio/pick_up_and_put_down.mp3")
const TEXT_SOUND = preload("res://assets/audio/text.mp3")

const TEXT_BEAT_COUNT : int = 3
const TEXT_BAR_BEATS : int = 0

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

func _ready() -> void:
	play_normal_music()

func play_normal_music() -> void:
	if music_player.stream != NORMAL_MUSIC:
		music_player.stream = NORMAL_MUSIC
		music_player.stream.loop = true
	
		music_player.play()

func play_ghost_music() -> void:
	if music_player.stream != GHOST_MUSIC:
		music_player.stream = GHOST_MUSIC
		music_player.stream.loop = true
		music_player.play()

func play_pickup_sfx() -> void:
	sfx_player.stream = PICKUP_SFX
	sfx_player.play()

func play_text_sfx() -> void:
	sfx_player.stream =TEXT_SOUND
	sfx_player.stream.beat_count = TEXT_BEAT_COUNT
	sfx_player.stream.bar_beats =TEXT_BAR_BEATS

	sfx_player.play()
