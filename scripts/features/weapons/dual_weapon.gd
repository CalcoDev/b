# todo(calco): rename this to player weapon lmfao
class_name DualWeapon
extends Node2D

@export var primary: Weapon
@export var secondary: Weapon

@export var primary_into_secondary: bool = false
@export var secondary_into_primary: bool = false

var _use := [false, false]

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass
    
func setup_owner(weapon_owner: Node2D) -> void:
    primary.weapon_owner = weapon_owner
    secondary.weapon_owner = weapon_owner

func setup_faction(faction: FactionComponent) -> void:
    primary.faction = faction
    secondary.faction = faction
    
func check_fire(pos: Vector2, direction: Vector2, primary_act: StringName, secondary_act: StringName) -> void:
    # TODO(calco): Check stuff here
# 	print(_use)
    if not _use[1] or secondary_into_primary:
        _check_fire(pos, primary, primary_act, direction)
    if not _use[0] or primary_into_secondary:
        _check_fire(pos, secondary, secondary_act, direction)

func _check_fire(pos: Vector2, weapon: Weapon, input_action: StringName, direction: Vector2) -> void:
    var s := int(weapon == secondary)
    
    if weapon.instant:
        if Input.is_action_pressed(input_action):
            _use[s] = true
            if weapon.hold_down:
                weapon.fire(pos, direction)
        elif not weapon.hold_down and Input.is_action_just_pressed(input_action):
            _use[s] = weapon.fire(pos, direction)
        else:
            _use[s] = false
    else:
        if not weapon.is_charging:
            if Input.is_action_just_pressed(input_action):
                _use[s] = weapon.start_charge()
            if weapon.hold_down and Input.is_action_pressed(input_action):
                _use[s] = weapon.start_charge()
        elif weapon.is_charging and not Input.is_action_pressed(input_action):
            weapon.finish_charge(pos, direction)
            _use[s] = false
        elif weapon.is_charging:
            _use[s] = true
        else:
            _use[s] = false
    
    if _use[s]:
        _use[1-s] = false