class_name State
extends Node
# A state coordinated by the state coordinator.


## The current active substate.
var live_substate: State = null

## The target of this state machine's behavior.
var actor : CharacterBody2D
## The interface to the audiovisual components of this state machine.
var av : AVCoordinator

@export_category("Audiovisuals")
## The name of the AV effect that this state should trigger.
@export var effect := &""

@export_category("Transition Links")
@export var links : Array[State] = []
var _link_cache : Dictionary = {}

## True when on the first cycle of the physics loop.
var _first_cycle : bool = true
