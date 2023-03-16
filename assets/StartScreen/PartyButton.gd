extends Button


func _on_Party_focus_entered():
	$AnimatedSprite.playing = true


func _on_Party_focus_exited():
	$AnimatedSprite.playing = false
