extends CharacterBody3D


const SPEED = 150
const TURN_SPEED = 5.0

enum State {
	IDLE,
	FOLLOW,
	ATTACK
}

@onready var current_state = State.IDLE
@onready var hitbox = $Hitbox
@onready var player_detection = $Player_Detection
@onready var navigation_agent = $NavigationAgent3D
@onready var face_direction = $Face_Direction

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var invincible = false
var hitpoints = 3
var follow_target = null

func _ready():
	hitbox.connect("body_entered", hitbox_body_entered)
	player_detection.connect("body_entered", player_detection_area_body_entered)
	player_detection.connect("body_exited", player_detection_area_body_exited)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Temporary state machine
	# TODO: Replace with state machine addon
	if current_state == State.IDLE:
		pass
	elif current_state == State.FOLLOW:
		face_direction.look_at(follow_target.global_transform.origin, Vector3.UP)
		rotate_y(deg_to_rad(face_direction.rotation.y * TURN_SPEED))
		navigation_agent.set_target_position(follow_target.global_transform.origin)
		velocity = (navigation_agent.get_next_path_position() - transform.origin).normalized() * SPEED * delta
	elif  current_state == State.ATTACK:
		pass

	move_and_slide()

	if hitpoints <= 0:
		queue_free()

func take_damage(damage: int):
	print("HIT")
	hitpoints -= damage
	invincible = true
	await get_tree().create_timer(0.5).timeout
	invincible = false

func hitbox_body_entered(body):
	if body.name == "Companion" and !invincible:
		take_damage(body.attack_damage)
		
func player_detection_area_body_entered(body):
	if body.name == "Player":
		follow_target = body
		current_state = State.FOLLOW
	
func player_detection_area_body_exited(body):
	pass
