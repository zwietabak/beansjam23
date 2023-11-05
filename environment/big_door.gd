extends Node3D


var tween_left : Tween
var tween_right : Tween
@export var open_rotation : float = 90
@export var duration : float = 3.5


func open_door():
	tween_left = get_tree().create_tween()
	tween_right = get_tree().create_tween()
	
	tween_left.tween_property(%LeftDoor, "rotation_degrees", Vector3(0, open_rotation, 0), duration)
	tween_right.tween_property(%RightDoor, "rotation_degrees", Vector3(0, -open_rotation, 0), duration)


func _on_dialogue_box_dialogue_signal(value):
	match(value):
		"big_door": 
			open_door()
			$AudioStreamPlayer3D.play()
