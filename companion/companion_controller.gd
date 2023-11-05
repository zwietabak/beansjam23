extends CharacterBody3D


@export var circle_radius: float = 1.0
@export var circle_speed: float = 225
@export var bounce_height: float = 0.02
@export var bounce_speed: float = 1
@export var attack_speed: float = 0.55
@export var attack_damage: int = 1

@onready var current_state: State = State.IDLE

enum State {
	IDLE,
	ATTACK
}

func change_state(state: String):
	if state == "IDLE":
		current_state = State.IDLE
	elif state == "ATTACK":
		current_state = State.ATTACK

func get_state_as_string() -> String:
	if current_state == State.IDLE:
		return "IDLE"
	elif current_state == State.ATTACK:
		return "ATTACK"
	return ""
