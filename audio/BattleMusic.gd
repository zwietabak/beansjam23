class_name BattleMusicPlayer
extends AudioStreamPlayer

var playback = 0
var enemies: Array[Enemy]
var fadeing = false

func fade_out():
	fadeing = true
	var tween = get_tree().create_tween()
	tween.connect("finished", tween_completed)
	tween.tween_property(self, "volume_db", -80, 5)
	
func fade_in():
	if not playing:
		play(playback)
		print(volume_db)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "volume_db", 0, 1)


func tween_completed():
	# stop the music -- otherwise it continues to run at silent volume
	stop()
	fadeing = false
	playback = get_playback_position()


func _on_timer_timeout():
	for enemy in enemies:
		if not (enemy == null) and enemy.is_active:
			return
			
	if not fadeing and playing:
		fade_out()
