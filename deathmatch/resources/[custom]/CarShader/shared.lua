-- Türkçe Kaliteli Scriptin Adresi : https://sparrow-mta.blogspot.com
-- Her gün yeni script için sitemizi takip edin.
-- SparroW MTA İyi Oyunlar Diler...
-- Facebook : https://www.facebook.com/sparrowgta
--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchCarPaint", root, true )
--
--	To switch off:
--			triggerEvent( "switchCarPaint", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		outputDebugString('/hd to switch the effect')
		triggerEvent( "switchCarPaint", resourceRoot, true )
		addCommandHandler( "hd",
			function()
				triggerEvent( "switchCarPaint", resourceRoot, not cpEffectEnabled )
			end
		)
	end
)


--------------------------------
-- Switch effect on or off
--------------------------------
function switchCarPaint( cpOn )
	outputDebugString( "switchCarPaint: " .. tostring(cpOn) )
	if cpOn then
		startCarPaint()
	else
		stopCarPaint()
	end
end

addEvent( "switchCarPaint", true )
addEventHandler( "switchCarPaint", resourceRoot, switchCarPaint )
