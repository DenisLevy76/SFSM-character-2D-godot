tool
extends Node
class_name StateMachine

export(String) onready var initial_state

onready var target := get_parent()

var _states := {}
var _current_state: State = null
var _next_state: State = null

func _ready():
	_states_map()

	_set_state(_states[initial_state])

func _physics_process(_delta) -> void:
	if _current_state:
		if _current_state.has_method("_update"): 
			_current_state._update(_delta)

		if _current_state.has_method("_transition"):
			_next_state = _current_state._transition()

		if _next_state != null and _next_state != _current_state: 
			_set_state(_current_state._transition())

func _states_map() -> void:
	if get_children().size() > 0: 
		for state in get_children():
			state.context = self
			_states[state.name] = state

func _set_state(newState: State) -> void:
	if _current_state:
		if _current_state.has_method("_on_exit"): _current_state._on_exit()

	_current_state = newState

	if _current_state.has_method("_on_ready"): _current_state._on_ready()
