extends Area2D

var tile_size := 64 
var relative_position := Vector2.ZERO

@onready var ray_cast_move = $RayCastMove
@onready var collision_shape_2d = $CollisionShape2D

var is_attached = false : set = _set_is_attached, get = _get_is_attached

func _get_is_attached():
	return is_attached
	
func _set_is_attached(value):
	is_attached = value
	if (value):
		collision_shape_2d.disabled = true
	else:
		collision_shape_2d.disabled = false
