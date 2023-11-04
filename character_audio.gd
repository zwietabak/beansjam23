class_name CharacterAudio
extends AudioStreamPlayer


func fade_out(object: Object, fade_duration = 0):
	var tween = get_tree().create_tween()
	tween.connect("finished", tween_completed)
	tween.tween_property(object, "volume_db", -80, fade_duration)


func tween_completed():
	stop()
	set_volume_db(0)

