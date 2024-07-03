extends Control

@onready var name_text = $"VBoxContainer/Name Text"

func _on_submint_btn_pressed():
	# Set name
	GameManager.client_name = name_text.text
	# Tell the server
	GameManager.spawn_player()
	# Hide the login screen
	self.visible = false
