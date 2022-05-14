extends KinematicBody2D

var velocity := Vector2()
const player_movement_speed := 120
const gravity := 900
const jump_force := -300
var attack_animation_finished = false
# onready var label = get_child(get_children().size() - 1)


# machine state =====================
# por enquanto recebe strings mas em produção deve ser um dicionário de classes State
onready var _states = {
  "IDLE": funcref(self, 'idle_state'), 
  "WALKING": funcref(self, '_move_state'), 
  'JUMPING': funcref(self, 'jump_state'), 
  'ATTACKING' : funcref(self, '_attack_state'),
  'FALLING': funcref(self, 'fall_state'),
  'SLIDING': funcref(self, 'slide_state'),
}

onready var _current_state = "IDLE"

func _physics_process(delta):
  _states[_current_state].call_func(delta)
  $Label.text = _current_state
  _move_and_slide()


# states ============================
func _attack_state(delta):
  $AnimatedSprite.play("attack")
  attack_animation_finished = false

  _jump()
  _apply_gravity(delta)

func _move_state(delta):
  $AnimatedSprite.play("walk")

  _move()
  _apply_gravity(delta)
  _move_state_check()

func jump_state(delta):
  $AnimatedSprite.play("jump")

  _jump()
  _apply_gravity(delta)
  _move()
  jump_state_check()

func fall_state(delta):
  $AnimatedSprite.play("fall")

  _apply_gravity(delta)
  _move()
  fall_state_check()

func idle_state(delta):
  $AnimatedSprite.play("idle")
  _apply_gravity(delta)
  velocity.x = 0
  idle_state_check()

func slide_state(delta):
  $AnimatedSprite.play("slide")
  velocity.x = lerp(velocity.x, 0, 0.05)
  
  _move()
  _apply_gravity(delta)


# check functions
func idle_state_check():
  if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
	  _current_state = "WALKING"
  elif Input.is_action_just_pressed("attack"):
	  _current_state = "ATTACKING"
  elif Input.is_action_just_pressed("space"):
	  _current_state = "JUMPING"
  elif not is_on_floor():
	  _current_state = "FALLING"

	
func fall_state_check():
  if is_on_floor():
	  _current_state = "IDLE"
  elif Input.is_action_pressed("attack"):
	  _current_state = "ATTACKING"

func jump_state_check():
  if Input.is_action_pressed("attack"):
	  _current_state = "ATTACKING"
  elif velocity.y >= 0:
	  _current_state = "FALLING"
func _move_state_check():
  if Input.is_action_just_pressed("attack"):
	  _current_state = "ATTACKING"
  elif Input.is_action_just_pressed("space"):
	  _current_state = "JUMPING"
  elif not is_on_floor():
	  _current_state = "FALLING"
  elif velocity.x == 0:
	  _current_state = "IDLE"
  elif Input.is_action_pressed("slide"):
	  _current_state = "SLIDING"

func attack_state_check():
  if Input.is_action_just_pressed("space"):
	  _current_state = "JUMPING"
  elif not is_on_floor():
	  _current_state = "FALLING"
  else:
	  _current_state = "IDLE"

func slide_state_check():
  if not is_on_floor():
	  _current_state = "FALLING"
  else:
	  _current_state = "IDLE"

# utils ==============================
func _apply_gravity(delta):
  velocity.y += gravity * delta

func _move_and_slide():
  velocity = move_and_slide(velocity, Vector2.UP)

func _move():
  if Input.is_action_pressed("ui_left"):
	  velocity.x = -player_movement_speed
	  $AnimatedSprite.flip_h = true
  elif Input.is_action_pressed("ui_right"):
	  velocity.x = player_movement_speed
	  $AnimatedSprite.flip_h = false
  else:
	  velocity.x = 0

func _jump():
	if Input.is_action_pressed("space") and is_on_floor():
	  velocity.y = jump_force

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'attack': 
		attack_state_check()
	elif $AnimatedSprite.animation == 'slide':
		slide_state_check()
	
  
