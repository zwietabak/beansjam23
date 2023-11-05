extends Node3D

@export
var Body : MeshInstance3D

@export
var Horns : Array[MeshInstance3D]

signal animation_signal(value: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	if Body == null:
		return
	
	for index in range(Body.get_blend_shape_count()):
		var blend_shape_values = clamp(randi_range(-1, 2) * 0.5, -0.2, 1.0)
		Body.set_blend_shape_value(index, blend_shape_values)

	for horn in Horns:
		horn.visible = randi_range(0, 1) as bool

func signal_call(value: String):
	animation_signal.emit(value)
