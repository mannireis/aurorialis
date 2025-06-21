extends PanelContainer

@onready var property_container = %VBoxContainer

#var property
var fps : String

func _ready() -> void:
	visible = false
	Global.debug = self
	#add_debug_property("FPS",fps)
	
func _process(delta):
	if visible == true:
		fps = "%.2f" % (1.0/delta)
		#property.text = property.name + ": " + fps
	Global.debug.add_property("FPS", fps, 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		visible = !visible

func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title,true,false)
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target,order)

#func add_debug_property(title : String, value):
	#property = Label.new()
	#property_container.add_child(property)
	#property.name = title
	#property.text = property.name + value
