extends CharacterBody3D
class_name PlayerController


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LOOK_SENSITIVITY = 0.0025

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_pivot = $Camera_Pivot
@onready var camera = $Camera_Pivot/Camera3D
@onready var attack_location = $Attack_Location

@export var companion: CharacterBody3D

signal on_attack
signal on_hit

var theta = 0
var dtheta = 0
var in_attack_animation = false
var in_hit_animation = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if companion != null:
		init_companion_rotation()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if companion != null and companion.get_state_as_string() == "IDLE":
		companion.transform = rotate_around(self.transform, companion.transform)
	
	if !in_attack_animation and !in_hit_animation:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			$WalkingSteps.start_walking()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			$WalkingSteps.stop_walking()

		move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

	if Input.is_action_just_pressed("attack") and companion != null:
		$WalkingSteps.stop_walking()
		if !in_attack_animation and !in_hit_animation:
			in_attack_animation = true
			companion.get_node("CollisionShape3D").disabled = false
			var tween = create_tween()
			tween.tween_property(companion, 'position', attack_location.global_position, companion.attack_speed)
			tween.tween_property(companion, 'position', companion.transform.origin, companion.attack_speed)
			tween.connect("finished", on_tween_finished)
			on_attack.emit()
			companion.change_state("ATTACK")
			

func _input(event):
	if event is InputEventMouseMotion:
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
	print("OUCH! I got hit!")
	in_hit_animation = true
	in_attack_animation = false
	on_hit.emit()


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "GetHit":
		in_hit_animation = false
	elif anim_name == "Pointing":
		in_attack_animation = false
