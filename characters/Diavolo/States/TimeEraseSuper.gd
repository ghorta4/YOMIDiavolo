extends SuperMove

func init():
	.init()
	super_freeze_ticks = 45
	super_effect = true
	super_level = 6
	supers_used = 6
	pass

func is_usable():
	return .is_usable() and host.erasedFramesLeft <= 0 and host.get_kc() != null

func _enter():
	host.start_invulnerability()
	host.start_projectile_invulnerability()
	host.invulnFramesLeft = 20
	host.TimeErase(120)
	host.opponent.hitstun_decay_combo_count = 0
	#host.opponent.hitlag_ticks += 15
	

func _frame_8():
	host.spawn_particle_effect(host.TIMEERASEPARTICLE, Vector2(0,0))
	host.applyPostTimeEraseLag = true

func _frame_7():
	host.spawn_particle_effect_relative(host.TIMEERASESTART, Vector2(0,-15))

func _frame_15():
#	host.TimeErase(120)
#	host.opponent.hitstun_decay_combo_count = 0
#	#host.opponent.hitlag_ticks = 92
	host.spawn_particle_effect(host.TIMEERASEBACK, Vector2(0,0))
