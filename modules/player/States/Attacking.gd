extends State


func _update(delta):
	context.target.AnimatedSprite.play("attack")
	context.target.attack_animation_finished = false

	context.target._jump()
	context.target._apply_gravity(delta)
	context.target._move_and_slide()

func _transition():
	# if Input.is_action_just_pressed("space"):
	# 			_current_state = "JUMPING"
		# elif not is_on_floor():
	# 		_current_state = "FALLING"
		# else:
		# 	_current_state = "IDLE"
	pass

func _on_AnimatedSprite_animation_finished():
	if context.target.AnimatedSprite.animation == 'attack': context._current_state = context._states["Idle"]
