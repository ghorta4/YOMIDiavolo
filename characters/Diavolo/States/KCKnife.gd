extends CharacterState

export (PackedScene) var projectile

export  var projectile_x = 16
export  var projectile_y = - 16
export  var speed_modifier_amount = "0.0"

const SPEED = "10"

var speed_modifier

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()

func _frame_0():
	if data:

		var dir = xy_to_dir(data.x, data.y)
		var vec = fixed.vec_mul(dir.x, dir.y, speed_modifier_amount)
		speed_modifier = fixed.vec_len(vec.x, vec.y)

func _frame_10():
	var object = host.spawn_object(projectile, projectile_x, projectile_y, true, {"speed_modifier":speed_modifier})
	
	var obj_state = object.state_machine.get_state("Default")
	var dir = xy_to_dir(data.x, data.y)
	dir.x = fixed.mul(dir.x, str(host.get_facing_int()))
	if air_type == AirType.Grounded:
		object.dir_x = fixed.mul(dir.x, SPEED)
		object.dir_y = fixed.mul(dir.y, SPEED)
	else :
		object.dir_x = fixed.mul(dir.x, SPEED)
		object.dir_y = fixed.mul(dir.y, SPEED)
