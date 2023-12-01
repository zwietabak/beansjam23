class_name BattleMusicPlayer
extends AudioStreamPlayer

enum State {
	PLAYING,
	FADEING_OUT,
	FADEING_IN,
	PAUSED,
}

var playback = 0
var enemies: Array[Enemy]

var player_state: State = State.PAUSED
var tween

func fade_out():
	print("fade_out: " + printState())
	player_state = State.FADEING_OUT
	
func fade_in():
	print("fade_in: " + printState())
	if player_state == State.PAUSED or player_state == State.FADEING_OUT:
		player_state = State.FADEING_IN
		play(playback)
	
func pause_music():
	player_state = State.PAUSED
	playback = get_playback_position()
	stop()

func check_if_enemy_in_combat():
	print("check_if_enemy_in_combat: " + printState())
	for enemy in enemies:
		if not (enemy == null) and enemy.in_combat:
			return
			
	if player_state == State.PLAYING or player_state == State.FADEING_IN:
		fade_out()
		
func printState():
	match(player_state):
		State.PLAYING: 
			return "PLAYING"
		State.PAUSED: 
			return "PAUSED"
		State.FADEING_IN: 
			return "FADEING_IN"
		State.FADEING_OUT: 
			return "FADEING_OUT"


func _process(delta):
	if(player_state == State.FADEING_OUT):
		set_volume_db(volume_db - delta * 5)
		if(volume_db <= -30):
			pause_music()
	if(player_state == State.FADEING_IN):
		set_volume_db(volume_db + delta * 10)
		if(volume_db >= 0):
			player_state = State.PLAYING
