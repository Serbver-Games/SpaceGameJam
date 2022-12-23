extends Area2D

signal hit

export var speed =1 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window
var direction

onready var position2D = $Position2D
onready var velocity = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var input = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		input.x += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_down"):
		input.y += 1
	if Input.is_action_pressed("move_up"):
		input.y -= 1

	if input.length() > 0:
		velocity += input.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if input.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.flip_h = input.x < 0
	elif input.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = input.y > 0
	elif input.y == 400:
		print(input.x)
		$AnimatedSprite.flip_v = true
		$AnimatedSprite.flip_v = input.y > 0

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
