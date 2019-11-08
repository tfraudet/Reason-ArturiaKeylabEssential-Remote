function remote_init(manufacturer, model)
	local items = {
		{name="record", input="button", output="value"},
		{name="stop", input="button", output="value"},
		{name="play", input="button", output="value"}, 
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

function remote_probe()
	-- sysexe de demande d'identification
	local controlRequest="f0 7e 7f 06 01 f7" 
	-- response if Arturia Keylab Essential 61 is F0 7E 7F 06 02 00 20 6B 02 00 05 54 3D 02 01 01 10  F7 
	-- local controlResponse="F0 7E 7F 06 02 ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? F7"
	local controlResponse="F0 7E 7F 06 02 00 20 6B 02 00 05 54 3D 02 01 01 10 F7"
	
	-- Need to be rework, for hardware withg miltiple ports must be done programaticaly (see doc page 26 & 27) 
	return {
		request=controlRequest,
		response=controlResponse
	}
end

function remote_on_auto_input(item_index) 
	-- this function is called by Remote after an auto-input item message has been handled.
	remote.trace('in remote_on_auto_input(), item_index = ' .. item_index)
end

function remote_prepare_for_use()
	local retEvents={
			-- switch off all the button's leds
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('56',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('57',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('58',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('59',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5a',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5b',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5c',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5d',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5e',16), y=0, port=1} ),
		remote.make_midi("f0 00 20 6b 7f 42 02 00 10 xx yy f7", { x=tonumber('5f',16), y=0, port=1} ),
	}
	return retEvents
end

function remote_release_from_use()
	local retEvents={
	}
	return retEvents
end

