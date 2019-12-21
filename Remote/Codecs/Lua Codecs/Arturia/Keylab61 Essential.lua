--[[
	Surface:	Keyboard Arturia Keylab 61 Essential
	Developer:	Thierry Fraudet
	Version:	1.1
	Date:		21/12/2019

]]

g_lcd_line1_index = 1
g_lcd_line2_index = 2
g_lcd_line1_new_text = ""
g_lcd_line1_old_text = ""
g_lcd_line2_new_text = ""
g_lcd_line2_old_text = ""
g_preset_jog_wheel_index = 36

function remote_init(manufacturer, model)
	local items = {
		{name="lcd-1", output="text"},
		{name="lcd-2", output="text"},

		{name="Keyboard", input="keyboard"},
		{name="Channel Pressure", input="value", min=0, max=127},
		{name="Mod Wheel", input="value", min=0, max=127},
		{name="Pitch Bend", input="value", min=0, max=16384},
		{name="Expression", input="value", min=0, max=127},
		{name="Breath", input="value", min=0, max=127},
		{name="Damper Pedal", input="value", min=0, max=127},

		{name="pad-1", input="button"},
		{name="pad-2", input="button"},
		{name="pad-3", input="button"},
		{name="pad-4", input="button"},
		{name="pad-5", input="button"},
		{name="pad-6", input="button"},
		{name="pad-7", input="button"},
		{name="pad-8", input="button"},

		{name="fader-1", input="value", min=0, max=127},
		{name="fader-2", input="value", min=0, max=127},
		{name="fader-3", input="value", min=0, max=127},
		{name="fader-4", input="value", min=0, max=127},
		{name="fader-5", input="value", min=0, max=127},
		{name="fader-6", input="value", min=0, max=127},
		{name="fader-7", input="value", min=0, max=127},
		{name="fader-8", input="value", min=0, max=127},

		{name="pan-1", input="value", output="value", min=0, max=127},
		{name="pan-2", input="value", output="value", min=0, max=127},
		{name="pan-3", input="value", output="value", min=0, max=127},
		{name="pan-4", input="value", output="value", min=0, max=127},
		{name="pan-5", input="value", output="value", min=0, max=127},
		{name="pan-6", input="value", output="value", min=0, max=127},
		{name="pan-7", input="value", output="value", min=0, max=127},
		{name="pan-8", input="value", output="value", min=0, max=127},

		{name="master-pan", input="value", min=0, max=127},
		{name="master-volume", input="value", min=0, max=127},

		{name="preset-jog-wheel", input="delta", output="value", min=0, max=127},
		{name="preset-jog-wheel-button", input="button"},
		{name="preset-prev", input="button"},
		{name="preset-next", input="button"},

		{name="part1-next", input="button"},
		{name="part2-prev", input="button"},
		{name="live-bank", input="button"},

		{name="cat-jog-wheel", input="delta"},
		{name="cat-jog-wheel-button", input="button"},
		{name="cat-prev", input="button"},
		{name="cat-next", input="button"},

		{name="left-arrow", input="button"},
		{name="right-arrow", input="button"},
	}
	remote.define_items(items)

	local inputs = {
		{pattern="e? xx yy", name="Pitch Bend", value="y*128 + x"},
		{pattern="b0 01 xx", name="Mod Wheel"},
		{pattern="b0 0b xx", name="Expression"},
		{pattern="b0 02 xx", name="Breath"},
		{pattern="d0 xx", name="Channel Pressure"},
		{pattern="b0 40 xx", name="Damper Pedal"},
		{pattern="<100x>0 yy zz", name="Keyboard"},

		{pattern="<100y>0 24 xx", name="pad-1"},
		{pattern="<100y>0 25 xx", name="pad-2"},
		{pattern="<100y>0 26 xx", name="pad-3"},
		{pattern="<100y>0 27 xx", name="pad-4"},
		{pattern="<100y>0 28 xx", name="pad-5"},
		{pattern="<100y>0 29 xx", name="pad-6"},
		{pattern="<100y>0 2a xx", name="pad-7"},
		{pattern="<100y>0 2b xx", name="pad-8"},

		{pattern="b? 49 xx", name="fader-1", value="x"},
		{pattern="b? 4b xx", name="fader-2", value="x"},
		{pattern="b? 4f xx", name="fader-3", value="x"},
		{pattern="b? 48 xx", name="fader-4", value="x"},
		{pattern="b? 50 xx", name="fader-5", value="x"},
		{pattern="b? 51 xx", name="fader-6", value="x"},
		{pattern="b? 52 xx", name="fader-7", value="x"},
		{pattern="b? 53 xx", name="fader-8", value="x"},

		{pattern="b? 4a xx", name="pan-1", value="x"},
		{pattern="b? 47 xx", name="pan-2", value="x"},
		{pattern="b? 4c xx", name="pan-3", value="x"},
		{pattern="b? 4d xx", name="pan-4", value="x"},
		{pattern="b? 5d xx", name="pan-5", value="x"},
		{pattern="b? 12 xx", name="pan-6", value="x"},
		{pattern="b? 13 xx", name="pan-7", value="x"},
		{pattern="b? 10 xx", name="pan-8", value="x"},

		{pattern="b? 11 xx", name="master-pan", value="x"},
		{pattern="b? 55 xx", name="master-volume", value="x"},

		{pattern="b? 72 <?y??><???x>", name="preset-jog-wheel", value="x*(2*y-1)"},  -- when "Preset" is selected, 41 <0100><0001>   ou  3f <0011><1111>
		{pattern="b? 73 xx", name="preset-jog-wheel-button", value="x"},	-- When "Preset" is selected
		-- {pattern="b? 72 3f", name="preset-prev", value="1"},
		-- {pattern="b? 72 41", name="preset-next", value="1"},

		-- {pattern="b? 70 <?y??><???x>", name="cat-jog-wheel", value="x*(2*y-1)"},  -- when "Cat" is selected, 41 <0100><0001>   ou  3f <0011><1111>
		{pattern="b? 71 xx", name="cat-jog-wheel-button", value="x"},	-- when "Cat" is selected
		{pattern="b? 70 3f", name="cat-prev", value="1"},
		{pattern="b? 70 41", name="cat-next", value="1"},

		{pattern="b? 16 xx", name="part1-next", value="x"},
		{pattern="b? 17 xx", name="part2-prev", value="x"},

		{pattern="b? 18 xx", name="live-bank", value="x"},

		{pattern="b? 1c xx", name="left-arrow", value="x"},
		{pattern="b? 1d xx", name="right-arrow", value="x"},

	}
	remote.define_auto_inputs(inputs)

	--Auto outputs
	local outputs = {
		{name="pan-1", pattern="b? 4a xx"},
		{name="pan-2", pattern="b? 47 xx"},
		{name="pan-3", pattern="b? 4c xx"},
		{name="pan-4", pattern="b? 4d xx"},
		{name="pan-5", pattern="b? 5d xx"},
		{name="pan-6", pattern="b? 12 xx"},
		{name="pan-7", pattern="b? 13 xx"},
		{name="pan-8", pattern="b? 10 xx"},
	}
	remote.define_auto_outputs(outputs)

end

function remote_process_midi(event)  -- handle incoming midi event
	-- -- test if preset jog-wheel turn right
	-- ret = remote.match_midi("b? 72 41",event)
	-- if ret~=nil then
	-- 	remote.trace(" Send preset-next to Reason\n")
	-- 	local msg={ time_stamp=event.time_stamp, item=39, value=1 }
	-- 	remote.handle_input(msg)
	-- 	return true
	-- end

	-- -- test if preset jog-wheel turn left
	-- ret = remote.match_midi("b? 72 3f",event)
	-- if ret~=nil then
	-- 	remote.trace(" Send preset-prev to Reason\n")
	-- 	local msg={ time_stamp=event.time_stamp, item=38, value=1 }
	-- 	remote.handle_input(msg)
	-- 	return true
	-- end
	
end


g_rv7_algorithms = { "Hall", "Large Hall", "Hall 2", "Large Room", "Medium Room", "Small Room", "Gated", "Low Density" ,"Stereo Echoes" , "Pan Room"}

function remote_set_state(changed_items) --handle incoming changes sent by Reason
	for i,item_index in ipairs(changed_items) do
		if item_index==g_lcd_line1_index then
			--g_is_lcd_enabled=remote.is_item_enabled(item_index)
			g_lcd_line1_new_text=remote.get_item_text_value(item_index)
		end

		if item_index==g_lcd_line2_index then
			--g_is_lcd_enabled=remote.is_item_enabled(item_index)
			g_lcd_line2_new_text=remote.get_item_text_value(item_index)
		end

		if item_index==g_preset_jog_wheel_index then
			if g_lcd_line1_new_text == "RV-7 (reverb)" then
				g_lcd_line2_new_text = g_rv7_algorithms[remote.get_item_text_value(item_index)+1]
			end
		end

	end
end

function remote_deliver_midi(max_bytes, port)
	local ret_events={}

	-- if there is a new message to display 
	if (g_lcd_line1_new_text ~= g_lcd_line1_old_text) then
		g_lcd_line1_old_text = g_lcd_line1_new_text
		table.insert(ret_events,make_lcd_midi_message(g_lcd_line1_new_text, g_lcd_line2_old_text))
	end

	-- if there is a new message to display 
	if (g_lcd_line2_new_text ~= g_lcd_line2_old_text) then
		g_lcd_line2_old_text = g_lcd_line2_new_text
		table.insert(ret_events,make_lcd_midi_message(g_lcd_line1_old_text, g_lcd_line2_new_text))
	end

	return ret_events
end

function remote_probe(manufacturer,model,prober)
	-- Arturia Manufacturer SysEx ID Numbers is: 00 20 6b

	-- Need to be rework, for hardware with multiple ports must be done programaticaly (see Remote SDK documentation page 26 & 27) 
	assert(model == "Keylab61 Essential")
	local controlRequest="f0 7e 7f 06 01 f7"  -- sysex de demande d'identification
	local controlResponse="F0 7E 7F 06 02 00 20 6B 02 00 05 54 3D 02 01 01 F7"
	return {
		request=controlRequest,
		response=controlResponse
	}
end

function remote_prepare_for_use()
	local retEvents={
		-- Display message on LCD
		make_lcd_midi_message("Reason Remote", "connected"),
	}
	return retEvents
end

function remote_release_from_use()
	local retEvents={
		-- Display message on LCD
		make_lcd_midi_message("Reason Remote", "disconnected"),
	}
	return retEvents
end

function stringToHex(text)
	local hexStringToReturn = ""
	for i=1, string.len(text) do
		if string.len(hexStringToReturn) > 0 then 
			hexStringToReturn = hexStringToReturn .. " "
		end
		hexStringToReturn = hexStringToReturn .. string.format("%X", string.byte(text,i))   
	end
	return hexStringToReturn
end

function make_lcd_midi_message(line1, line2)
	local sysex = "f0 00 20 6b 7f 42 04 00 60 01" .. stringToHex(string.sub(line1,1,16)) .. " 00 02" .. stringToHex(string.sub(line2,1,16)) .. " 00 f7"
	local event=remote.make_midi(sysex)
	return event
end