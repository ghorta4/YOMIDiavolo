extends SuperMove

func _frame_0():
	var kc = host.get_kc()
	if kc == null:
		var pos = host.desiredStandOffset
		host.spawn_kc(Vector2(float(pos.x) * 0.6 * owner.get_facing_int(),float(pos.y) * 0.6))
	
	host.summonCanTP = false

func _frame_1():
	host.CallCommand("Rush")
	host.summonCanTP = false
