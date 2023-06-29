tool

extends Hitbox

export (int) var offset_x = 0
export (int) var offset_y = 0
export (float) var drag_strength = 10

export (bool) var forceIncCombo

func hit(obj):
	if obj is Fighter:
		var pos = host.get_pos()
		var opos = null
		
		if host is Fighter:
			opos = host.opponent.get_pos()
		else:
			opos = host.creator.opponent.get_pos()
		if forceIncCombo:
			if host is Fighter:
				host.visible_combo_count += 1
			else:
				host.creator.visible_combo_count += 1
		
		obj.move_directly(str((pos.x + (offset_x * host.get_facing_int()) - opos.x) / drag_strength), str((pos.y - (offset_y + 18) - opos.y) / drag_strength))
	.hit(obj)
