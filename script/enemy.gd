extends CharacterBody2D

var speed = 2000
var direction = 1

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * temp.vitesse
	
	velocity.x = direction * speed * delta * temp.vitesse

	set_direction()
	move_and_slide()

func set_direction():
	if is_instance_valid(ray_cast_2d.get_collider()):
		var collide = ray_cast_2d.get_collider()
		if collide.is_in_group("tilemap"):
			if direction == 1:
				direction = -1
				ray_cast_2d.target_position = Vector2(-12,0)
				sprite_2d.flip_h = true
			else:
				direction = 1
				ray_cast_2d.target_position = Vector2(12,0)
				sprite_2d.flip_h = false


func _on_area_2d_kill_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().reload_current_scene.call_deferred()


func _on_area_2d_kill_enemy_body_entered(body: Node2D) -> void:
	if body.name == "player":
		queue_free()
