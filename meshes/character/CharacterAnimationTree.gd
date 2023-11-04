extends AnimationTree

func Kill():
	set("parameters/conditions/IsDead", true)
	
func Revive():
	set("parameters/conditions/IsDead", true)

func SetRunning(IsRunning : bool):
	set("parameters/BlendTree/Running/blend_amount", 1 if IsRunning else 0)
	
func SetHit():
	set("parameters/BlendTree/GetHit/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func SetAttack():
	set("parameters/BlendTree/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

