local function save(source, data)
    local url = exports.settings:baseUrl() .. '/api/player/me/data/update/'
    local key = getElementData(source, "results").key
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "PATCH",
        formFields = data,
        headers = {
            ["Authorization"] = "Token " .. key
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            iprint("Save data success")
        else
            outputChatBox('Error: ' .. data, source)
        end
    end)
end


local function savePlayerData()
    local player = source
    local account = getPlayerAccount(player)

    if not account or isGuestAccount(account) then
        return
    end
    -- get username
    local username = getAccountName(account)
    -- get team name
    local team = getPlayerTeam(player)
    local team = team and getTeamName(team)
    -- get position
    local x, y, z = getElementPosition(player)
    local position = toJSON({ x, y, z })
    -- get weapons
    local weapon = getPedWeapon(player)
    local ammo = getPedTotalAmmo(player)
    local weapons_in_hand = {}
    for slot = 0, 12 do
        local weapon = getPedWeapon(player, slot)
        local ammo = getPedTotalAmmo(player, slot)
        if (weapon > 0) and (ammo > 0) then
            weapons_in_hand[weapon] = ammo
        end
    end
    -- get clothes
    local clothes = {}
    for type = 0, 17 do
        local texture, model = getPedClothes(player, type)
        if (texture) and (model) then
            table.insert(clothes, { texture, model, type })
        end
    end

    local data = {
        position = position,
        rotation = getPedRotation(player),
        skin = getElementModel(player),
        interior = getElementInterior(player),
        dimension = getElementDimension(player),
        team = team,
        weapons_in_hand = toJSON(weapons_in_hand),
        health = getElementHealth(player),
        armor = getPedArmor(player),
        money = getPlayerMoney(player),
        wantedlevel = getPlayerWantedLevel(player),
        clothes = toJSON(clothes),
        -- Additional Status
        hunger = getElementData(player, "hunger") or 100,
        thirst = getElementData(player, "thirst") or 100,
        stamina = getElementData(player, "stamina") or 100,
        weapons = toJSON(getElementData(player, "weapons")),
        ammo = toJSON(getElementData(player, "ammo"))
    }
    save(player, data)
end


-- Event Handlers

addEvent("savePlayerData", true)
addEventHandler("savePlayerData", root, savePlayerData)

addEventHandler("onPlayerQuit", root,
    function()
        triggerEvent("savePlayerData", source)
    end)

addEventHandler("onPlayerLogout", root,
    function()
        triggerEvent("savePlayerData", source)
    end)

addEventHandler("onPlayerSpawn", root,
    function()
        triggerEvent("savePlayerData", source)
    end)

addEventHandler("onResourceStop", root,
    function()
        for _, player in ipairs(getElementsByType("player")) do
            local account = getPlayerAccount(player)
            if (account) and not (isGuestAccount(account)) then
                triggerEvent("savePlayerData", player)
            end
        end
    end)