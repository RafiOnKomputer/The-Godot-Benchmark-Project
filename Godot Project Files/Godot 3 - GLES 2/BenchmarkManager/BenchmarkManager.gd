# ╔══════════════════════════════════════════════════════════════════════╗
# ║                             MIT License                              ║
# ║                                                                      ║
# ║                   Copyright (c) 2025 RafiOnKomputer                  ║
# ║                                                                      ║
# ║ Permission is hereby granted, free of charge, to any person          ║
# ║ obtaining a copy of this software and associated documentation files ║
# ║ (the "Software"), to deal in the Software without restriction,       ║
# ║ including without limitation the rights to use, copy, modify, merge, ║
# ║ publish, distribute, sublicense, and/or sell copies of the Software, ║
# ║ and to permit persons to whom the Software is furnished to do so,    ║
# ║ subject to the following conditions:                                 ║
# ║                                                                      ║
# ║ The above copyright notice and this permission notice shall be       ║
# ║ included in all copies or substantial portions of the Software.      ║
# ║                                                                      ║
# ║ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,      ║
# ║ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF   ║
# ║ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                ║
# ║ NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS  ║
# ║ BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN   ║
# ║ ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN    ║
# ║ CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     ║
# ║ SOFTWARE.                                                            ║
# ╚══════════════════════════════════════════════════════════════════════╝


# =================================================================
# =================================================================
#
# This Code "BenchmarkManager.gd" Loads Game Scenes One By One ,
# Measures Their AVG FPS
# Saves It To benchmark_results.json
#
# =================================================================
# =================================================================

extends Node

# =================================================================
# CONFIG - You Can Change Value Here To Mess Around
# =================================================================

var godot_version = "Godot 3.6 | OpenGL ES 2"

# Iam Too Tired To Manually Code
# It To Auto Detect Godot Version and API ;-;
# So Just Manually Put The Text Here :3

# =================================================================
# SCENE PATHS - List Of All Maps/Scenes We Want To Benchmark
# =================================================================

var scenes = [
	"res://Map_Node/IRL/nordic_village/nordic_village.tscn",
	"res://Map_Node/Miside/miside__ms__real_room_od/miside__ms__real_room_od.tscn",
	"res://Map_Node/Counter Strike/stylized_pool_day_by_redsquall/stylized_pool_day_by_redsquall.tscn",
	"res://Map_Node/Counter Strike/cs_office_with_real_light/cs_office_with_real_light.tscn",
	"res://Map_Node/Valorent/site_c_haven/site_c_haven.tscn",
	"res://Map_Node/Minecraft/mayan_temple/mayan_temple.tscn",
	"res://Map_Node/Fumo/Fumo.tscn",
	"res://Map_Node/Fumo/Fumo_Lights.tscn",
	"res://Map_Node/Fumo/Fumo_Baked_Lights.tscn",
	"res://Map_Node/IRL/low_poly_forest_1/low_poly_forest_1_no_light.tscn",
	"res://Map_Node/IRL/low_poly_forest_1/low_poly_forest_1.tscn",
	"res://Map_Node/IRL/full_gameready_city_buildings/full_gameready_city_buildings_no_lights.tscn",
	"res://Map_Node/IRL/full_gameready_city_buildings/full_gameready_city_buildings.tscn",
	"res://Map_Node/IRL/landscape_with_waterfall/landscape_with_waterfall.tscn",
]

# BTW The Maps Loads In Order Of This List

# =================================================================
# SCENE NAMES - Shorter Names For benchmark_results.json
# =================================================================

var scene_names = [
	"nordic_village",
	"miside_room",
	"pool_day",
	"cs_office",
	"site_c_haven",
	"mayan_temple",
	"Fumo",
	"Fumo_Lights",
	"Fumo_Baked_Lights",
	"low_poly_forest_no_light",
	"low_poly_forest",
	"city_buildings_no_lights",
	"city_buildings",
	"landscape_with_waterfall"
]

# Make SURE This Order Is Same As Above (SCENE PATHS)

# =================================================================
# VARIABLES - Default Values It Changes As The Code Runs Dont Touch
# =================================================================

var current_scene_index = 0

var current_loaded_scene = null

var fps_samples = []

var results = {}

var cpu_model = ""

var scene_skipped = false

# =================================================================
# _ready() - Runs ONCES When Script Starts
# =================================================================

func _ready():

	cpu_model = OS.get_processor_name()

	print("CPU: ", cpu_model)

	print("Starting Benchmark...")

	print("Press ESC to skip current scene\n")

	load_next_scene()

# BTW, I Removed The Option For GPU Name Cuz It Seems You Cant
# Get GPU Name From Godot Itself But It Might Work On Godot 4
# Iam Not Sure Check This Part Of Code In The Godot 4 Project
# Folder. We Could Write Code To Ask OS Directly For GPU Name
# But Its Getting Messy And IAM SUPER BURNED OUT

# =================================================================
# _input() - This Is To Skip Scenes (By Pressing ESC)
# =================================================================



func _input(event):
	
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		
		if current_loaded_scene != null:
			
			print("Scene skipped by user!")
			
			scene_skipped = true
			
			_on_scene_complete()


# FPS Result Will Not Save If You Skip,
# This Is Only Here Just In Case Shit Breaks And
# You Have Skip

# =================================================================
# _process() - Runs EVERY FRAME
# =================================================================

func _process(_delta):



	if current_loaded_scene != null and not scene_skipped:
		
		fps_samples.append(Engine.get_frames_per_second())

# =================================================================
# load_next_scene() - Loads Scenes In Order And Calculates AVG FPS
# =================================================================

func load_next_scene():

	if current_scene_index > 0:
		
		var scene_name = scene_names[current_scene_index - 1]

		if scene_skipped:
			
			results[scene_name] = "Skipped By User"
			
			print(scene_name, " = Skipped By User")
			
		elif fps_samples.size() > 0:
			
			var total = 0
			
			for fps in fps_samples:
				
				total += fps
			
			var avg_fps = int(total / fps_samples.size())
			
			results[scene_name] = avg_fps
			
			print(scene_name, " = ", avg_fps, " FPS")
		
		fps_samples.clear()
		
		scene_skipped = false

# =================================================================
# Unloading The Scene
# =================================================================

	if current_loaded_scene != null:
		
		print("Unloading scene: ", scenes[current_scene_index - 1])
		
		current_loaded_scene.queue_free()
		
		current_loaded_scene = null
		
		yield(get_tree(), "idle_frame")

# =================================================================
# Calls Save Result function
# =================================================================

	if current_scene_index >= scenes.size():
		
		print("\nBenchmark Complete!")
		
		save_results()
		
		return

# =================================================================
# Find Camera And Loads it
# =================================================================

	print("Loading scene ", current_scene_index, ": ", scenes[current_scene_index])

	var scene_resource = load(scenes[current_scene_index])
	
	if scene_resource:
		
		current_loaded_scene = scene_resource.instance()
		
		add_child(current_loaded_scene)
		
		var camera = find_camera_in_scene(current_loaded_scene)
		
		if camera and camera.has_method("connect_completion"):

			camera.connect_completion(self, "_on_scene_complete")

		else:

			print("Warning: No camera found, using 5 second timeout")
			
			yield(get_tree().create_timer(5.0), "timeout")
			
			_on_scene_complete()
	
	else:

		print("Error loading scene!")

		current_scene_index += 1

		load_next_scene()

# =================================================================
# find_camera_in_scene() - Searches For Camera Node In Scene
# =================================================================

func find_camera_in_scene(root):
	
	if root.get_script() != null:
		
		var script_path = root.get_script().get_path()
		
		if "camera" in script_path.to_lower() or root is Camera or root is Spatial:
			
			if root.has_method("_process"):
				
				return root
	
	for child in root.get_children():
		
		var result = find_camera_in_scene(child)
		
		if result:
			
			return result
	
	return null

# =================================================================
# _on_scene_complete() - Called when scene finishes benchmarking
# =================================================================

func _on_scene_complete():
	
	print("Scene ", current_scene_index, " complete!")
	
	current_scene_index += 1
	
	load_next_scene()

# =================================================================
# save_results() - Saving Benchmark Data To JSON File
# =================================================================

func save_results():
	
	var file_path = ""
	
	if OS.has_feature("editor"):
		
		file_path = "res://benchmark_results.json"
		
	else:
		
		file_path = OS.get_executable_path().get_base_dir() + "/benchmark_results.json"
	
	var file = File.new()
	
	var all_data = []
	
	if file.file_exists(file_path):
		
		file.open(file_path, File.READ)
		
		var json_text = file.get_as_text()
		
		file.close()
		
		var parse_result = JSON.parse(json_text)
		
		if parse_result.error == OK:
			
			all_data = parse_result.result

# =================================================================
# Creates New Entry In The JSON File
# =================================================================

	var new_entry = {
		"version": godot_version,
		"cpu": cpu_model,
		"results": results
	}
	
	all_data.append(new_entry)

# =================================================================
# Writes Data In JSON
# =================================================================

	var err = file.open(file_path, File.WRITE)
	
	if err == OK:
		
		file.store_string(JSON.print(all_data, "\t"))
		
		file.close()

# =================================================================
# Prints All Data In Console/Terminal
# =================================================================

		print("\n=== BENCHMARK RESULTS ===")
		print(godot_version)
		print("CPU: ", cpu_model)
		
		for scene_name in scene_names:
			
			if scene_name in results:
				
				if typeof(results[scene_name]) == TYPE_STRING:
					
					print(scene_name, " = ", results[scene_name])
					
				else:
					
					print(scene_name, " = ", results[scene_name], " FPS")
		
		print("\nSaved to: ", file_path)
		
	else:
		
		print("ERROR: Could not save file!")
	
# Loads Results Screen Instead Of Quitting
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://Map_Node/RESULTS/Results.tscn")

# =================================================================
# =================================================================
#
# End Of File This Code Is Mess I Had To Browse Though Deepest
# Corner Of Internet To Find Different Parts Of The Code.
#
# =================================================================
# =================================================================
