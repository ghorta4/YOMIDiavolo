extends CharacterState

func _enter():
	host.throw_invulnerable = true
	#host.start_invulnerability()

func _exit():
	host.throw_invulnerable = false


func _tick():

	var opp_hitboxes = host.opponent.get_active_hitboxes()
	for hitbox in opp_hitboxes:
		if hitbox.throw && (hitbox.overlaps(host.hurtbox)):
			hitbox.deactivate()
			host.invulnerable = true
			host.OnGrabCounter()
			return
		#Do hits that have followups into grabs, such as robot's TRY: CATCH (aka Disembowel)
		var followUp = hitbox.followup_state
		if(followUp != null):
			var followedState = null
			for state in host.opponent.state_machine.get_children():
				if state.name == followUp:
					followedState = state
					break
			if followedState != null && followedState is ThrowState:
				hitbox.deactivate()
				host.invulnerable = true
				host.OnGrabCounter()
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
			if (hb.overlaps(host.hurtbox) && host.projectileHitboxIsGrab(hb)):
				hb.deactivate()
				host.OnGrabCounter()
				return
	

func is_usable():
	var hasKC = host.get_kc() != null
	return hasKC and .is_usable()
