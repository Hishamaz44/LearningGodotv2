extends Area2D
signal hit

@export var speed = 300
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	#hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x += -1
		$AnimatedSprite2D.flip_h = true
		
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$AnimatedSprite2D.flip_h = false
		
	if Input.is_action_pressed("ui_up"):
		velocity.y += -1
		
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta 
		position = position.clamp(Vector2.ZERO, screen_size)
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()


func _on_body_entered(_body: Node2D):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
