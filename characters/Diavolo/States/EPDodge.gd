extends CharacterState

func _enter():
	host.lastDodgePose += 1
	host.lastDodgePose %= 4

func update_sprite_frame():
	.update_sprite_frame()
	host.sprite.frame = host.lastDodgePose
