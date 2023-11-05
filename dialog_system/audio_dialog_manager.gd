extends AudioStreamPlayer

var current_player_dialog = 0
var current_fairy_dialog = 0

var max_dialog_player = 21
var max_dialog_fairy = 20

@export var player : Character
@export var fairy : Character


func _on_dialogue_box_who_is_talking(var_name):
	print("player_dialog: " + str(current_player_dialog))
	print("fairy_dialog: " + str(current_fairy_dialog))
	
	match (var_name):
		player.name: 
			set_stream(load("res://audio/player_dialog/animalese (" + str(current_player_dialog) + ").wav"))
			play()
			if(current_player_dialog < max_dialog_player):
				current_player_dialog += 1
			else:
				current_player_dialog = 0 
		fairy.name: 
			set_stream(load("res://audio/fairy_dialog/animalese (" + str(current_fairy_dialog) + ").wav"))
			play()
			if(current_fairy_dialog < max_dialog_fairy):
				current_fairy_dialog += 1
			else:
				current_fairy_dialog = 0 


func _on_dialogue_box_dialogue_skiped():
	stop()
