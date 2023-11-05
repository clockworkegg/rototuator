extends Area2D
## grid-based movement tutorial: https://kidscancode.org/godot_recipes/4.x/2d/grid_movement/index.html

@onready var ray_cast_move = $RayCastMove
@onready var ray_cast_attach = $RayCastAttach

var tile_size := 64
var inputs := { 
	"right":Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up":Vector2.UP,
	"down":Vector2.DOWN
	}
	

# attaching objects stuff  
var detected_object : Area2D = null
var movable_object : Area2D = null

#animatoin stuff
var animation_speed = 8.0
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE*tile_size)
	position += Vector2.ONE*tile_size/2 

func _unhandled_input(event):
	if moving:
		return
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			move(direction)
	if event.is_action_pressed("attach"):
		if movable_object != null:
			if !movable_object.is_attached:
				movable_object.is_attached = true
				
			else:
				movable_object.is_attached = false
				movable_object = null

func move(dir) -> void:
	var is_object_colliding = false
	ray_cast_move.target_position = inputs[dir]*tile_size
	ray_cast_move.force_raycast_update()
	if movable_object != null:
		movable_object.ray_cast_move.target_position = inputs[dir]*tile_size
		movable_object.ray_cast_move.force_raycast_update()
		if movable_object.ray_cast_move.is_colliding():
			is_object_colliding = true
	if !ray_cast_move.is_colliding() && !is_object_colliding:
		var tween = create_tween()		
		tween.tween_property(self,"position",position + inputs[dir]*tile_size,
		1/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		if movable_object != null:
			if movable_object.is_attached:
				var obj_tween = create_tween()
				obj_tween.tween_property(movable_object,"position",movable_object.position + inputs[dir]*tile_size,
				1/animation_speed).set_trans(Tween.TRANS_SINE)
		await tween.finished
		moving = false
		checkForMovableObjects()
		
func checkForMovableObjects()->void:
	for dir in inputs.keys():
		ray_cast_attach.target_position = inputs[dir]*tile_size
		ray_cast_attach.force_raycast_update()
		if ray_cast_attach.is_colliding():
			movable_object = ray_cast_attach.get_collider()
