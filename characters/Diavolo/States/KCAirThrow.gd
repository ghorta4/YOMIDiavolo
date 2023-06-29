extends CharacterState


func _frame_9():
	host.apply_force(str(host.get_facing_int() * 7 + 0.05 * float(data.x)), str(0.1 * float(data.y) - 7))
