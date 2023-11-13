extends CharacterBody3D
class_name Enemy

const SPEED = 300
const TURN_SPEED = 5.0

enum State {
	IDLE,
	FOLLOW,
	WALK_BACK_TO_START,
	ATTACK
}

@onready var current_state = State.IDLE
@onready var hitbox = $Hitbox as Area3D
@onready var damage_detection = $Damage_Detection as Area3D
@onready var player_detection = $Player_Detection as Area3D
@onready var navigation_agent = $NavigationAgent3D as NavigationAgent3D
@onready var face_direction = $Face_Direction
@onready var start_position = self.position
@onready var state_machine = $EnemyStateMachine as EnemyStateMachine

@export var follow_target: CharacterBody3D
@export var health_points: int = 5
@export var damage_points: int = 1
@export var sound_effects: EnemySoundEffects

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var invincible = true
var battle_music: BattleMusicPlayer
var is_active = false
var combo = false
var is_dead = false
var in_combat = false
var stagger_resistance = false

signal running(is_running: bool)
signal attack
signal attack2
signal on_died
signal hit

func _ready():
	hitbox.connect("body_entered", hitbox_body_entered)
	player_detection.connect("body_entered", player_detection_area_body_entered)
	player_detection.connect("body_exited", player_detection_area_body_exited)
	damage_detection.connect("body_entered", damage_detection_area_body_entered)
	damage_detection.connect("body_exited", damage_detection_area_body_exited)
	battle_music = get_tree().get_first_node_in_group("BattleMusic") as BattleMusicPlayer
	if battle_music != null:
		battle_music.enemies.append(self)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if health_points <= 0:
		die()

func follow_player(delta):
	face_direction.look_at(follow_target.global_transform.origin, Vector3.UP)
	rotate_y(deg_to_rad(face_direction.rotation.y * TURN_SPEED))
	navigation_agent.set_target_position(follow_target.global_transform.origin)
	velocity = (navigation_agent.get_next_path_position() - transform.origin).normalized() * SPEED * delta
	
	move_and_slide()

func walk_back_to_start(delta):
	face_direction.look_at(start_position, Vector3.UP)
	rotate_y(deg_to_rad(face_direction.rotation.y * TURN_SPEED))
	navigation_agent.set_target_position(start_position)
	velocity = (navigation_agent.get_next_path_position() - transform.origin).normalized() * SPEED * delta
	if int(self.position.x) == int(start_position.x) and int(self.position.z) == int(start_position.z):
		state_machine.transition_to("Idle")
	
	move_and_slide()

func attack_player():
	if combo:
		attack.emit()
	else:
		attack2.emit()
			
	combo = !combo
	velocity.x = 0
	velocity.z = 0
	sound_effects.start_sound("ATTACK")

func do_damage():
	var overlapping_bodies = damage_detection.get_overlapping_bodies()
	for body in overlapping_bodies:
		if(body.name == "Player"):
			follow_target.take_damage(damage_points)


func take_damage(amount: int):
	sound_effects.start_sound("GOT_HIT", true, 0.8, 1.2)
	health_points -= amount
	Input.start_joy_vibration(0, 1.0, 0.5, 0.35)
	#if(!stagger_resistance):
	#	stagger_resistance = true
	hit.emit()
	state_machine.transition_to("Hit")
	#	($Timer as Timer).start()

func hitbox_body_entered(body):
	if body.name == "Companion" and !invincible:
		take_damage(body.attack_damage)
		
func player_detection_area_body_entered(body):
	if body.name == "Player":
		state_machine.state.recive_event("player_detected")
	
func player_detection_area_body_exited(body):
	if body.name == "Player":
		state_machine.state.recive_event("walk_back")

func damage_detection_area_body_entered(body):
	if body.name == "Player":
		state_machine.state.recive_event("attack_player")
		
func damage_detection_area_body_exited(body):
	if body.name == "Player":
		state_machine.state.recive_event("follow_player")
		
func die():
	is_active = false
	in_combat = false
	is_dead = true
	set_process(false)
	set_physics_process(false)
	velocity.x = 0
	velocity.z = 0
	set_disable_mode(1)
	$CollisionShape3D.disabled = true
	$Hitbox/CollisionShape3D.disabled = true
	on_died.emit()
	state_machine.transition_to("Inactive")
	battle_music.check_if_enemy_in_combat()

func _on_door_smashed():
	state_machine.transition_to("Idle")

func _on_enemy_mesh_animation_signal(value):
	match(value):
		"attack": do_damage()

func _on_anim_finished(anim_name):
	match(anim_name):
		"Enemy/EnemyAttack":
			state_machine.state.recive_event("attack_end")
		"Enemy/EnemyAttack_Flipped":
			state_machine.state.recive_event("attack_end")
		"Enemy/EnemyHit":
			state_machine.state.recive_event("recovered")


func reset_stagger():
	stagger_resistance = false
