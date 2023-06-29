extends PlayerInfo

var tween:SceneTreeTween

onready var epBar = $"%Epitaph"
onready var epBack = $"%EpitaphBack"

onready var erBack = $"%TimeEraseBack"
onready var erBar = $"%TimeErase"

func set_fighter(fighter):
	.set_fighter(fighter)
	if player_id == 2:
		$HBoxContainer.alignment = BoxContainer.ALIGN_END
	

var colorSpin = 0
var tintChange = 0
var tintChange2 = 0
func _process(delta):
	if is_instance_valid(fighter):
		
		var frames = fighter.epitaphFramesLeft
		
		var erased = fighter.erasedFramesLeft
		
		if frames > 0 || erased > 0:
			
			
			
			colorSpin += delta / 9
			tintChange += delta / 14
			tintChange2 += delta / 17
			
			colorSpin = fmod(colorSpin, 1.0)
			tintChange = fmod(tintChange, 1.0)
			tintChange2 = fmod(tintChange, 1.0)
			
			var spina = PI * colorSpin * 2
			var spinb = PI * tintChange * 2
			var spinc = PI * tintChange2 * 2
			epBar.texture_progress.fill_from = Vector2((sin(spina) + 1)/2, (cos(spina) + 1)/2)
			epBar.texture_progress.fill_to = Vector2(1 - (sin(spina) + 1)/2,1 - (cos(spina) + 1)/2)
			
			erBar.texture_progress.fill_from = Vector2((sin(spina) + 1)/2, (cos(spina) + 1)/2)
			erBar.texture_progress.fill_to = Vector2(1 - (sin(spina) + 1)/2,1 - (cos(spina) + 1)/2)
			
			epBar.tint_progress = Color((sin(spinc) + 1)/4 + 0.5, (sin(spinb) + 1)/4 + 0.5 ,1,1)
			erBar.tint_progress = Color((sin(spinc) + 1)/8 + 0.1, 0.1 ,(sin(spinb) + 1)/8 + 0.75,1)
		
		if frames > 0:
			epBack.visible = true
			epBar.value = frames
		else:
			epBack.visible = false
		
		if erased > 0:
			erBack.visible = true
			erBar.value = erased
		else:
			erBack.visible = false
