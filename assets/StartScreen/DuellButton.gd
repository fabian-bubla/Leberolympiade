extends Button


func _ready():
	grab_focus()


func _on_GrapeOff_focus_entered():
	$AnimatedSprite.playing = true
	$Underline.visible = true


func _on_GrapeOff_focus_exited():
	$AnimatedSprite.playing = false
	$Underline.visible = false
