extends CharacterState

export  var tech = false

var colliding = false
func _enter():
	host.used_air_dodge = true
	colliding = false

func _frame_0():
	host.start_invulnerability()
	host.start_throw_invulnerability()
	host.start_projectile_invulnerability()
	host.play_sound("timeSkip2")

func _frame_1():
	var direction = float(data.x)
	var distance = 30
	var speed = 7
	if direction * (float(host.opponent.get_pos().x) - float(host.get_pos().x)) < 0: #aka if moving back
		distance = 25
		speed = 6
		host.add_penalty(7)
	if tech:
		distance = 90
		speed = 9
	
	distance *= direction
	speed *= direction
	
	var pos = host.get_pos()
	host.set_pos(str(pos.x + distance),str(pos.y))
	host.set_vel(str(speed), "0")
	
	host.set_facing(direction)

func _tick():
	host.colliding_with_opponent = colliding

func _frame_2():
	host.end_invulnerability()
	host.end_throw_invulnerability()
	host.end_projectile_invulnerability()

func _frame_7():
	colliding = true

func is_usable():
	if not host.is_grounded():
		return .is_usable() and not host.used_air_dodge
	return .is_usable()
