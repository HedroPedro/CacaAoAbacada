extends Node

signal _done
signal _finish_tutorial

const API_PATH := "res://API/Vogal_A"

var array_silabas: Array = []
var done_tutorial := false

var pirateSound: AudioStreamPlayer
var musicPlayer: AudioStreamPlayer

# ─────────────────────────────────────────────
# Áudio helpers
# ─────────────────────────────────────────────
func play_sound_pirate(sound: AudioStream) -> void:
	pirateSound.stream = sound
	pirateSound.play()
	await pirateSound.finished

func change_music_db(db: float) -> void:
	musicPlayer.volume_db = db

# ─────────────────────────────────────────────
# Inicialização: monta o dicionário completo
# ─────────────────────────────────────────────
func _ready() -> void:
	var audios_path  := API_PATH + "/Audios"
	var images_path  := API_PATH + "/Imagens"

	# --- 1. Indexa todos os áudios: { silaba -> AudioStream } ---
	var audio_map: Dictionary = {}
	var audio_dir := DirAccess.open(audios_path)
	if audio_dir:
		audio_dir.list_dir_begin()
		var fname := audio_dir.get_next()
		while fname != "":
			if not audio_dir.current_is_dir() and fname.ends_with(".ogg") or fname.ends_with(".wav") or fname.ends_with(".mp3"):
				# espera nome igual à sílaba: "BA.ogg", "CA.wav", etc.
				var silaba := fname.get_basename().to_upper()
				audio_map[silaba] = load(audios_path + "/" + fname)
			fname = audio_dir.get_next()
		audio_dir.list_dir_end()
	else:
		push_error("Não foi possível abrir: " + audios_path)

	# --- 2. Indexa todas as imagens: { silaba -> [Texture2D, ...] } ---
	var image_map: Dictionary = {}
	var image_dir := DirAccess.open(images_path)
	if image_dir:
		image_dir.list_dir_begin()
		var fname := image_dir.get_next()
		while fname != "":
			if not image_dir.current_is_dir() and fname.ends_with(".png"):
				# formato esperado: <SILABA>_restantes.png
				var base   := fname.get_basename()          # "BA_restantes"
				var parts  := base.split("_", false, 1)     # ["BA", "restantes"]
				if parts.size() >= 1:
					var silaba := parts[0].to_upper()
					if not image_map.has(silaba):
						image_map[silaba] = []
					image_map[silaba].append(load(images_path + "/" + fname))
			fname = image_dir.get_next()
		image_dir.list_dir_end()
	else:
		push_error("Não foi possível abrir: " + images_path)

	# --- 3. Constrói array_silabas preservando o dicionário original ---
	var todas_silabas: Array = []
	todas_silabas.append_array(audio_map.keys())
	for s in image_map.keys():
		if not todas_silabas.has(s):
			todas_silabas.append(s)

	for silaba in todas_silabas:
		var entrada: Dictionary = {
			"silaba"            : silaba,
			"imagens"           : image_map.get(silaba, []).duplicate(),
			"som"               : audio_map.get(silaba, null)
		}
		array_silabas.append(entrada)

	print("Dicionário montado com %d sílabas." % array_silabas.size())
	_done.emit()

# ─────────────────────────────────────────────
# Embaralha sílabas e imagens da primeira entrada
# ─────────────────────────────────────────────
func embaralhar() -> void:
	array_silabas.shuffle()
	if array_silabas.size() > 0:
		array_silabas[0]["imagens"].shuffle()
