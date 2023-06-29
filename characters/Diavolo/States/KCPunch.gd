extends CharacterState

func is_usable():
	var kc = host.get_kc()
	if kc != null:
		return false
	return .is_usable()
