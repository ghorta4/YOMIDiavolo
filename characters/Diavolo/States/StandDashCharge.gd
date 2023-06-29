extends CharacterState

func is_usable():
	var usable = false
	var kc = host.get_kc()
	if kc == null:
		usable = true
	return .is_usable() and usable


func _frame_6():
	queue_state_change("StandDash", {"x":100, "charged":true})
