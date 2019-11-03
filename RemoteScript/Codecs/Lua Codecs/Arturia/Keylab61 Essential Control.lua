function remote_init()
	local items={
		{name="record", input="button"},
		{name="stop", input="button"},
		{name="play", input="button"},
		{name="loop", input="button"},
		{name="rew", input="button"},
		{name="fwd", input="button"},
			}
	remote.define_items(items)

	local inputs={
		{pattern="9? 5F xx", name="record", value="1"},
		{pattern="9? 5D xx", name="stop", value="1"},
		{pattern="9? 5E xx", name="play", value="1"},
		{pattern="9? 5B xx", name="rew", value="1"},
		{pattern="9? 5C xx", name="fwd", value="1"},
		{pattern="9? 56 xx", name="loop", value="1"},
	}
	remote.define_auto_inputs(inputs)
end


function remote_probe()

--	local controlRequest="F0 7E 7F 06 01 F7" 

--	local controlResponse="F0 7E 00 06 02 00 20 6B 02 00 05 04 ?? ?? ?? ?? F7"
	
	return {
--		request=controlRequest,
--		response=controlResponse
	}
end

function remote_prepare_for_use()
	local retEvents={
	}
	return retEvents
end

function remote_release_from_use()
	local retEvents={
	}
	return retEvents
end

