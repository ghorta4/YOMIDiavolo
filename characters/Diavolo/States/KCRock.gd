extends CharacterState

export (PackedScene) var projectile

export  var projectile_x = 16
export  var projectile_y = - 16

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()
	


func _frame_13():
	for i in 3:
		var object = host.spawn_object(projectile, projectile_x, projectile_y, true, str(5))
		var obj_state = object.state_machine.get_state("Default")
		object.set_vel(str((5 +  i * 3 + sin(i)) * host.get_facing_int()), str(-10 + i * 3))
		object.frameSelect = i
