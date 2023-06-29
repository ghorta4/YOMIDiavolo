extends CharacterState

var freeCounter = 0

func _tick():
	freeCounter += 1
	
	if freeCounter > 30:
		freeCounter -= 30
		host.state_interruptable = true
