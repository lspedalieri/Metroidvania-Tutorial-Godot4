extends CanvasLayer

@onready var collectible_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/CollectibleLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	CollectibleManager.on_collectible_award_received.connect(on_collectible_award_received)


func on_collectible_award_received(total_award):
	collectible_label.text = str(total_award)
