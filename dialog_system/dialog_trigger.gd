extends Node3D

@export var dialogue_box : Node
@export var dialogue_id : String

signal dialog_entered

var triggered = false

func _on_area_3d_body_entered(body):
	if(body.name == "Player" && !triggered):
		dialogue_box.start(dialogue_id)
		triggered = true
		dialog_entered.emit()
