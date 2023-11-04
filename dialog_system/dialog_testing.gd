extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$DialogueBox.start('INTRO')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	$AudioStreamPlayer3D.play()


func _on_audio_stream_player_3d_finished():
	$DialogueBox.start('WEIRD_NOISE')


func _on_timer_2_timeout():
	$BattleMusic.fade_out();


func _on_timer_timeout():
	$BattleMusic.play()
