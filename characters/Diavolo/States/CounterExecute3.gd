extends ThrowState

func _frame_59():
	host.z_index = 0
	host.spawn_particle_effect(host.STANDOUT, Vector2(float(host.get_pos().x), float(host.get_pos().y)))
	host.play_sound("standIn")
	host.CreateAfterImage(host, host.color)
