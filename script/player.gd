extends CharacterBody2D

var ralentire = false
@export var SPEED = 300.0
const JUMP_VELOCITY = -300
var temps_tir = 0
var can_ral = true

"""var dash_speed = 300
var dashing = false
var can_dash = true"""

@onready var animation_player: AnimationPlayer = $paramtre/animation/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var goutte_scene: PackedScene
@onready var marker_2d_2: Marker2D = $Marker2D2
@onready var dash_timer: Timer = $DashTimer
@onready var dash_agane_timer: Timer = $DashAganeTimer
@onready var timer_ral: Timer = $TimerRal
@onready var timer_ral_temp: Timer = $TimerRalTemp

func _process(_delta):
	if Input.is_action_just_pressed("ralentire"):

		if ralentire == false and can_ral:
			temp.vitesse = 0.2
			ralentire = true
			timer_ral_temp.start()

		elif ralentire == true:
			arreter_ralentissement()
		
func arreter_ralentissement():
	temp.vitesse = 1.0
	ralentire = false
	can_ral = false
	timer_ral_temp.stop()
	timer_ral.start()
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("saut") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("gauche", "droite")
	"""if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		dash_timer.start()
		dash_agane_timer.start()
	if dashing:
		velocity.x = direction * dash_speed
	else:"""
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	marker_2d_2.look_at(get_global_mouse_position())
	temps_tir -= delta

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if temps_tir <= 0:
			for i in range(20):
				tirer()
			temps_tir = 0.3
	else:
		temps_tir = 0
			

		
	animation_ubdate(direction)
	move_and_slide()
	
func tirer():
	var goutte = goutte_scene.instantiate()

	var angle = marker_2d_2.global_rotation + deg_to_rad(randf_range(-4, 4))

	goutte.direction = Vector2.RIGHT.rotated(angle)

	goutte.vitesse = randf_range(300, 450)

	get_tree().current_scene.add_child(goutte)

	goutte.global_position = marker_2d_2.global_position

	goutte.scale = Vector2.ONE * randf_range(0.1,0.12)
	
func animation_ubdate(dir):
	if velocity.y < 0:
		animation_player.play("saut montant") # Joue l'animation de saut en montée
		if dir == 1:
			sprite_2d.flip_h = false
		if dir == -1:
				sprite_2d.flip_h = true
	elif velocity.y > 0:
			animation_player.play("saut dessandant")
			if dir == 1:
				sprite_2d.flip_h = false
			if dir == -1:
				sprite_2d.flip_h = true
	else:
		if dir == 1:
			animation_player.play("marche")
			sprite_2d.flip_h = false
		if dir == -1:
			sprite_2d.flip_h = true
			animation_player.play("marche")
		if dir == 0:
			animation_player.play("RESET")


"""func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_agane_timer_timeout() -> void:
	can_dash = true"""


func _on_timer_ral_timeout() -> void:
	can_ral = true


func _on_timer_ral_temp_timeout() -> void:
	arreter_ralentissement()
