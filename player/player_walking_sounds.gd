class_name WalkingSounds
extends CharacterAudio

var playback_pos = 0

func start_walking():
	if not playing:
		play(playback_pos) 
		
func stop_walking():
	if playing:
		playback_pos = get_playback_position()
		fade_out(self)

