extends ActionUIData

func fighter_update():
	$Frames.max_value = 60
	$Frames.min_value = 1
	$Frames.update_values()
