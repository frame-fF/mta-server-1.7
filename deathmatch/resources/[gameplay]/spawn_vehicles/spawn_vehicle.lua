-- Vehicle spawn system
local vehicleTimers = {}
local playerVehicles = {}
local vehiclesToSpawn = {}

-- Create all vehicles on server start
function createVehicles()
	for vehicleID = 1, #vehicleSpawns do
		local vehicleData = vehicleSpawns[vehicleID]
		createSpawnVehicle(vehicleData)
	end
end

-- Create a single vehicle
function createSpawnVehicle(vehicleData)
	local modelID, posX, posY, posZ, rotZ = unpack(vehicleData)
	local vehicleElement = createVehicle(modelID, posX, posY, posZ, 0, 0, rotZ)
	
	-- Store vehicle data for respawn
	vehiclesToSpawn[vehicleElement] = vehicleData
end

-- Resource start handler
local function onResourceStartSpawnVehicle()
	createVehicles()
end

addEventHandler("onResourceStart", resourceRoot, onResourceStartSpawnVehicle)