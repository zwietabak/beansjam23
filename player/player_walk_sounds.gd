extends CharacterAudio

var left_step_sounds = []
var right_step_sounds = []

var rng = RandomNumberGenerator.new()

func _ready():
	left_step_sounds.append(load("res://audio/sound_files/player/footsteps/left_step_1.mp3"))
	left_step_sounds.append(load("res://audio/sound_files/player/footsteps/left_step_2.mp3"))
	
	right_step_sounds.append(load("res://audio/sound_files/player/footsteps/right_step_1.mp3"))
	right_step_sounds.append(load("res://audio/sound_files/player/footsteps/right_step_2.mp3"))

func left_step():
		set_stream(left_step_sounds[rng.randi_range(0, left_step_sounds.size() - 1)])
		set_pitch_scale(rng.randf_range(0.5, 1.5))
		play()
	
func right_step():
		set_stream(right_step_sounds[rng.randi_range(0, right_step_sounds.size() - 1)])
		set_pitch_scale(rng.randf_range(0.5, 1.5))
		play()
