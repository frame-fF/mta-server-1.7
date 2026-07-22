-- Player spawn system
local spawnsCount = #playerSpawns
local skinsCount = #playerSkins

-- Spawn player at random position
function spawnPlayerAtRandom(playerElement)
	if not isElement(playerElement) then
		return false
	end
	
	local randomSpawn = math.random(spawnsCount)
	local spawnData = playerSpawns[randomSpawn]
	local posX, posY, posZ, rotX = unpack(spawnData)
	local randomSkin = math.random(skinsCount)
	local skinID = playerSkins[randomSkin]
	
	-- Add random offset to spawn position
	posX, posY = posX + math.random(-3, 3), posY + math.random(-3, 3)
	
	spawnPlayer(playerElement, posX, posY, posZ, rotX, skinID, 0, 0, nil)
	fadeCamera(playerElement, true)
	setCameraTarget(playerElement)
end

-- Handle player join
function onPlayerJoin()
	spawnPlayerAtRandom(source)
end

-- Handle player wasted (death)
function onPlayerWasted()
	local playerRespawnTime = get("playerRespawnTime")
	
	playerRespawnTime = tonumber(playerRespawnTime) or 5000
	playerRespawnTime = playerRespawnTime < 0 and 0 or playerRespawnTime
	
	setTimer(spawnPlayerAtRandom, playerRespawnTime, 1, source)
end

-- Resource start handler
local function onResourceStartSpawnPlayers()
	-- Seed the random generator so skin/spawn selection differs between resource/server restarts
	math.randomseed(getRealTime().timestamp)

	-- Add event handlers
	addEventHandler("onPlayerJoin", root, onPlayerJoin)
	addEventHandler("onPlayerWasted", root, onPlayerWasted)
end

addEventHandler("onResourceStart", resourceRoot, onResourceStartSpawnPlayers)