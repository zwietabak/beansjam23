extends AudioStreamPlayer
class_name BattleMusicPlayer

var enemies: Array[Enemy]
var fading = false
var playback = 0

func fade_out():
	fading = true
	var tween = get_tree().create_tween()
	tween.connect("finished", tween_completed)
	tween.tween_property(self, "volume_db", -80, 5)
	
func fade_in():
	if not playing:
		play(playback)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "volume_db", 0, 1)


func tween_completed():
	# stop the music -- otherwise it continues to run at silent volume
	print("tween_completed")	
	fading = false
	playback = get_playback_position()
	stop()


func _on_battle_timer_timeout():
	print(volume_db)
	for enemy in enemies:
		if !(enemy == null) and enemy.is_active:
			return
	
	if playing and not fading:	
		print("fade_out")
		fade_out();
