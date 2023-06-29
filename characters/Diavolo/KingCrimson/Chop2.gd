extends ObjectState

func _exit_shared():
	host.attacking = false

func _frame_1():
	host.apply_force(str(float(host.memorizedDirection.x)/20.0), str(float(host.memorizedDirection.y)/20.0))

func _frame_6():
	host.apply_force(str(float(host.memorizedDirection.x)/9.0), str(float(host.memorizedDirection.y)/15.0))
