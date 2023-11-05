extends AnimationTree

@export
var player : PlayerController

func _ready():
	active = true

func _process(delta):
	if player == null:
		return

	SetRunning(player.velocity.length_squared() > 1)

func Kill():
	set("parameters/conditions/IsDead", true)
	
func Revive():
	set("parameters/conditions/IsDead", true)

func SetRunning(IsRunning : bool):
	set("parameters/BlendTree/Running/blend_amount", 1 if IsRunning else 0)
	
func SetHit():
	set("parameters/BlendTree/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	set("parameters/BlendTree/GetHit/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func SetAttack():
	set("parameters/BlendTree/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func SetAttack2():
	set("parameters/BlendTree/Attack2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
