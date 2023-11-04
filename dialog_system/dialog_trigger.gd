extends Node3D

@export var dialogue_box : Node
@export var dialogue_id : String

var triggered = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if(body.name == "Player" && !triggered):
		dialogue_box.start(dialogue_id)
		triggered = true
