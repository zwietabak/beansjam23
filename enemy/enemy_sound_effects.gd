class_name EnemySoundEffects
extends AudioStreamPlayer3D

var attack_sounds = []
var got_hit = load("res://audio/sound_files/monster/monster_hit.wav")

func _ready():
	attack_sounds.append(load("res://audio/sound_files/monster/monster_growl_1.wav"))
	attack_sounds.append(load("res://audio/sound_files/monster/monster_growl_2.wav"))
	attack_sounds.append(load("res://audio/sound_files/monster/monster_growl_3.wav"))
	attack_sounds.append(load("res://audio/sound_files/monster/monster_growl_4.wav"))

var rng = RandomNumberGenerator.new()

func start_sound(sound: String, random_pitch = false):
	if not playing:
		match (sound):
			"HIT": 
				set_stream(attack_sounds[rng.randf_range(0, attack_sounds.size())])
			"GOT_HIT": 
				set_stream(got_hit)
		
		if random_pitch:
			set_pitch_scale(rng.randf_range(1.5, 2))
			
		play()
	
