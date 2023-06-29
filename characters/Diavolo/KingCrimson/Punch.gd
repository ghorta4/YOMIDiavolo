extends ObjectState

func _exit_shared():
	host.attacking = false

func _frame_1():
	host.apply_force(str(float(host.memorizedDirection.x)/8.0), str(float(host.memorizedDirection.y)/10.0))

func _frame_18():
	host.apply_force(str(host.get_facing_int() * 50), str(0))
