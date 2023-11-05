class_name EnemyGroup
extends Node

var enemies: Array[Node]
@export var trigger: Node

signal all_dead
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies = get_children()
	for enemy in enemies:
		trigger.connect("door_smashed", (enemy as Enemy)._on_door_smashed)
		(enemy as Enemy).connect("on_died", check_if_all_dead)
		
func check_if_all_dead():
	counter += 1
	print(counter)
	print(enemies.size())
	if counter == enemies.size():
		all_dead.emit()
	
