extends Area2D

signal hit


@export var speed = 400.0
var screen_size = Vector2.ZERO

#Set the size of the screen for the object not to move far away
func _ready():
	screen_size = get_viewport_rect().size
	print(screen_size)


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
	# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
func _on_body_entered(body):
	hide() #Player disappears after being hit.
	hit.emit()
	#Must be deferred as we cannot change physics properties
	$CollisionShape2D.set_deferred("disabled", true)
	
#A function to reset the player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
