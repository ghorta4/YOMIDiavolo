extends SuperMove

func init():
	.init()
	super_freeze_ticks = 0
	super_effect = false
	super_level = 9
	supers_used = 9
	pass

func is_usable():
	return .is_usable() and host.get_kc() != null and host.erasedFramesLeft <= 0
