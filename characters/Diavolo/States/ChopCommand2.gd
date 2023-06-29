extends CharacterState

func is_usable():
	var usable = false
	var kc = host.get_kc()
	if kc != null:
		usable = not kc.attacking
	return .is_usable() and usable

func _frame_1():
	host.CallCommand("Chop2")
	pass
