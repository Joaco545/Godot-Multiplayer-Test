extends Control

@onready var ip_text = $"Button Container/Conection Input Container/IP Text"
@onready var port_text = $"Button Container/Conection Input Container/Port Text"


func _on_host_btn_pressed():
	var port = int(port_text.text)
	
	if port == 0:
		print("Invalid Port")
		return
	
	MultiplayerController.initialize_server(port)
	


func _on_join_btn_pressed():
	var port = int(port_text.text)
	
	if port == 0:
		print("Invalid Port")
		return
	
	# TODO Ip check
	
	MultiplayerController.join_server(ip_text.text, port)
	
