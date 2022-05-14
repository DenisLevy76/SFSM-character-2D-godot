tool
extends Node
class_name StateMachine

onready var _states := {}

export(String) var initial_state
onready var target := get_parent()
var _current_state: State = null
var _next_state

func _ready():
  if get_children().size() > 0: for state in get_children():
	  state.context = self
	  _states[state.name] = state

  _current_state = _states[initial_state]
  if _current_state.has_method("_on_ready") : _current_state._on_ready()
  pass

func _physics_process(_delta):
  if _current_state != null: 
			if _current_state.has_method("_update"): _current_state._update(_delta)
			if _current_state.has_method("_transition"):
				if _current_state._transition() != null:
					if _current_state.has_method("_on_exit"): _current_state._on_exit()
					_current_state = _current_state._transition()
  pass
