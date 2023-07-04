extends "res://DiavoloChar/characters/Diavolo/CompositeTemplate.gd"

const CRIMSON_SCENE = preload("res://DiavoloChar/characters/Diavolo/KingCrimson/Crimson.tscn")

const SKIPSTATIC = preload("res://DiavoloChar/characters/Diavolo/Particles/SkipStatic.tscn")

const TIMEERASEPARTICLE = preload("res://DiavoloChar/characters/Diavolo/Particles/TimeEraseParticle.tscn")
const TIMEERASEBACK = preload("res://DiavoloChar/characters/Diavolo/Particles/TimeEraseBkgnd.tscn")

const TIMEERASESTART = preload("res://DiavoloChar/characters/Diavolo/Particles/TimeEraseStart.tscn")
const TIMEERASEEND = preload("res://DiavoloChar/characters/Diavolo/Particles/TimeEraseEnd.tscn")

const AFTERIMAGE = preload("res://DiavoloChar/characters/Diavolo/Particles/Afterimage.tscn")

const COUNTERFLASH = preload("res://DiavoloChar/characters/Diavolo/Particles/CounterFlash.tscn")
const COUNTERBKGND = preload("res://DiavoloChar/characters/Diavolo/Particles/CounterBackground.tscn")

const STANDOUT = preload("res://DiavoloChar/characters/Diavolo/Particles/StandOut.tscn")

const IRONBAR = preload("res://DiavoloChar/characters/Diavolo/Particles/IronBar.tscn")
const IRONBARNOFADE = preload("res://DiavoloChar/characters/Diavolo/Particles/IronBarNoFade.tscn")
const FAKEARM = preload("res://DiavoloChar/characters/Diavolo/KingCrimson/CrimsonArmFFX.tscn")

const TICKAFTER = preload("res://DiavoloChar/characters/Diavolo/ForceInactionable.tscn")

const MENACING = preload("res://DiavoloChar/characters/Diavolo/Particles/Menacing.tscn")
const THUM = preload("res://DiavoloChar/characters/Diavolo/Particles/Thum.tscn")

var kingCrimsonID

var desiredStandOffset = {"x":0, "y":0}
var framesToSkip = -1

var erasedFramesLeft = 0
var invulnFramesLeft = 0
var epitaphFramesLeft = 0
var timeEraseEnded = true
var memorizedDirection = {}
var opponentIsDummy = false
var summonCanTP = true
var randList = [] #used to seed RNG so timeskip predictions are more accurate

var TimeEraseSlowdownCounter = 0 # used to slow down enemy

var postGrabVisuals #done because timeskip interferes with some graphical flair, so graphics need to be called on the next frame

var idleFrame = 0
var menacingTick = 0
var thumTick = 0

var applyPostTimeEraseLag = false

var lastDodgePose = 0

var storedExtraColor1
var storedExtraColor2

var RestoreComboStateDue = false

var temporal_modifiers = {
	"timeskip":{
		"incorporeal":true,
		"standpause":true,
	},
	"timeerase":{
		"incorporeal":true,
	},
}

var incorporeal = false

var is_multihustle = false

const TIMESKIP_FRAMEPAUSE = 2

var fakeHitbox = {"hitbox": {"disable_collision": true, "hit_height": Hitbox.HitHeight.High, "hitstun_ticks" : 60, "counter_hit" : false,
	"wall_slam" : false, "dir_x" : "1.0", "dir_y" : "0", "facing" : "None", "reversible" : false, "pos_x" : 0, "pos_y" : 0, "knockback" : "0",
	"di_modifier" : "0", "hitbox_type" : Hitbox.HitboxType.Normal, "vacuum" : false, "send_away_from_center" : false, "knockdown" : false , "hard_knockdown" : false,
	"ground_bounce" : false, "knockdown_extends_hitstun" : false, "air_ground_bounce" : false,  "minimum_grounded_frames" : 0
	}}

const EPOKStates = ["Wait", "ParryHigh", "ParryLow", "ParryAir", "Burst", "Fall", "Landing", "Getup", "TechRoll", "DashForward", "ChargeDashForward", "DashStartup", "Jump", "ChargeDash",
"InstantCancel", "Summon", "Desummon", "TimeSkip1", "TimeSkipSuper", "TimeSkipBurst", "TimeEraseSuper", "TimeEraseEnd", "CounterSuper", "EpitaphSuper", "EpitaphDodge", "StandDashCharge",
"StandDash", "TeleDodge", "TeleTech", "AirTele", "Walk", "Pose", "CallBoss"]

#overrides

func copy_to(f):
	.copy_to(f)
	f.kingCrimsonID = kingCrimsonID
	f.position = position
	f.desiredStandOffset = desiredStandOffset
	f.incorporeal = incorporeal
	f.invulnerable = invulnerable
	f.projectile_invulnerable = projectile_invulnerable
	f.throw_invulnerable = throw_invulnerable
	f.erasedFramesLeft = erasedFramesLeft
	f.framesToSkip = framesToSkip
	f.timeEraseEnded = timeEraseEnded
	f.opponentIsDummy = opponentIsDummy
	f.invulnFramesLeft = invulnFramesLeft
	f.memorizedDirection = memorizedDirection.duplicate(true)
	f.randList = randList.duplicate()
	f.summonCanTP = summonCanTP
	f.postGrabVisuals = postGrabVisuals
	f.repeatBarSpawnAsEndOfRoundFinisher = repeatBarSpawnAsEndOfRoundFinisher
	f.epitaphFramesLeft = epitaphFramesLeft
	f.TimeEraseSlowdownCounter = TimeEraseSlowdownCounter
	f.applyPostTimeEraseLag = applyPostTimeEraseLag
	f.time_skip = time_skip
	f.RestoreComboStateDue = RestoreComboStateDue
	f.initialComboStats = initialComboStats
	f.temporal_modifiers = temporal_modifiers.duplicate(true)

var alreadyConnected
func init(pos = null):
	.init(pos)
	IncorporealSET(self, false) # REVIEW - This shouldn't be neccecary, but I left it for now to be sure
	if not alreadyConnected:
		alreadyConnected = true
		connect("particle_effect_spawned", self, "OnParticleSpawned")
	is_multihustle = Global.current_game.get("players") is Dictionary

func setupRandList():
	randList.clear()
	for i in 255:
		randList.append(randi_range(0, 999))
	return

var afterimageCounter = 0
var repeatBarSpawnAsEndOfRoundFinisher = false

func tick():

	TickTimeErase()
	.tick() #================================================================

	#restore combos so timeskip cant reset them
	#ComboRestoreChecker()

	UpdateParticleCache()

	if epitaphFramesLeft > 0:
		epitaphFramesLeft -= 1
		if not state_machine.state.name in EPOKStates:
			epitaphFramesLeft = 0

	if state_machine.state.name == "Walk":
		menacingTick += 1
		if menacingTick >= 12:
			menacingTick -= 12
			spawn_particle_effect(MENACING, Vector2(float(get_pos().x) - 15,float(get_pos().y)- 25), Vector2(1,1))
			var opponentIsWalking = CheckEasterEgg(opponent, "DiavoloWalk", null) != null || ("Walk" in opponent.state_machine.state.name) || ("Walk" in opponent.state_machine.state.title) || ("Walk" in opponent.state_machine.state.sprite_animation)
			if opponentIsWalking:
				spawn_particle_effect(MENACING, Vector2(float(opponent.get_pos().x) - 15,float(opponent.get_pos().y)- 25), Vector2(1,1))

	if state_machine.state.name == "Pose":
		thumTick += 1
		if thumTick >= 10:
			thumTick -= 10
			spawn_particle_effect(THUM, Vector2(float(get_pos().x) - 15,float(get_pos().y)- 25), Vector2(1,1))
			CheckEasterEgg(opponent, "PoseParticle", THUM)

	if state_machine.state.name == "TimeSkipBurst":
		var opponentStateType = opponent.state_machine.state.type
		var opponentIsAttacking = opponent.state_machine.state.current_tick < 2 && (opponentStateType == 1 || opponentStateType == 2 || opponentStateType == 3)
		if state_machine.state.current_tick < 9 && opponentIsAttacking:
			BurstCounter()

	if framesToSkip <= 0 && postGrabVisuals == "CounterGrab":
		var kc = get_kc()
		var arm = spawn_object(FAKEARM, kc.get_pos().x, kc.get_pos().y)
		arm.toFollow = kc
		postGrabVisuals = null
		var camera = get_camera()
		if camera:
			camera.bump(Vector2(0.3, 1), 70, 0.6)


	if framesToSkip <= 0 && postGrabVisuals == "AirGrab":
		release_opponent()
		postGrabVisuals = null
		var desiredX = clamp(float(opponent.get_pos().x + get_facing_int() * -2) , -stage_width + 7, stage_width - 7)
		spawn_particle_effect(IRONBAR, Vector2(desiredX, -65))
		play_sound("Impale")
		var camera = get_camera()
		if camera:
			camera.bump(Vector2(1, 1), 30, 0.8)

		#add extra flair if this is the finishing move
		if opponent.hp <= 0:
			if camera:
				camera.bump(Vector2(1, 1), 40, 1.2)
			opponent.hitlag_ticks += 60
			spawn_particle_effect(IRONBARNOFADE, Vector2(desiredX, -65))
			repeatBarSpawnAsEndOfRoundFinisher = true



	if repeatBarSpawnAsEndOfRoundFinisher:
		ClearParticles()
		if opponent.hp > 0:
			repeatBarSpawnAsEndOfRoundFinisher = false
		var desiredX = clamp(float(opponent.get_pos().x + get_facing_int() * -2) , -stage_width + 7, stage_width - 7)
		spawn_particle_effect(IRONBAR, Vector2(desiredX, -65))


	var kc = get_kc()
	if kc != null: #in the case a fighter happens to modify (or otherwise break) KC, return KC to normal. Looking at YOU vixen
		kc.creator = self
		kc.fighter_owner = self
		kc.damages_own_team = false
		kc.can_be_hit_by_melee = true
		kc.got_parried = false
		kc.id = id

		#make it so tackle cant be looped
		if !kc.attacking:
			summonCanTP = true
	if invulnFramesLeft > 0:
		invulnFramesLeft -= 1
		IncorporealSET(self, true)
	if state_machine.state.name == "CounterExecute2":
		spawn_particle_effect_relative(TIMEERASEBACK, Vector2(0,0))

	if time_skip >= 0:
		TimeSkip(time_skip)
	#spawn_object(TICKAFTER, 0, 0)

var storedStyle
func apply_style(style):
	if style != null && style.extra_color_1 != null:
		var extraUsed = Color(style.extra_color_1)
		if style.extra_color_1 == Color("ffffff"):
			extraUsed = Color("711311")
			style.extra_color_1 = extraUsed

	.apply_style(style)
	if style != null:
		storedExtraColor1 = style.get("extra_color_1")
		storedExtraColor2 = style.get("extra_color_2")
		storedStyle = style

func tick_after():
	if applyPostTimeEraseLag:
		applyPostTimeEraseLag = false
		opponent.hitlag_ticks += 15

# TODO - Figure out why this doesn't update properly until you preview a move
# LINK[id=Extras] DiavoloChar\characters\Diavolo\DiavoloExtra.gd#Extras
func process_extra(extra):
	.process_extra(extra)
	if extra.has("desiredOffset"):
		desiredStandOffset = extra["desiredOffset"]


func thrown_by(hitbox):
	if erasedFramesLeft > 0 || invulnFramesLeft > 0:
		return
	.thrown_by(hitbox)

func hit_by(hitbox):
	if erasedFramesLeft > 0 || invulnFramesLeft > 0:
		return
	var host = objs_map[hitbox.host]
	var projectile = not host.is_in_group("Fighter")
	if state_machine.state.name == "CounterSuper" && state_machine.state.current_tick > 4 && not projectile && not IsBeingGrabbed():
		state_machine._change_state("CounterExecute")
		invulnFramesLeft = 150
		opponent.hitlag_ticks = 65
		set_y(float(get_position().y) - 1)
		set_vel(str(float(get_vel().x) / 4.0 - get_facing_int() * 300), str(float(get_vel().y) / 4.0))
		kill_kc()
		z_index = -2
		return

	if epitaphFramesLeft > 0 && not hitbox.throw:
		var isCommandThrow = IsBeingGrabbed()
		if not isCommandThrow:
			if state_machine.state.name != "EpitaphDodge":
				epitaphFramesLeft += 20
				epitaphFramesLeft = min(epitaphFramesLeft, 120)
			state_machine._change_state("EpitaphDodge")
			if opponent.hitlag_ticks < 40:
				opponent.hitlag_ticks = min(40, opponent.hitlag_ticks + 20)
			return
	.hit_by(hitbox)

# REVIEW - apply_hitboxes() does not exist in any child classes
func apply_hitboxes():
	if erasedFramesLeft > 0 || invulnFramesLeft > 0:
		return
	.apply_hitboxes()

func is_colliding_with_opponent():
	if incorporeal: return false
	if "Counter" in state_machine.state.name: return false
	if erasedFramesLeft > 0: return false
	return .is_colliding_with_opponent()

#restore combos so timeskip doesnt reset combos. Done here so we can wait for enemy tick
func get_active_hitboxes():
	ComboRestoreChecker()
	if !timeEraseEnded && incorporeal:
		return []
	return .get_active_hitboxes()

#customs

func get_kc():
	if kingCrimsonID == null:
		return null
	if not objs_map.has(kingCrimsonID):
		return null
	return objs_map[kingCrimsonID]

func kill_kc():
	var kc = get_kc()
	if kc == null:
		return
	spawn_particle_effect(STANDOUT, Vector2(float(kc.get_pos().x), float(kc.get_pos().y)))
	play_sound("standIn")
	kc.sprite.hide()
	kc.stop_particles()
	kc.state_machine.state.terminate_hitboxes()
	kc.disabled = true
	if kc.aura_particle != null:
		kc.aura_particle.stop_emitting()
		kc.aura_particle.visible = false
		kc.aura_particle.queue_free()
	kingCrimsonID = null

func spawn_kc(offset = Vector2(0,0)):
	var kc = spawn_object(CRIMSON_SCENE, - 5 + offset.x, - 25 + offset.y)
	spawn_particle_effect(STANDOUT,Vector2(float(kc.get_pos().x), float(kc.get_pos().y)))
	kingCrimsonID = kc.obj_name
	play_sound("standOut")

func BurstCounter():
	set_pos(get_pos().x, 0)
	TimeSkip(60)
	#opponent.state_machine._change_state("HurtAerial", fakeHitbox)
	state_machine._change_state("Wait")
	#opponent.hitlag_ticks = 70

func TimeSkipLoop(): #This runs a number of frames in a row over a short span; can't act in this time
	var game = MyGame()

	if !is_instance_valid(game):
		print_debug("Invalid game")
		IncorporealSET(self, false)
		return

	if framesToSkip > 0:
		if framesToSkip > 1:
			game.super_freeze_ticks = 1
		else:
			if game.super_freeze_ticks < TIMESKIP_FRAMEPAUSE:
				game.super_freeze_ticks = TIMESKIP_FRAMEPAUSE
		if temporal_modifiers["timeskip"]["incorporeal"]:
			IncorporealSET(self, true)
	else:
		TimeSkipEnd()
		return

	call_deferred("WaitForDeferred", 10)
	yield(self, "queueFreed")

	var notGhostReminder = []
	var notDisabledReminder = []

	for object in game.objects:
		if object.disabled:
			continue
		if !object.is_ghost:
			notGhostReminder.append(object)
		object.is_ghost = true #done to prevent crash from whiff sounds not loading
		if temporal_modifiers["timeskip"]["standpause"] && object.name == kingCrimsonID:
			notDisabledReminder.append(object)
			object.disabled = true
	game.simulate_one_tick()

	for object in notGhostReminder:
		object.is_ghost = false
	for object in notDisabledReminder:
		object.disabled = false

	framesToSkip -= 1
	TimeSkipLoop()

func WaitForDeferred(cycles:int = 1):
	if cycles > 1:
		call_deferred("WaitForDeferred", cycles-1)
		return
	emit_signal("queueFreed")
signal queueFreed()

var time_skip = -1 #for compatibility with other mods
var initialComboStats = {}
func TimeSkip(frames):
	time_skip = -1 # Direct calls take priority, and stops looping

	if framesToSkip < frames:
		framesToSkip = frames
	if temporal_modifiers["timeskip"]["incorporeal"] && invulnFramesLeft < framesToSkip:
		invulnFramesLeft = framesToSkip

	ignoreEndFFX = ReplayManager.resimulating

	StoreComboStats()
	RestoreComboStateDue = true
	TimeSkipLoop()

var ignoreEndFFX
func TimeSkipEnd():
	var game = MyGame()

	if temporal_modifiers["timeskip"]["incorporeal"]:
		IncorporealSET(self, false)

	if !ignoreEndFFX:
		spawn_particle_effect(SKIPSTATIC, Vector2.ZERO)
		play_sound("timeSkip")
		activeSkipEffect = yield(self, "particle_effect_spawned")

var activeSkipEffect
func _process(delta):
	if !is_instance_valid(activeSkipEffect):
		return
	var game = MyGame()
	if !is_instance_valid(game):
		return
	var is_paused = game.get("game_paused")
	if is_paused == null:
		return
	if is_paused:
		activeSkipEffect.tick()

#so time skip doesnt just reset your combo for free
func StoreComboStats():
	initialComboStats = {
		"combo_count" : combo_count,
		"visible_combo_count" : visible_combo_count,
		"combo_damage" : combo_damage,
		"hitstun_decay_combo_count" : hitstun_decay_combo_count,
		"combo_proration" : combo_proration,
		"combo_moves_used" : combo_moves_used,
		"combo_supers" : combo_supers,
		"trail_hp" : opponent.trail_hp,
		"wall_slams" : opponent.wall_slams,
		"hit_out_of_brace" : opponent.hit_out_of_brace,
		"braced_attack" : opponent.braced_attack,
		"brace_effect_applied_yet" : opponent.brace_effect_applied_yet
	}

func RestoreComboStats(i):
	combo_count = i.combo_count
	visible_combo_count = i.visible_combo_count
	combo_damage = i.combo_damage
	hitstun_decay_combo_count = i.hitstun_decay_combo_count
	combo_proration = i.combo_proration
	combo_moves_used = i.combo_moves_used
	combo_supers = i.combo_supers

	opponent.trail_hp = i.trail_hp
	opponent.wall_slams = i.wall_slams
	opponent.hit_out_of_brace = i.hit_out_of_brace
	opponent.braced_attack = i.braced_attack
	opponent.brace_effect_applied_yet = i.brace_effect_applied_yet

func ComboRestoreChecker():
	if not RestoreComboStateDue:
		return

	if not state_interruptable && not opponent.state_interruptable:
		return

	if opponent.state_interruptable && not opponent.busy_interrupt:
		RestoreComboStateDue = false
		return
	#RestoreComboStateDue = false
	if visible_combo_count > initialComboStats.visible_combo_count || combo_count > initialComboStats.visible_combo_count:
		return
	RestoreComboStats(initialComboStats)

func TimeErase(frames): #this creates a period of invulnerability for both diavolo and his opponent. its also a nightmare to make work over wireless. my mercy upon anyone who tries to fix it
	erasedFramesLeft = frames
	if temporal_modifiers["timeerase"]["incorporeal"]:
		IncorporealSET(self, true)

	# I really wish there were proper delegates in Godot, or at least params
	if !is_multihustle:
		TimeErase_Internal(opponent)
	else:
		var game = MyGame()
		if is_instance_valid(game):
			for player in game.players.values():
				if player != self:
					TimeErase_Internal(player)

	timeEraseEnded = false

func TimeErase_Internal(opponent):
	opponentIsDummy = opponent.dummy # FIXME - Needs to be retooled for MH support

	#if false && not Network.multiplayer_active:
	#	opponent.dummy = true #we don't do it this way because its glitchy. instead. we do it by setting the opponent's state_interruptable to false, which is about the same thing
	#opponent.state_interruptable = false #doing it this way is just like... freaking impossible man

	set_composite_variable("burst_enabled", false, opponent)

	memorizedDirection[opponent.id] = opponent.get_facing_int()

func TickTimeErase():
	if erasedFramesLeft > 0:
		spawn_particle_effect(TIMEERASEBACK, Vector2(0,0))

		erasedFramesLeft -= 1
		afterimageCounter += 1

		if temporal_modifiers["timeerase"]["incorporeal"]:
			IncorporealSET(self, true)

		if !is_multihustle:
			TickTimeErase_Internal(opponent)
		else:
			var game = MyGame()
			if is_instance_valid(game):
				for player in game.players.values():
					if player != self:
						TickTimeErase_Internal(player)
	else:
		if timeEraseEnded == false:
			EndTimeErase()

func TickTimeErase_Internal(opponent):
		spawn_particle_effect(TIMEERASEBACK, Vector2(0,0))

		# FIXME - This seems to bug out the preview on any attacks with flip enabled
		opponent.set_facing(memorizedDirection[opponent.id])

		#erm, slow down the enemy
		TimeEraseSlowdownCounter += 1
		if TimeEraseSlowdownCounter >= 4:
			TimeEraseSlowdownCounter -= 4
			opponent.hitlag_ticks += 3
			var game = MyGame()
			if !is_instance_valid(game):
				print_debug("Invalid game")
			else:
				for obj in game.objects:
					if obj.name == kingCrimsonID:
						continue
					obj.hitlag_ticks += 3

		"""
		#make enemy automatically attack
		#oh how I would love for the below code to work correctly. but it does not! Netcode, you are my bane. Instead, I'll apply a slowdown to the foe instead
		if not opponentIsDummy:
			if (opponent.state_interruptable || opponent.dummy_interruptable || opponent.current_state().name == "Wait" || opponent.current_state().name == "Fall"):
				####ForceRandomAttack(opponent) ===do not use
				if not opponent.use_buffer:
					ForceBufferedAttack(opponent)
		"""

func EndTimeErase():
	timeEraseEnded = true
	if temporal_modifiers["timeerase"]["incorporeal"]:
		IncorporealSET(self, false)
	erasedFramesLeft = 0

	if !is_multihustle:
		EndTimeErase_Internal(opponent)
	else:
		var game = MyGame()
		if is_instance_valid(game):
			for player in game.players.values():
				if player != self:
					EndTimeErase_Internal(player)

	spawn_particle_effect_relative(TIMEERASEEND, Vector2(0,-15))
	play_sound("timeResumes")

func EndTimeErase_Internal(opponent):
	#opponent.dummy = opponentIsDummy
	set_composite_variable("burst_enabled", true, opponent)

func CallCommand(commandName):
	var kc = get_kc()
	if kc == null:
		return
	kc.CallAttack(commandName)

var tempTexture
var carryoverColor
func CreateAfterImage(target, col = Color(1,1,1,1)):
	var spriteNode = target.sprite
	if spriteNode == null:
		return
	var targetFrame = spriteNode.frame
	var currentAnim = spriteNode.get_animation()
	if spriteNode.frames.get_frame_count(currentAnim) <= targetFrame:
		return
	var texture = spriteNode.frames.get_frame(currentAnim, targetFrame)
	if texture == null:
		return

	tempTexture = texture
	carryoverColor = col
	spawn_particle_effect(AFTERIMAGE, target.get_pos_visual() + Vector2(1, -16), Vector2(target.get_facing_int(), 0))

var particleNodesStowed = []
func OnParticleSpawned(particle):
	particleNodesStowed.append(particle)

	var shirt = particle.get_node_or_null("Shirt")
	if shirt != null:
		shirt.color = carryoverColor

	var emitter = particle.get_node_or_null("Emitter444")
	if emitter == null:
		return
	emitter.set_texture(tempTexture)
	emitter.color = carryoverColor

const FAKEDATA = {"x" : 0, "y" : 0, "Start" : {"x" : 0, "y" : 0}, "End" : {"x" : 0, "y" : 0}, "charged" : false, "speed_modifier" : 1, "Shots" : 0, "dir" : Vector2(0,0), "Charge" : 0 }
const FAKEEXTRA = {"x" : 0, "y" : 0, "Start" : {"x" : 0, "y" : 0}, "End" : {"x" : 0, "y" : 0}, "charged" : false, "speed_modifier" : 1, "Shots" : 0, "dir" : Vector2(0,0), "Charge" : 0 }
func ForceRandomAttack(target):
	if target.forfeit:
		return

	if ReplayManager.replaying_ingame: #fix not being able to undo
		return


	var actionName = GetValidAttack(target)

	#maybe try this function instead: on_action_selected(a,b,c)

	#call_deferred("updateFoe", target, actionName)
	if target.is_ghost:
		target.state_machine._change_state(actionName, FAKEDATA, false, false)
	if Network.multiplayer_active: #force command by manually setting opponent's chosen action
	#	Network.action_inputs[target.id] = { "action":actionName,
	#		"data":FAKEDATA,
	#		"extra":FAKEEXTRA, }
		Network.turns_ready[target.id] = true
	#target.queued_action = actionName
	#target.queued_data = FAKEDATA
	#target.queued_extra = FAKEEXTRA
	target.on_action_selected(actionName,FAKEDATA,FAKEEXTRA)

func ForceBufferedAttack(target):
	var attack = GetValidAttack(target)
	if ReplayManager.playback:
		#target.on_action_selected(attack,FAKEDATA,FAKEEXTRA)
		target.state_machine._change_state(attack, FAKEDATA, false, false)
		return

	if target.use_buffer:
		return

	target.use_buffer = true

	target.buffered_input = { "action" : attack, "data" : FAKEDATA, "extra" : FAKEEXTRA }

	if not ReplayManager.playback and not opponent.is_ghost:
		ReplayManager.frames[opponent.id][current_tick] = target.buffered_input

func GetValidAttack(target):
	var states = target.state_machine.get_children().duplicate()
	#trim invalid nodes
	var unusable = []
	for node in states:
		if not (node.is_usable_with_grounded_check() && node.show_in_menu && node.allowed_in_stance()):
			unusable.append(node)
			continue
		if node is SuperMove:
			unusable.append(node)
			continue
		if node.type != 1:
			unusable.append(node)
			continue
		#disable throw animations
		var localBreak = false
		for interrupts in node.interrupt_from:
			if "Throw" in interrupts || "Grab" in interrupts:
				unusable.append(node)
				localBreak = true
				break
		for interrupts in node.interrupt_into:
			if "Throw" in interrupts || "Grab" in interrupts:
				unusable.append(node)
				localBreak = true
				break
		if localBreak:
			continue
		if node.release_opponent_on_startup || node.release_opponent_on_exit || node is ThrowState:
			unusable.append(node)
			continue
	for element in unusable:
		states.erase(element)

	var actionName
	if states.size() <= 0:
		actionName = "Wait"
	else:
		if randList.size() <= 0:
			setupRandList()
		var nextRand = randList[0] % states.size()
		randList.remove(0)
		actionName = states[nextRand].name

	if actionName == null:
		actionName = "ContinueAuto"

	return actionName

func updateFoe(target, actionName):
	#target.state_machine._change_state(actionName, FAKEDATA, false, false)
	#target.on_action_selected(actionName,FAKEDATA,FAKEEXTRA)
	pass

func ClearParticles():
	UpdateParticleCache()
	for particle in particleNodesStowed:
		particle.visible = false
	pass

func UpdateParticleCache():
	var temp = []
	for particle in particleNodesStowed:
		if not is_instance_valid(particle):
			temp.append(particle)

	for value in temp:
		particleNodesStowed.erase(value)

func CounterMacro1():
	CreateAfterImage(opponent, opponent.color)
	opponent.state_machine._change_state("HurtDizzy", fakeHitbox)
	opponent.hitlag_ticks = 240
	opponent.set_pos(get_pos().x, get_pos().y)
	opponent.set_facing(opponent.get_facing_int() * -1)
	opponent.set_vel(get_vel().x, get_vel().y)
	state_machine._change_state("CounterExecute2")
	if is_ghost == false:
		spawn_particle_effect_relative(COUNTERFLASH, Vector2(0,0))
		spawn_particle_effect_relative(COUNTERBKGND, Vector2(-60,250))

func CounterMacro2():
	opponent.hitlag_ticks = 0
	set_facing(opponent.get_facing_int())
	state_machine._change_state("CounterExecute3")
	ClearParticles()
	spawn_particle_effect(COUNTERFLASH, Vector2(0,0))

func OnAirGrab():
	var kc = get_kc()
	TimeSkip(60)
	var pos = get_pos()
	var targetX = float(pos.x)

	var checkForWallDist = targetX * get_facing_int() > 0

	if checkForWallDist:
		var distToWall = stage_width - abs(targetX) #balance change done to make it so wall angels are easier to escape, but also just as rewarding
		if distToWall < 180:
			targetX = (stage_width - 180) * get_facing_int()
			gain_super_meter(100)

	set_pos(str(targetX), "0")
	kc.set_pos(pos.x, pos.y + 30)
	kc.state_machine._change_state("Wait")
	if combo_count == 0:
		gain_super_meter(125)
	var usedHitbox = null
	for state in state_machine.get_children():
		if state.name == "AirGrabCommand":
			usedHitbox = state.get_active_hitboxes()[0].to_data()
			break

	opponent.hit_by(usedHitbox)
	postGrabVisuals = "AirGrab"
	opponent.set_pos(str(float(get_pos().x) + get_facing_int() * 180 ), "-75")
	invulnFramesLeft = 45
	state_machine._change_state("CounterEnd")
	desiredStandOffset = {"x":get_facing_int() * -100, "y":-50}
	opponent.start_throw_invulnerability()


func OnGrabCounter():
	var kc = get_kc()
	TimeSkip(30) #if you change this, be sure to change the CrimsonArmFFX timing as well in its script
	state_machine._change_state("CounterEnd")
	invulnFramesLeft = 45
	var usedHitbox = null
	for state in state_machine.get_children():
		if state.name == "GrabCounter":
			usedHitbox = state.get_active_hitboxes()[0].to_data()
			break
	opponent.hit_by(usedHitbox)
	postGrabVisuals = "CounterGrab"
	var pos = get_pos()
	set_pos(pos.x, 0)
	opponent.set_pos(str(float(pos.x) + get_facing_int() * 68 ), "0")
	state_machine._change_state("CounterEnd")
	desiredStandOffset = {"x":get_facing_int() * -100, "y":-50}
	kc.state_machine._change_state("CounterChop")
	kc.set_pos(str(float(pos.x) + get_facing_int() * 40 ), "-24")
	kc.set_facing(get_facing_int())
	kc.set_vel(str(get_facing_int() * .3), ".4")
	kc.z_index = -2
	kc.attacking = true

func IsBeingGrabbed():
	var opp_hitboxes = opponent.get_active_hitboxes()
	for hitbox in opp_hitboxes:
		if hitbox.throw && (hitbox.overlaps(hurtbox)):
			return true
		#Do hits that have followups into grabs, such as robot's TRY: CATCH (aka Disembowel)
		var followUp = hitbox.followup_state
		if(followUp != null):
			var followedState = null
			for state in opponent.state_machine.get_children():
				if state.name == followUp:
					followedState = state
					break
			if followedState != null && followedState is ThrowState:
				return true

	#disable grab projectiles here
	var game = MyGame()
	if !is_instance_valid(game): return
	for object in game.objects:
		if object.disabled:
			continue
		if object.id != opponent.id:
			continue
		if not object.initialized:
			continue

		var objectHitboxes = object.get_active_hitboxes()
		for hb in objectHitboxes:
			if (hb.overlaps(hurtbox) && projectileHitboxIsGrab(hb)):
				return true
	return false

func projectileHitboxIsGrab(hb):
	if hb.grounded_hit_state == "Grabbed" || hb.aerial_hit_state == "Grabbed":
		return true
	return false

func IncorporealSET(target, toggle):
	set_composite_variable("incorporeal", toggle, target)
	set_composite_variable("invulnerable", toggle, target)
	set_composite_variable("projectile_invulnerable", toggle, target)
	set_composite_variable("throw_invulnerable", toggle, target)

# Sometimes this just returns null for no reason, but it seems to still work
func MyGame() -> Game:
	var game = Global.current_game
	if is_ghost:
		game = game.ghost_game

	if !is_instance_valid(game):
		print_debug("game instance invalid")
	return game

func CheckEasterEgg(target, easterEggName, easterEggParams):
	if(not target.has_method("EnableEasterEgg")):
		return null
	return target.EnableEasterEgg(easterEggName, easterEggParams)

func EnableEasterEgg(easterEggName, easterEggParams):
	match easterEggName:
		"PoseParticle":
			if state_machine.state.name == "Pose": spawn_particle_effect(easterEggParams, Vector2(float(get_pos().x) - 15,float(get_pos().y)- 25), Vector2(1,1))
