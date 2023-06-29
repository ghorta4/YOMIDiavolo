extends CharacterState

func is_usable():
	var usable = false
	var kc = host.get_kc()
	if kc != null:
		usable = kc.attacking
	return .is_usable() and usable

func _frame_1():
	var kc = host.get_kc()
	if kc == null: return
	kc.apply_force(str(float(data.x)/10.0), str(float(data.y)/7.0))
