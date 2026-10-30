extends CharacterBody2D

var direction = 1
var speed = 5000
@export var special = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _ready() -> void:
	if special:
		speed = 15000

func _physics_process(delta: float) -> void:

	velocity.x = direction * speed * delta * temp.vitesse
	set_direction()
	velocity.y = 0
	move_and_slide()

func set_direction():
	if is_instance_valid(ray_cast_2d.get_collider()):
		var collide = ray_cast_2d.get_collider()
		if collide.is_in_group("tilemap"):
			if direction == 1:
				direction = -1
				ray_cast_2d.target_position = Vector2(-10,0)
			else:
				direction = 1
				ray_cast_2d.target_position = Vector2(10,0)
