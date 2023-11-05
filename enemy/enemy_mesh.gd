extends Node3D


@export
var Body : MeshInstance3D

@export
var Horns : Array[MeshInstance3D]

# Called when the node enters the scene tree for the first time.
func _ready():
	if Body == null:
		return
	
	for index in range(Body.get_blend_shape_count()):
		Body.set_blend_shape_value(index, randf_range(-0.2, 1.0))

	for horn in Horns:
		horn.visible = randi_range(0, 1) as bool
