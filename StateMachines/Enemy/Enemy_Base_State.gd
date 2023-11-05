class_name EnemyBaseState
extends Node


var state_machine : EnemyStateMachine
var character : Enemy


# Recive user input
func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass

#Called when state is entered
func enter(_msg := {}) -> void:
	pass

#Called when state is exited
func exit() -> void:
	pass

func recive_event(value: String) -> void:
	pass
