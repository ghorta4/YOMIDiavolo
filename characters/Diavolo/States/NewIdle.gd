extends CharacterState

export  var auto_fall = true

func _enter():
	if auto_fall:
		if not host.is_grounded():
			return "Fall"
			

func _tick():
	host.idleFrame += 1
	host.apply_fric()
	host.apply_forces()
	if auto_fall:
		if not host.is_grounded():
			return "Fall"
	if host.hp <= 0:
		return "Knockdown"

func update_sprite_frame():
	.update_sprite_frame()
	host.sprite.frame = int(host.idleFrame/12)%4
