extends Area2D

signal hit

export var speed =.1 # How fast the player will move (pixels/sec).
export var rotspeed =.01 # How fast player will rotate.
var screen_size # Size of the game window
var direction

onready var position2D = $Position2D
var velocity = Vector2.ZERO
var input = Vector2.ZERO
var last_mouse_position2D = Vector2.ZERO
var delta_mouseX

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	#look_at(get_global_mouse_position())
	var mouse_position2D = get_global_mouse_position()
	delta_mouseX = mouse_position2D.x - last_mouse_position2D.x
	last_mouse_position2D = mouse_position2D
	
	input = Vector2.ZERO # The player's movement vector.
	
	rotate(delta_mouseX * rotspeed)
		
	if Input.is_action_pressed("move_right"):
		input = Vector2(0, speed).rotated(rotation)
	if Input.is_action_pressed("move_left"):
		input = Vector2(0, -speed).rotated(rotation)
	if Input.is_action_pressed("move_down"):
		input = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed("move_up"):
		input = Vector2(speed, 0).rotated(rotation)

	if input.length() > 0:
		velocity += input.normalized()
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

#	if input.x != 0:
#		$AnimatedSprite.animation = "right"
#		$AnimatedSprite.flip_h = true
#		$AnimatedSprite.flip_h = input.x < 0
#	elif input.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = input.y > 0
#	elif input.y == 400:
#		print(input.x)
#		$AnimatedSprite.flip_v = true
#		$AnimatedSprite.flip_v = input.y > 0

func start(pos):
	position = pos
	velocity = Vector2.ZERO
	input = Vector2.ZERO
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
