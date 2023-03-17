extends Button


func _on_Party_focus_entered():
	$AnimatedSprite.playing = true
	$Underline.visible = true

func _on_Party_focus_exited():
	$AnimatedSprite.playing = false
	$Underline.visible = false
