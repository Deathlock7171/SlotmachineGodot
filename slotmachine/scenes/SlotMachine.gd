extends Node2D
signal stopped  

var symbols = ["🍒", "🍋", "🍊", "🍇", "🔔"]
var spinning_count
var force_stop

func _ready():
	randomize()
	center_reels()
	set_reel_font_size(100) 

func center_reels():
	var rect = get_viewport().get_visible_rect()
	var center = rect.size / 2.3
	var spacing = 300
	$Reel1.position = center + Vector2(-spacing -20, 0)
	$Reel2.position = center
	$Reel3.position = center + Vector2(spacing + 20, 0)
	$ResultLabel.position = center + Vector2(0, spacing + 20)

func set_reel_font_size(size):
	var font = load("res://fonts/Symtext.ttf") 
	if font:
		$Reel1.add_theme_font_override("font", font)
		$Reel2.add_theme_font_override("font", font)
		$Reel3.add_theme_font_override("font", font)
		$Reel1.add_theme_font_size_override("font_size", size)
		$Reel2.add_theme_font_size_override("font_size", size)
		$Reel3.add_theme_font_size_override("font_size", size)

func start():
	force_stop = false
	$ResultLabel.text = "Rolling...."
	spinning_count = 3
	spin_reel($Reel1, 0)
	spin_reel($Reel2, 0.1)
	spin_reel($Reel3, 0.2)

func stop():
	force_stop = true

func spin_reel(reel, delay_time):
	await get_tree().create_timer(delay_time).timeout
	var timer = create_reel_timer(reel)
	var elapsed = 0.0
	while elapsed < 1.5 and not force_stop:
		await get_tree().create_timer(0.05).timeout
		elapsed += 0.05
	timer.stop()
	timer.queue_free()
	animate_reel_stop(reel)
	spinning_count -= 1
	if spinning_count == 0:
		check_win()

func create_reel_timer(reel) -> Timer:
	var timer = Timer.new()
	timer.wait_time = 0.05
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(func(): _on_timer_timeout(reel))
	timer.start()
	return timer

func _on_timer_timeout(reel):
	reel.text = symbols[randi() % symbols.size()]

func animate_reel_stop(reel):
	var tween = create_tween()
	tween.tween_property(reel, "modulate", Color(1,1,1,1), 1)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

func check_win():
	if $Reel1.text == $Reel2.text && $Reel2.text == $Reel3.text:
		$ResultLabel.text = "🎉 WIN! 🎉"
	else:
		$ResultLabel.text = "TRY AGAIN"
	stopped.emit()
