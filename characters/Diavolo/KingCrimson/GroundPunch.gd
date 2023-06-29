extends ObjectState

func _exit_shared():
	host.attacking = false


func _frame_1():
	host.apply_force(str(float(host.memorizedDirection.x) / 6.0), str(float(host.memorizedDirection.y)/9.0))

func _frame_19():
	host.apply_force(str(4 * host.get_facing_int()), "9")

