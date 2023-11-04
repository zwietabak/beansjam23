extends AudioStreamPlayer


func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -80, 5)


func _on_TweenOut_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	stop()
