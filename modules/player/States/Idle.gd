extends State


func _update(_delta):
	context.target.AnimatedSprite.play("idle")
	context.target._apply_gravity(_delta)
	context.target.velocity.x = 0
	context.target._move_and_slide()

func _transition():
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		return  context._states["Running"]
	elif Input.is_action_just_pressed("attack"):
		return context._states["Attacking"]
	# elif Input.is_action_just_pressed("space"):
	# 	_next_state = "JUMPING"
	# elif not is_on_floor():
	# 	_next_state = "FALLING"
	else: return null
	pass
