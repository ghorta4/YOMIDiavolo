extends BaseProjectile

const FOLLOWDISTANCE = 120.0
const Friction = "0.2"
const FollowSpeed = 0.03
const FollowAnimThreshold = 5
const MaxFollowForce = 90

export  var extra_color_1 = Color("711311")

var attacking = false

var memorizedDirection

var aura_particle

func init(pos = null):
	.init(pos)
	gravity_enabled = false
	has_projectile_parry_window = false
	
	if Global.enable_custom_colors:
		
		var style = creator.storedStyle
		var exColor1 = creator.storedExtraColor1
		
		if style == null || exColor1 == Color("711311"):
			return
		
		var aura1 = $Flip/Particles/Aura/OrbParticles2
		var aura2 = $Flip/Particles/Aura/OrbParticles3
		
		var acol1 = Color(creator.storedExtraColor2)
		var acol2 = Color(creator.storedExtraColor2)
		
		if aura1 != null && aura2 != null && acol1 != null:
			acol1.a = aura1.color.a
			aura1.color = acol1

			acol2.a = aura2.color.a
			acol2.r *= 0.9
			acol2.g *= 0.6
			acol2.b *= 0.4
			aura2.color = acol2
		
		
		Custom.apply_style_to_material(style, sprite.get_material())
		sprite.get_material().set_shader_param("extra_color_1", exColor1)
		sprite.get_material().set_shader_param("extra_replace_color_1", extra_color_1)
		sprite.get_material().set_shader_param("use_extra_color_1", true)
		
		
		if style != null && Global.enable_custom_particles and not is_ghost and style.show_aura and style.has("aura_settings"):
			aura_particle = preload("res://fx/CustomTrailParticle.tscn").instance()
			particles.add_child(aura_particle)
			aura_particle.load_settings(style.aura_settings)
			aura_particle.position = hurtbox_pos_float()
			aura_particle.start_emitting()
			if aura_particle.show_behind_parent:
				aura_particle.z_index = - 1
			else:
				aura_particle.z_index = 1
			



func tick():
	if hitlag_ticks > 0:
		hitlag_ticks -= 1
		return
	.tick()
	follow_owner()
	if is_instance_valid(aura_particle):
		aura_particle.visible = Global.enable_custom_particles
		aura_particle.position = hurtbox_pos_float()
		aura_particle.facing = get_facing_int()
		aura_particle.tick()

func hit_by(hitbox):
	if creator.erasedFramesLeft > 0:
		return
	#for farness, if an attack hits Crimson and not Diavolo, reduce enemy hitlag to a reasonable degree
	if isBeingHitWhileOwnerNotBeingHit():
		hitlag_ticks = min(hitlag_ticks, 6)
		creator.opponent.hitlag_ticks = min(creator.opponent.hitlag_ticks, 6)
	
	.hit_by(hitbox)

func isBeingHitWhileOwnerNotBeingHit():
	var opp_hitboxes = creator.opponent.get_active_hitboxes()

	for hitbox in opp_hitboxes:
		if hitbox.overlaps(creator.hurtbox):
			return false
	
	return true


func follow_owner():
	var targetPos = creator.position
	targetPos.y = targetPos.y - 30
	
	targetPos.x += float(creator.desiredStandOffset.x) / 2.0
	targetPos.y += float(creator.desiredStandOffset.y) / 2.0
	
	var pos =  get_pos()
	var difference = Vector2(targetPos.x - pos.x, targetPos.y - pos.y);
	
	if not attacking:
		z_index = 0
		apply_force(str(clamp(difference.x, -MaxFollowForce, MaxFollowForce) * FollowSpeed), str(clamp(difference.y,-MaxFollowForce, MaxFollowForce) * FollowSpeed))
		var xspeed = float(get_vel().x) 
		if xspeed == null: 
			xspeed = 0
		var facingInt = 1
		if xspeed < 0:
			facingInt = -1
		if abs(xspeed) > 5:
			set_facing(facingInt)
		
		if abs(xspeed) > FollowAnimThreshold:
			state_machine._change_state("Follow")
		elif creator.state_machine.state.name == "Taunt":
			state_machine._change_state("Hustle")
			set_facing(creator.get_facing_int())
		elif creator.state_machine.state.name == "Pose":
			state_machine._change_state("Pose")
			set_facing(creator.get_facing_int())
		else:
			state_machine._change_state("Wait")
	
	apply_x_fric(Friction)
	apply_y_fric(Friction)

func get_opponent():
	return creator.get_opponent()

func apply_hitboxes():
	if creator.erasedFramesLeft > 0 || creator.invulnFramesLeft > 0:
		return 
	.apply_hitboxes()

func copy_to(f):
	if f == null:
		return
	.copy_to(f)
	f.attacking = attacking
	f.set_facing(get_facing_int())
	f.memorizedDirection = memorizedDirection

func travel_towards_creator():
	return

func attempt_triggered_attack():
	return

func CallAttack(attack_type):
	var facingInt = creator.get_facing_int()
	set_facing(facingInt)
	memorizedDirection = creator.desiredStandOffset
	state_machine._change_state(attack_type)
	state_machine.tick() #done so that sprite doesnt linger on a teleport
	attacking = true
