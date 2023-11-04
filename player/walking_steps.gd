extends AudioStreamPlayer

var playback_pos = 0

func  _ready():
	pass

func start_walking():
	if not playing:
		play(playback_pos) 
		
func stop_walking():
	if playing:
		playback_pos = get_playback_position()
		fade_out() 


func fade_out():
	var tween = get_tree().create_tween()
	tween.connect("finished", tween_completed)
	tween.tween_property(self, "volume_db", -80, 0.1)


func tween_completed():
	stop()
	set_volume_db(0)

