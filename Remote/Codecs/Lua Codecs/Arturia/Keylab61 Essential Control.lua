--[[
	Surface:	DAW Command Center of Arturia Keylab 61 Essential
	Developer:	Thierry Fraudet
	Version:	1.0
	Date:		10/11/2019

]]

-- init globals varaiables
g_pause_play_button_state = "stop"
g_pause_play_button_index = 3
g_stop_button_index = 2

g_last_input_time=-2000
g_last_input_item=nil

function remote_init(manufacturer, model)
	local items = {
		{name="record", input="button", output="value"},
		{name="stop", input="button", output="value"},
		{name="play", input="button", output="value",  modes={"Play", "Pause"}}, 
		{name="loop", input="button", output="value"},
		{name="rew", input="button", output="value"},
		{name="fwd", input="button", output="value"},
		{name="save", input="button", output="value"},
		{name="punch", input="button", output="value"},
		{name="undo", input="button", output="value"},
		{name="metro", input="button", output="value"},
	}
	remote.define_items(items)

	local inputs = {
		{pattern="9? 5F xx", name="record", value="x"},
		{pattern="9? 5D xx", name="stop", value="x"},
		{pattern="9? 5E xx", name="play", value="x"},
		{pattern="9? 5B xx", name="rew", value="x"},
		{pattern="9? 5C xx", name="fwd", value="x"},
		{pattern="9? 56 xx", name="loop", value="x"},
		{pattern="9? 50 xx", name="save", value="x"},
		{pattern="9? 58 xx", name="punch", value="x"},
		{pattern="9? 51 xx", name="undo", value="x"},
		{pattern="9? 59 xx", name="metro", value="x"},
	}
	remote.define_auto_inputs(inputs)

	--Auto outputs
	local outputs = {
		{name="record", pattern="90 5F 0x"},
		{name="play", pattern="90 5E xx"},
		{name="stop", pattern="90 5D xx"},
		{name="rew", pattern="90 5B xx"},
		{name="fwd", pattern="90 5C xx"},
		{name="save", pattern="90 50 xx"},
		{name="punch", pattern="90 58 xx"},
		{name="undo", pattern="90 51 xx"},
		{name="metro", pattern="90 59 xx"},
		{name="loop", pattern="90 56 xx"},
	}
	remote.define_auto_outputs(outputs)
end

-- Sysex to color transport leds: F0 00 20 6B 7F 42 02 00 10 xx yy F7
-- where:
--   xx is the button
-- 		56 is save button
--		57 is undo button
--		58 i punch button
--		59 is Metro button
--		5a is loop button
--		5b is rwd button
--		5c is fwd button
--		5d is stop button
--		5e is pause/play button
--		5f is record button
-- 	 yy is intensity of the led from 00 to 7F , 00 the led is off
--
-- ref: https://forum.renoise.com/t/tool-development-arturia-keylab-mkii-49-61-mcu-midi-messages/57343/9
--
-- to set button off
-- send 90 xx 00
--
function remote_probe()
	-- sysexe de demande d'identification
	local controlRequest="f0 7e 7f 06 01 f7" 
	-- Arturia Manufacturer SysEx ID Numbers is: 00 20 6b
	-- response if Arturia Keylab Essential 61 is F0 7E 7F 06 02 00 20 6B 02 00 05 54 3D 02 01 01 10  F7 
	-- local controlResponse="F0 7E 7F 06 02 ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? F7"
	local controlResponse="F0 7E 7F 06 02 00 20 6B 02 00 05 54 3D 02 01 01 10 F7"
	
	-- Need to be rework, for hardware with multiple ports must be done programaticaly (see Remote SDK documentation page 26 & 27) 
	return {
		request=controlRequest,
		response=controlResponse
	}
end

function remote_on_auto_input(item_index) 
	g_last_input_time=remote.get_time_ms()
	g_last_input_item=item_index
end

function toggle_pause_play_button_state()
	if g_pause_play_button_state == "play" then
		g_pause_play_button_state = "pause" 
	else
		g_pause_play_button_state = "play"
	end
	return g_pause_play_button_state
end

function remote_process_midi(event)  -- handle incoming midi event
	-- test if pause/play is pressed
	ret = remote.match_midi("9? 5e 7f",event)
	if ret~=nil then
		g_pause_play_button_state = toggle_pause_play_button_state()
		g_last_input_index = 3
		if g_pause_play_button_state == "play" then
			local msg={ time_stamp=event.time_stamp, item=g_pause_play_button_index, value=1 }
			remote.handle_input(msg)
		else
			local msg={ time_stamp=event.time_stamp, item=g_stop_button_index, value=1 }
			remote.handle_input(msg)
		end
		return true
	end

	--test if stop is pressed
	ret = remote.match_midi("9? 5d 7f",event)
	if ret~=nil then
		g_pause_play_button_state = "stop"
		g_last_input_index = 2;
		local msg={ time_stamp=event.time_stamp, item=g_stop_button_index, value=1}
		remote.handle_input(msg)
		return true
	end

	return false
end


function remote_set_state(changed_items) --handle incoming changes sent by Reason
	-- for key,value in ipairs(changed_items) do
	-- 	if value == g_pause_play_button_index then
	-- 		g_pause_play_button_state = toggle_pause_play_button_state()
	-- 	end
	-- 	if value == g_stop_button_index then
	-- 		g_pause_play_button_state = "stop"
	-- 	end

	-- 	if (value == g_pause_play_button_index) or (value ==g_stop_button_index) then
	-- 		-- remote.trace(' pause/play button, current state is '.. g_pause_play_button_state .. ' ,value is '.. remote.get_item_value(value)..'\r')
	-- 		-- error(' pause/play button, current state is '.. g_pause_play_button_state .. ' ,value is '.. remote.get_item_value(value)..'\r')
	-- 	end
	-- end
end

function remote_deliver_midi(max_bytes, port)
	local ret_events={}

	-- play_pause_button_state has 3 value: stop, pause, play
	-- following the state, we send sysex to light the pause/play button led
	if (g_last_input_index == 3) then
		if g_pause_play_button_state == "play" then
			pause_play_led_event = remote.make_midi('F0 00 20 6B 7F 42 02 00 10 5e 7f F7')
		elseif g_pause_play_button_state == "pause" then
			pause_play_led_event = remote.make_midi('F0 00 20 6B 7F 42 02 00 10 5e 10 F7')
		else
			pause_play_led_event = remote.make_midi('F0 00 20 6B 7F 42 02 00 10 5e 00 F7')
		end
		table.insert(ret_events,pause_play_led_event)
	end

	-- if stop is pressed, switch off the pause/play button led.
	if (g_last_input_index == 2) then
		pause_play_led_event = remote.make_midi('F0 00 20 6B 7F 42 02 00 10 5e 00 F7')
		table.insert(ret_events,pause_play_led_event)
	end

	g_last_input_index = nil
	return ret_events
end

function remote_prepare_for_use()
	local retEvents={
		-- set to Mackie controle mode
		remote.make_midi("f0 00 20 6b 7f 42 02 00  40 51 00 F7"),

		-- switch off all the button's leds
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('56',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('57',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('58',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('59',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5a',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5b',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5c',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5e',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5d',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5f',16), y=0, port=1} ),

		-- Display message on LCD
		make_lcd_midi_message("Reason DAW CC", "connected"),
	}
	return retEvents
end

function remote_release_from_use()
	local retEvents={
		-- Display message on LCD
		make_lcd_midi_message("Reason DAW CC", "disconnected"),
	}
	return retEvents
end

-- Sysexe to send something to the display: F0 00 20 6B 7F 42 04 00 60 01 xx xx 00 02 yy yy 00 F7 where xx is on the first line and yy on the 2nd
--   ex: send abcdefghigklmnop
--      f0 00 20 6b 7f 42 04 00 60 01 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 00 F7 
--   ex: send abcdefgh ET aabcdefghi
--      f0 00 20 6b 7f 42 04 00 60 01 61 62 63 64 65 66 67 68 00 02 61 61 62 63 64 65 66 67 68 69 00 F7 

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

function trace_event(event)
	result = "Event: "
	result = result .. "port " .. event.port .. ", "
	result = result .. (event.timestamp and ("timestamp " .. event.timestamp .. ", ") or "")
	result = result .. (event.hi and ("hi " .. event.hi .. ", ") or "")
	result = result .. (event.lo and ("lo " .. event.lo .. ", ") or "")
	result = result .. (event.size and ("size " .. event.size .. ", ") or "")

	result = result .. "data {"
	for i=1,event.size do
		result = result .. event[i] .. ", "
	end
	result = result .. "}, "

	remote.trace(result)
end