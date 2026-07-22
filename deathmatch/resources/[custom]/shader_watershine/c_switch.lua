--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchWaterShine", root, 4 )
--
--	To switch off:
--			triggerEvent( "switchWaterShine", root, 0 )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		triggerEvent( "switchWaterShine", resourceRoot, true)
		addCommandHandler( "sWaterShine",
			function()
				triggerEvent( "switchWaterShine", resourceRoot, not wsEffectEnabled)
			end
		)
	end
)


--------------------------------
-- Switch effect on or off
--------------------------------
function switchWaterShine( wsOn )
	outputDebugString( "switchWaterShine: " .. tostring(wsOn) )
	if (wsOn) then
		enableWaterShine()
	else
		disableWaterShine()
	end
end

addEvent( "switchWaterShine", true )
addEventHandler( "switchWaterShine", resourceRoot, switchWaterShine )
