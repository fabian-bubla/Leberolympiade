extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GrapeOff_focus_entered():
	$AnimatedSprite.playing = true


func _on_GrapeOff_focus_exited():
	$AnimatedSprite.playing = false
