class_name EnemyWalkingSounds
extends AudioStreamPlayer3D

var playback_pos = 0

func start_walking():
	if not playing:
		play(playback_pos) 
		
func stop_walking():
	if playing:
		playback_pos = get_playback_position()
		fade_out(self)

func fade_out(object: Object, fade_duration = 0):
	var tween = get_tree().create_tween()
	tween.connect("finished", tween_completed)
	tween.tween_property(object, "volume_db", -80, fade_duration)

func tween_completed():
	stop()
	set_volume_db(0)
