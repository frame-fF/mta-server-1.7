----------------------------------------------------------------------------------------------------
---                                            TABLES                                            ---
----------------------------------------------------------------------------------------------------
local antiSpamSave = { }
local setting = { }
----------------------------------------------------------------------------------------------------
---                                           SETTINGS                                           ---
----------------------------------------------------------------------------------------------------
-- Save Data Setting
setting.position = not get("position") == "false" and toJSON(split(get("position"), ", ")) or false
setting.rotation = tonumber(get("rotation")) or false
setting.interior = tonumber(get("interior")) or false
setting.dimension = tonumber(get("dimension")) or false
setting.team = tostring(get("team")) or false
setting.skin = tonumber(get("skin")) or false
setting.data = not get("data") == "false" and split(get("data"), ", ") or { }

-- Other Setting
setting.loadOnStartResource = get("loadOnStartResource") == "true" and true or false
setting.saveCommand = get("saveCommand") == "true" and true or false
setting.saveTime = tonumber(get("saveTime")) or false
----------------------------------------------------------------------------------------------------
---                                        CUSTOM EVENTS                                         ---
----------------------------------------------------------------------------------------------------
addEvent("onAccountLoadData", true)
addEventHandler("onAccountLoadData", root,
function (account)
    local position = getAccountData(account, "position") or setting.position
    local rot = getAccountData(account, "rotation") or setting.rotation
    local int = getAccountData(account, "interior") or setting.interior
    local dim = getAccountData(account, "dimension") or setting.dimension
    local teamName = getAccountData(account, "team") or setting.team
    local skin = getAccountData(account, "skin") or setting.skin
    local health = getAccountData(account, "health")
    local armor = getAccountData(account, "armor")
    local money = getAccountData(account, "money")
    local wanted = getAccountData(account, "wantedlevel")
    local clothes = getAccountData(account, "clothes")
    local stats = getAccountData(account, "stats")
    local weapons = getAccountData(account, "weapons")
	local datas = getAccountData(account, "datas")
    
    local x, y, z = unpack(fromJSON(position) or {nil})
    local team = teamName and getTeamFromName(teamName) or nil
    
    if position then spawnPlayer(source, x, y, z, rot, skin, int, dim, team) end
    if health then setElementHealth(source, health) end
    if armor then setPedArmor(source, armor) end
    if money then setPlayerMoney(source, money) end
    if wanted then setPlayerWantedLevel(source, wanted) end
    if (clothes) then
        removeAllPedClothes(source)
        for _, clothe in pairs(fromJSON(clothes)) do
            local texture, model, type = unpack(clothe)
            addPedClothes(source, texture, model, type)
        end
    end
    if (stats) then
        for stat, value in pairs(fromJSON(stats)) do
            setPedStat(source, stat, value)
        end
    end
    if (weapons) and not (isPedDead(source)) then
        takeAllWeapons(source)
        for weapon, ammo in pairs(fromJSON(weapons)) do
            giveWeapon(source, weapon, ammo, true)
        end
    end
    if (datas) and (setting.data) then
        for key, value in pairs(fromJSON(datas)) do
        	setElementData(source, key, value)
        end
    end
    setCameraTarget(source, source)
    fadeCamera(source, true, 2.0)  
end)
 
addEvent("onAccountSaveData", true)
addEventHandler("onAccountSaveData", root,
function (account)
    local accountName = getAccountName(account)
    local x, y, z = getElementPosition(source)
    local _, _, rot = getElementRotation(source)
    local int = getElementInterior(source)
    local dim = getElementDimension(source)
    local team = getPlayerTeam(source)
    local skin = getElementModel(source)
    local health = getElementHealth(source)
    local armor = getPedArmor(source)
    local money = getPlayerMoney(source)
    local wanted = getPlayerWantedLevel(source)
        
    local position = toJSON({x, y, z})
    local teamName = team and getTeamName(team) or nil
    local clothes = getAllPedClothes(source)
    local stats = getAllPedStats(source)
    local weapons = getAllPedWeapon(source)
	local datas = getPlayerDataFromKeys(source)
        
    setAccountData(account, "position", position)
    setAccountData(account, "rotation", rot)
    setAccountData(account, "interior", int)
    setAccountData(account, "dimension", dim)
    setAccountData(account, "team", teamName)
    setAccountData(account, "skin", skin)
    setAccountData(account, "health", health)
    setAccountData(account, "armor", armor)
    setAccountData(account, "money", money)
    setAccountData(account, "wantedlevel", wanted)
    setAccountData(account, "clothes", toJSON(clothes))
    setAccountData(account, "stats", toJSON(stats))
    
    if (weapons) and not (isPedDead(source)) then 
    	setAccountData(account, "weapons", toJSON(weapons)) 
    end

    if (datas) then 
    	setAccountData(account, "datas", toJSON(datas)) 
    end
    
    outputDebugString(getPlayerName(source).." Successfully his data saved with account: "..accountName, 3)
end)

----------------------------------------------------------------------------------------------------
---                                            EVENTS                                            ---
----------------------------------------------------------------------------------------------------
addEventHandler("onPlayerSpawn", root,
function ( )
    local account = getPlayerAccount(source)
    if (account) and not (isGuestAccount(account)) then
        local weapons = getAccountData(account, "weapons")
        if (weapons) and (fromJSON(weapons)) then
            takeAllWeapons(source)
            for weapon, ammo in pairs(fromJSON(weapons)) do
                giveWeapon(source, weapon, ammo, true)
            end
        end
    end 
end)

addEventHandler("onPlayerWasted", root,
function ( )
    local account = getPlayerAccount(source)
    if (account) and not (isGuestAccount(account)) then
        local weapons = getAllPedWeapon(source)
        setAccountData(account, "weapons", toJSON(weapons))

        triggerEvent("onAccountSaveData", source, account)
    end
end)

addEventHandler("onElementModelChange", root,
function (oldSkin, skin)
	if not (getElementType(source) == "player") then return end
    local account = getPlayerAccount(source)
    if (account) and not (isGuestAccount(account)) then
    	if (oldSkin == 0) then
    		local clothes = getAllPedClothes(source)
    		setAccountData(account, "clothes", toJSON(clothes))
    	end
        setAccountData(account, "skin", skin)
    end
end)

addEventHandler("onPlayerLogin", root,
function (_, account)
    triggerEvent("onAccountLoadData", source, account)
end)

addEventHandler("onResourceStart", resourceRoot, 
function (resource)
	if (setting.saveTime) then 
		setTimer(function ()
    		for _, thePlayer in pairs(getElementsByType("player")) do
        		local account = getPlayerAccount(thePlayer)
        		if (account) and not (isGuestAccount(account)) then
            		triggerEvent("onAccountSaveData", thePlayer, account)
            	end
            end
        end, setting.saveTime, 0)
    end
	if not (setting.loadOnStartResource) then
        for _, thePlayer in pairs(getElementsByType("player")) do
            local account = getPlayerAccount(thePlayer)
            if (account) and not (isGuestAccount(account)) then
                triggerEvent("onAccountLoadData", thePlayer, account)
            end
	    end
    end
end)

addEventHandler("onPlayerQuit", root,
function ( )
    local account = getPlayerAccount(source)
    if (account) and not (isGuestAccount(account)) then
        triggerEvent("onAccountSaveData", source, account)
    end
end)

addEventHandler("onPlayerLogout", root,
function (account)
    triggerEvent("onAccountSaveData", source, account)
end)

addEventHandler("onResourceStop", resourceRoot, 
function (resource)
    for _, thePlayer in pairs(getElementsByType("player")) do
        local account = getPlayerAccount(thePlayer)
        if (account) and not (isGuestAccount(account)) then
            triggerEvent("onAccountSaveData", thePlayer, account)
	    end
    end
end)

addCommandHandler("savedata",
function (thePlayer)
	if (setting.saveCommand) then
    	local account = getPlayerAccount(thePlayer)
    	if (account) and not (isGuestAccount(account)) then
        	if not (antiSpamSave[account]) then
            	if (triggerEvent("onAccountSaveData", thePlayer, account)) then
            		outputChatBox("Successfully your data saved", source, 0, 255, 0)
            	end
            	antiSpamSave[account] = setTimer(function() antiSpamSave[account] = nil end, 300000, 1)
        	else
            	outputChatBox("You can save your data by command every 5 minutes", thePlayer, 255, 0, 0)
        	end
        end
    else
    	outputChatBox("Command save data's is disabled", thePlayer, 255, 0, 0)
    end
end)

----------------------------------------------------------------------------------------------------
---                                          FUNCTIONS                                           ---
----------------------------------------------------------------------------------------------------
function getAllPedClothes(thePed)
    local clothes = { }
    for type=0, 17 do
        local texture, model = getPedClothes(thePed, type)
        if (texture) and (model) then
            table.insert(clothes, {texture, model, type})
        end
    end
    return clothes
end

function removeAllPedClothes(thePed)
    for type=0, 17 do
        removePedClothes(source, type)
    end
    return true
end

function getAllPedStats(thePed)
    local stats = { }
    for stat=0, 230 do
        local value = getPedStat(thePed, stat)
        if (value) and (value > 0) then
            stats[stat] = value
        end
    end
    return stats
end

function getAllPedWeapon(thePed)
    local weapons = { }
    for slot=1, 12 do
        local weapon = getPedWeapon(thePed, slot)
        local ammo = getPedTotalAmmo(thePed, slot)
        if (weapon > 0) and (ammo > 0) then
            weapons[weapon] = ammo
        end
    end
    return weapons
end

function getPlayerDataFromKeys(thePlayer)
	local data = {}
	for _, key in pairs(setting.data) do
		local value = getElementData(thePlayer, key)
	    data[key] = value
	end
	return data
end

function table.find (tab, vf)
    if (tab) and (type(tab) == "table") then
        for k, v in pairs(tab) do
            if (v == vf) then
                return k
            end
        end
    end
end