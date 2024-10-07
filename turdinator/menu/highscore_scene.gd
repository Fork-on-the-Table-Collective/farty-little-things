extends Control

@export var point_asset: String = "res://entities/player/wc_papirguriga.png"   # This is the scene for each visualized point (could be a TextureRect or similar)
@export var next_scene_path: String = "res://scenes/main/game_area.tscn"
var points: int = 0                   # Total points

@onready var points_container: HBoxContainer = $CanvasLayer/PointsContainer  # Container for visualizing points
@onready var congratulations_label: RichTextLabel = $CanvasLayer/CongratulationsLabel  # Label for "Congratulations"
@onready var points_label: RichTextLabel = $CanvasLayer/PointsLabel  # Label for "Congratulations"
#@onready var points_label: Label = $PointsLabel  # Label to display the total points

func _ready():
	# Initially hide the congratulations message and reset points
	congratulations_label.visible = false
	#points_label.visible = false
	points_container.visible = false
	calculate_points()

# Function to trigger when X event occurs (e.g., player collects an item)
func calculate_points():
	add_base_points()      # Adds the base point
	add_size_based_points()  # Adds extra points based on size
	display_congratulations()  # Shows the congratulatory message and visualizes points

func add_base_points():
	points += 1

# Add additional points based on the player's size
func add_size_based_points():
	var player_size = Global.size  # Get the size of the player by its scale

	points += player_size - 1

# Show the points on the screen with a congratulatory message
func display_congratulations():
	# Display the congratulations message
	congratulations_label.visible = true
	congratulations_label.text = "Congrafuckinglations!"
	points_label.text = "Your Number Two Tokens: " + str(points) 

	# Visualize the points using assets
	points_container.visible = true
	#points_container.queue_free()  # Clear previous points (if any)

	# Step 1: Load the texture from the path
	var texture = load(point_asset) as Texture2D
	if texture == null:
		print("Error: Could not load texture from path:", point_asset)
	else:
		print("Texture loaded OK: ", point_asset)
	# Step 2: Create a TextureRect node to display the texture
	# Step 3: Add the TextureRect to the HBoxContainer
	for i in points:
		var texture_rect = TextureRect.new()
		texture_rect.texture = texture    
		points_container.add_child(texture_rect)
		

	
	print("Points: ", points)
	


	
	
