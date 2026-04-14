extends CanvasLayer

func _ready():
	Gamemaker.coin_collected.connect(_on_coin_collected)

func _on_coin_collected(new_total):
	$PlayerLabel.text = "Coins: " + str(new_total)
