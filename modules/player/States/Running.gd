extends State

func _update(delta):
	context.target.AnimatedSprite.play("walk")

	context.target._move()
	context.target._apply_gravity(delta)
	context.target._move_and_slide()

func _transition():
	if context.target.velocity.x == 0:
		return context._states["Idle"]
	elif Input.is_action_just_pressed("attack"):
			return context._states["Attacking"]
	# 	elif Input.is_action_just_pressed("space"):
	# 		_current_state = "JUMPING"
	# 	elif not is_on_floor():
	# 		_current_state = "FALLING"
	# 	elif Input.is_action_pressed("slide"):
	# 		_current_state = "SLIDING"
	else: return null
	pass
