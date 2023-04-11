extends Node2D

onready var cursor = get_node("Cursor")
var on_start = true
onready var tween = get_node("Tween")

func _ready():
	$AnimatedSprite.play()
	$sfxMenu.play()
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_down") and on_start == true:
		cursor.position = cursor.position + Vector2(0,40)
		on_start = false
		$sfxChoose.play()
	if Input.is_action_just_pressed("ui_up") and on_start == false:
		cursor.position = cursor.position - Vector2(0,40)
		on_start = true
		$sfxChoose.play()
	if Input.is_action_just_pressed("ui_accept") and on_start == true:
		$AnimationPlayer.play("StartGame")
		get_tree().get_root().set_disable_input(true)
		tween.interpolate_property($sfxMenu, "volume_db", 0, -50, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.start()
		$sfxDecide.play()
		
	if Input.is_action_just_pressed("ui_accept") and on_start == false:
		$AnimationPlayer.play("FadeOut")
		tween.interpolate_property($sfxMenu, "volume_db", 0, -30, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.start()
		get_tree().get_root().set_disable_input(true)

func _start_game():
	get_tree().change_scene_to(load("res://Level.tscn"))
	

func _end_game():
	get_tree().quit()
