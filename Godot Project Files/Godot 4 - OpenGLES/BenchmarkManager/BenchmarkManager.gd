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

var godot_version = "Godot 4.5.1 | OpenGLES"

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

var gpu_model = ""

var gpu_api = ""

var scene_skipped = false

# =================================================================
# _ready() - Runs ONCES When Script Starts
# =================================================================

func _ready():

	cpu_model = OS.get_processor_name()

	gpu_model = RenderingServer.get_video_adapter_name()
	
	var api_version = RenderingServer.get_video_adapter_api_version()
	var rendering_driver = RenderingServer.get_rendering_device()
	
	if rendering_driver != null:
		gpu_api = "Vulkan " + api_version
	elif "OpenGL ES" in api_version:
		gpu_api = api_version
	elif api_version.begins_with("4.") or api_version.begins_with("3."):
		gpu_api = "OpenGL " + api_version
	else:
		gpu_api = api_version

	print("CPU: ", cpu_model)

	print("GPU: ", gpu_model)
	
	print("API: ", gpu_api)

	print("Starting Benchmark...")

	print("Press ESC to skip current scene\n")

	load_next_scene()

# =================================================================
# _input() - This Is To Skip Scenes (By Pressing ESC)
# =================================================================



func _input(event):
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		
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
		
		# FIXED: Changed idle_frame to process_frame for Godot 4
		await get_tree().process_frame

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
		
		current_loaded_scene = scene_resource.instantiate()
		
		add_child(current_loaded_scene)
		
		var camera = find_camera_in_scene(current_loaded_scene)
		
		if camera and camera.has_method("connect_completion"):

			camera.connect_completion(self, "_on_scene_complete")

		else:

			print("Warning: No camera found, using 5 second timeout")
			
			await get_tree().create_timer(5.0).timeout
			
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
		
		if "camera" in script_path.to_lower() or root is Camera3D or root is Node3D:
			
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
	
	var all_data = []
	
	if FileAccess.file_exists(file_path):
		
		var read_file = FileAccess.open(file_path, FileAccess.READ)
		
		var json_text = read_file.get_as_text()
		
		read_file.close()
		
		var test_json_conv = JSON.new()
		var parse_result = test_json_conv.parse(json_text)
		
		if parse_result == OK:
			
			all_data = test_json_conv.data

# =================================================================
# Creates New Entry In The JSON File (WITH PROPER ORDER!)
# =================================================================

	var ordered_results = {}
	for scene_name in scene_names:
		if scene_name in results:
			ordered_results[scene_name] = results[scene_name]

	var new_entry = {
		"version": godot_version,
		"cpu": cpu_model,
		"gpu": gpu_model,
		"api": gpu_api,
		"results": ordered_results
	}
	
	all_data.append(new_entry)

# =================================================================
# Writes Data In JSON (MANUALLY TO PRESERVE ORDER)
# =================================================================

	var write_file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if write_file:
		
		var json_string = "[\n"
		
		for i in range(all_data.size()):
			var entry = all_data[i]
			json_string += "\t{\n"
			json_string += '\t\t"version": "' + entry["version"] + '",\n'
			json_string += '\t\t"cpu": "' + entry["cpu"] + '",\n'
			
			if "gpu" in entry:
				json_string += '\t\t"gpu": "' + entry["gpu"] + '",\n'
			else:
				json_string += '\t\t"gpu": "Unknown",\n'
			
			if "api" in entry:
				json_string += '\t\t"api": "' + entry["api"] + '",\n'
			else:
				json_string += '\t\t"api": "Unknown",\n'
			
			json_string += '\t\t"results": {\n'
			
			var result_keys = []
			for scene_name in scene_names:
				if scene_name in entry["results"]:
					result_keys.append(scene_name)
			
			for j in range(result_keys.size()):
				var key = result_keys[j]
				var value = entry["results"][key]
				json_string += '\t\t\t"' + key + '": '
				
				if typeof(value) == TYPE_STRING:
					json_string += '"' + value + '"'
				else:
					json_string += str(value)
				
				if j < result_keys.size() - 1:
					json_string += ","
				json_string += "\n"
			
			json_string += "\t\t}\n"
			json_string += "\t}"
			
			if i < all_data.size() - 1:
				json_string += ","
			json_string += "\n"
		
		json_string += "]"
		
		write_file.store_string(json_string)
		
		write_file.close()

# =================================================================
# Prints All Data In Console/Terminal
# =================================================================

		print("\n=== BENCHMARK RESULTS ===")
		print(godot_version)
		print("CPU: ", cpu_model)
		print("GPU: ", gpu_model)
		print("API: ", gpu_api)
		
		for scene_name in scene_names:
			
			if scene_name in results:
				
				if typeof(results[scene_name]) == TYPE_STRING:
					
					print(scene_name, " = ", results[scene_name])
					
				else:
					
					print(scene_name, " = ", results[scene_name], " FPS")
		
		print("\nSaved to: ", file_path)
		
	else:
		
		print("ERROR: Could not save file!")
	
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Map_Node/Result/Result.tscn")

# =================================================================
# =================================================================
#
# End Of File This Code Is Mess I Had To Browse Though Deepest
# Corner Of Internet To Find Different Parts Of The Code.
#
# =================================================================
# =================================================================
