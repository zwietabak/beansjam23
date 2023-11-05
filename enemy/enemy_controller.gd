extends CharacterBody3D
class_name Enemy

const SPEED = 150
const TURN_SPEED = 5.0

enum State {
	IDLE,
	FOLLOW,
	WALK_BACK_TO_START,
	ATTACK
}

@onready var current_state = State.IDLE
@onready var hitbox = $Hitbox
@onready var damage_detection = $Damage_Detection
@onready var player_detection = $Player_Detection
@onready var navigation_agent = $NavigationAgent3D
@onready var face_direction = $Face_Direction
@onready var start_position = self.position

@export var follow_target: CharacterBody3D
@export var health_points: int = 3
@export var damage_points: int = 1
@export var sound_effects: EnemySoundEffects
@export var walking_sound: EnemyWalkingSounds

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var invincible = true
var in_attack_animation = false

signal on_died

func _ready():
	hitbox.connect("body_entered", hitbox_body_entered)
	player_detection.connect("body_entered", player_detection_area_body_entered)
	player_detection.connect("body_exited", player_detection_area_body_exited)
	damage_detection.connect("body_entered", damage_detection_area_body_entered)
	damage_detection.connect("body_exited", damage_detection_area_body_exited)
	set_process(false)
	set_physics_process(false)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Temporary state machine
	# TODO: Replace with state machine addon
	if current_state == State.IDLE:
		velocity.x = 0
		velocity.z = 0
	elif current_state == State.FOLLOW:
		face_direction.look_at(follow_target.global_transform.origin, Vector3.UP)
		rotate_y(deg_to_rad(face_direction.rotation.y * TURN_SPEED))
		navigation_agent.set_target_position(follow_target.global_transform.origin)
		velocity = (navigation_agent.get_next_path_position() - transform.origin).normalized() * SPEED * delta
	elif current_state == State.WALK_BACK_TO_START:
		face_direction.look_at(start_position, Vector3.UP)
		rotate_y(deg_to_rad(face_direction.rotation.y * TURN_SPEED))
		navigation_agent.set_target_position(start_position)
		velocity = (navigation_agent.get_next_path_position() - transform.origin).normalized() * SPEED * delta
		if int(self.position.x) == int(start_position.x) and int(self.position.z) == int(start_position.z):
			current_state = State.IDLE
	elif  current_state == State.ATTACK and !in_attack_animation:
		velocity.x = 0
		velocity.z = 0
		follow_target.take_damage(damage_points)
		sound_effects.start_sound("HIT")
		# Play enemy attack animation here instead of waiting...
		in_attack_animation = true
		await get_tree().create_timer(2.0).timeout
		in_attack_animation = false

	move_and_slide()
	
	if(velocity.length() > 0):
		walking_sound.start_walking()
	else:
		walking_sound.stop_walking() 

	if health_points <= 0:
		on_died.emit()
		queue_free()

func take_damage(amount: int):
	print("HIT")
	sound_effects.start_sound("GOT_HIT")
	health_points -= amount
	invincible = true
	await get_tree().create_timer(0.5).timeout
	invincible = false

func hitbox_body_entered(body):
	if body.name == "Companion" and !invincible:
		take_damage(body.attack_damage)
		
func player_detection_area_body_entered(body):
	if body.name == "Player":
		current_state = State.FOLLOW
	
func player_detection_area_body_exited(body):
	if body.name == "Player":
		current_state = State.WALK_BACK_TO_START

func damage_detection_area_body_entered(body):
	if body.name == "Player":
		current_state = State.ATTACK
		
func damage_detection_area_body_exited(body):
	if body.name == "Player":
		current_state = State.FOLLOW


func _on_door_smashed():
	set_process(true)
	set_physics_process(true)
	invincible = false
