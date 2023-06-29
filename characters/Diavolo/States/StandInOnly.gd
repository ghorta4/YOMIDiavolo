extends CharacterState

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()
