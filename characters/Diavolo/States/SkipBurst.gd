extends CharacterState

var started_falling = false

func _enter():
	host.opponent.reset_combo()
	started_falling = false
	host.use_burst()
	host.throw_invulnerable = true
	#host.start_invulnerability()

func _exit():
	host.throw_invulnerable = false
	host.invulnerable = false

func _frame_9():
	started_falling = true
	host.throw_invulnerable = false

func _frame_10():
	host.play_sound("guh")

func _tick():
	if started_falling:
		host.apply_grav()
	host.apply_forces()

	if current_tick > 9: #not throw immune after a wait
		return
	var opp_hitboxes = host.opponent.get_active_hitboxes()
	for hitbox in opp_hitboxes:
		if hitbox.throw && (hitbox.overlaps(host.hurtbox)):
			hitbox.deactivate()
			host.invulnerable = true
			#host.BurstCounter()
			return
	
	#disable grab projectiles here 
	var game = Global.current_game
	if host.is_ghost:
		game = game.ghost_game
	if game == null: return
	for object in game.objects:
		if object.disabled:
			continue
		if object.id != host.opponent.id:
			continue
		if not object.initialized:
			continue
		
		var objectHitboxes = object.get_active_hitboxes()
		for hb in objectHitboxes:
			if (hb.overlaps(host.hurtbox)):
				hb.deactivate()
				#host.BurstCounter()
				return

func is_usable():
	return host.burst_enabled and .is_usable() and (host.bursts_available > 0) and host.erasedFramesLeft <= 0
