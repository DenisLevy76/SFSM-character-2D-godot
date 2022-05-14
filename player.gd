extends KinematicBody2D

var velocity := Vector2()
const player_movement_speed := 120
const gravity := 900
const jump_force := -300


# machine state =====================
# por enquanto recebe strings mas em produção deve ser um dicionário de classes State
onready var _states = {
  "IDLE": funcref(self, 'idle_state'), 
  "WALKING": funcref(self, '_move_state'), 
  'JUMPING': funcref(self, 'jump_state'), 
  'ATTACKING' : funcref(self, '_attack_state'),
  'FALLING': funcref(self, 'fall_state')
}

onready var _current_state = _states["IDLE"]

func _physics_process(delta):
  _current_state.call_func(delta)
  _move_and_slide()


# states ============================
func _attack_state(delta):
  $AnimatedSprite.play("attack")
  
  _apply_gravity(delta)

func _move_state(delta):
  $AnimatedSprite.play("walk")

  _move()
  _apply_gravity(delta)
  _move_state_check()

func jump_state(delta):
  $AnimatedSprite.play("jump")

  if is_on_floor():
	  velocity.y = jump_force

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


# check functions
func idle_state_check():
  if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
	  _current_state = _states["WALKING"]
  elif Input.is_action_just_pressed("attack"):
	  _current_state = _states["ATTACKING"]
  elif Input.is_action_just_pressed("space"):
	  _current_state = _states["JUMPING"]
  elif not is_on_floor():
	  _current_state = _states["FALLING"]
	
func fall_state_check():
  if is_on_floor():
	  _current_state = _states["IDLE"]
  elif Input.is_action_pressed("attack"):
	  _current_state = _states["ATTACKING"]

func jump_state_check():
  if Input.is_action_pressed("attack"):
	  _current_state = _states["ATTACKING"]
  elif velocity.y >= 0:
	  _current_state = _states["FALLING"]
func _move_state_check():
  if Input.is_action_just_pressed("attack"):
	  _current_state = _states["ATTACKING"]
  elif Input.is_action_just_pressed("space"):
	  _current_state = _states["JUMPING"]
  elif not is_on_floor():
	  _current_state = _states["FALLING"]
  elif velocity.x == 0:
	  _current_state = _states["IDLE"]

func attack_state_check():
  if Input.is_action_just_pressed("space"):
	  _current_state = _states["JUMPING"]
  elif not is_on_floor():
	  _current_state = _states["FALLING"]
  elif velocity.x == 0:
	  _current_state = _states["IDLE"]

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


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'attack': _current_state = _states["IDLE"]
  
