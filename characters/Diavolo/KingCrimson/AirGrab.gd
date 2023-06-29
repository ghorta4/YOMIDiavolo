extends ObjectState

func _on_hit_something(obj, hitbox):
	#._on_hit_something(obj, hitbox)
	if obj is Fighter:
		host.creator.OnAirGrab()
		terminate_hitboxes()
	else :
		._on_hit_something(obj, hitbox)

func _exit_shared():
	host.attacking = false

func _frame_5():
	host.apply_force(str(float(host.memorizedDirection.x)/20.0 + host.get_facing_int() * 10), str(-14 + float(host.memorizedDirection.y)/14.0))
