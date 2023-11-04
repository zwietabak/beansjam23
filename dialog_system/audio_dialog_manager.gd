extends AudioStreamPlayer

var current_player_dialog = 0
var current_fairy_dialog = 0

@export var player : Character
@export var fairy : Character


func _on_dialogue_box_who_is_talking(var_name):
	match (var_name):
		player.name: 
			set_stream(load("res://audio/player_dialog/animalese (" + str(current_player_dialog) + ").wav"))
			play()
			current_player_dialog += 1
		fairy.name: 
			set_stream(load("res://audio/fairy_dialog/animalese (" + str(current_fairy_dialog) + ").wav"))
			play()
			current_fairy_dialog += 1


func _on_dialogue_box_dialogue_skiped():
	stop()
