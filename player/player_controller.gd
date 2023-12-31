extends CharacterBody3D
class_name PlayerController


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LOOK_SENSITIVITY = 0.0025
const LOOK_SENSITIVITY_CONTROLLER = 0.035

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var companion: CharacterBody3D
@export var sound_effects: PlayerSoundEffects
@export var max_health: float = 3
@export var health_regen_factor: float = 0.05

@onready var camera_pivot = $Camera_Pivot
@onready var camera = $Camera_Pivot/Camera3D
@onready var attack_location = $Attack_Location
@onready var raycast = $Raycast

signal on_attack
signal on_hit
signal died

var in_dialog = false
var theta = 0
var dtheta = 0
var in_attack_animation = false
var in_hit_animation = false
var controls_disabled = true
var hit_points: float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if companion != null:
		init_companion_rotation()

func _physics_process(delta):
	# Test health regeneration
	if hit_points > 0.0:
		hit_points = hit_points - (health_regen_factor * delta)
		update_blood_effect()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if companion != null and companion.get_state_as_string() == "IDLE":
		companion.transform = rotate_around(self.transform, companion.transform)
	
	if !in_attack_animation and !in_hit_animation:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Vector3.ZERO
		var cam_input_dir = Vector3.ZERO
		if(!controls_disabled):
			input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
			cam_input_dir = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down")
		
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			# TODO: Turning isn't smooth
			# Make look_at rotation smooth instead of chopy
			# Maybe something with lerp
			$MainCharacter.look_at(self.position - direction)
#			var tween_rotate = create_tween()
#			tween_rotate.tween_property($MainCharacter, "rotation_degrees", self.position - direction, 0.1)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
		rotate_y(-cam_input_dir.x * LOOK_SENSITIVITY_CONTROLLER)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

	if Input.is_action_just_pressed("attack") and companion != null:
		if !in_attack_animation and !in_hit_animation and !in_dialog:
			var tween_rotate = create_tween()
			tween_rotate.tween_property($MainCharacter, "rotation_degrees", Vector3(0, 180, 0), 0.1)
			sound_effects.start_sound("HIT", true)
			in_attack_animation = true
			companion.get_node("CollisionShape3D").disabled = false
			
			var tween = create_tween()
			var collider = raycast.get_collider()
			if collider != null and !collider.is_in_group("enemy") and !collider.is_in_group("door"):
				var target = raycast.get_collision_point()
				tween.tween_property(companion, 'position', target, companion.attack_speed)
				tween.tween_property(companion, 'position', companion.transform.origin, companion.attack_speed)
			else:
				tween.tween_property(companion, 'position', attack_location.global_position, companion.attack_speed)
				tween.tween_property(companion, 'position', companion.transform.origin, companion.attack_speed)
			
			tween.connect("finished", on_tween_finished)
			on_attack.emit()
			companion.change_state("ATTACK")
			

func _input(event):
	if event is InputEventMouseMotion:
		if !in_attack_animation and !in_hit_animation and !controls_disabled:
			# Swap out the below code lines to have the player rotate with the camera or not
			rotate_y(-event.relative.x * LOOK_SENSITIVITY)
			#camera_pivot.rotate_y(-event.relative.x * LOOK_SENSITIVITY)

func rotate_around(rotation_center: Transform3D, rotator: Transform3D):
	theta += dtheta
	rotator.origin.x = rotation_center.origin.x + companion.circle_radius * cos(theta)
	rotator.origin.z = rotation_center.origin.z + companion.circle_radius * sin(theta)
	rotator.origin.y = rotator.origin.y + companion.bounce_height * sin(theta * companion.bounce_speed)
	return rotator

func on_tween_finished():
	companion.change_state("IDLE")
	# TODO: Decide if the companion should do damage on the
	# way back to player or not
	companion.get_node("CollisionShape3D").disabled = true

func init_companion_rotation():
	dtheta = (2 * PI / companion.circle_speed)

func take_damage(amount: int):
	sound_effects.start_sound("GOT_HIT")
	in_hit_animation = true
	in_attack_animation = false
	on_hit.emit()
	hit_points += 1
	update_blood_effect()
	if(hit_points >= max_health):
		die()

func die():
	set_process(false)
	set_physics_process(false)
	died.emit()
	await get_tree().create_timer(1.0).timeout
	SceneTransition.change_scene("res://ui/Game_Over.tscn")

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "GetHit":
		in_hit_animation = false
	elif anim_name == "Pointing":
		in_attack_animation = false


func _on_dialog_trigger_3_dialog_entered():
	companion = get_tree().get_first_node_in_group("Companion")
	init_companion_rotation()


func _on_dialogue_box_dialogue_started(id):
	in_dialog = true


func _on_dialogue_box_dialogue_ended():
	in_dialog = false


func _on_dialogue_box_dialogue_signal(value):
	match(value):
		"enable_controlls": controls_disabled = false
		
func update_blood_effect():
	var tween = create_tween()
	tween.tween_property($Camera_Pivot/Camera3D/Blood_Effect, 'modulate:a', (hit_points / 2), 0.75)
