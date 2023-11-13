class_name PlayerSoundEffects
extends CharacterAudio

var fairy_hit = load("res://audio/sound_files/player/fairy_hit_2.mp3")
var got_hit = load("res://audio/sound_files/player/player_got_hit.mp3")

var rng = RandomNumberGenerator.new()

func start_sound(sound: String, random_pitch = false):
		match (sound):
			"HIT": 
				set_stream(fairy_hit)
			"GOT_HIT": 
				set_stream(got_hit)
		
		if random_pitch:
			set_pitch_scale(rng.randf_range(1.5, 2))
			
		play()
	
