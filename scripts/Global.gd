extends Node

signal _done
signal _finish_tutorial

const API_PATH := "res://API/Vogal_A"

var words: Dictionary
var array_silabas: Array
var array_imagens: Array

var done_tutorial := false

var pirateSound: AudioStreamPlayer
var musicPlayer: AudioStreamPlayer

func play_sound_pirate(sound: AudioStream) -> void:
	pirateSound.stream = sound
	pirateSound.play()
	await pirateSound.finished

func change_music_db(db: float) -> void:
	musicPlayer.volume_db = db

func _ready() -> void:
	words = load_json()
	array_silabas = words.words
	embaralhar()

func embaralhar():
	array_silabas.shuffle()

func embaralhar_imagens(pos_array):
	array_imagens = array_silabas[pos_array].imagens
	array_imagens.shuffle()

func load_json():
	var file = "res://files/words.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict
