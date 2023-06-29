tool

extends Hitbox

func hit(obj):
	if obj is Fighter:
		if obj.current_state().get("parry_active"):
			obj.current_state().parry_active = false
	.hit(obj)
