----------------------------------------------------------------------------------------------------
---                                            NOTES                                              ---
----------------------------------------------------------------------------------------------------
-- Persists player gameplay data directly into the MySQL `player_data` table instead of PATCHing
-- a remote HTTP API.
----------------------------------------------------------------------------------------------------

local function save(player, playerId, data)
    exports.connection:databaseQuery([[
        UPDATE `player_data` SET
            `position` = ?,
            `rotation` = ?,
            `skin` = ?,
            `interior` = ?,
            `dimension` = ?,
            `team` = ?,
            `weapons_in_hand` = ?,
            `health` = ?,
            `armor` = ?,
            `money` = ?,
            `wantedlevel` = ?,
            `clothes` = ?,
            `hunger` = ?,
            `thirst` = ?,
            `stamina` = ?,
            `weapons` = ?,
            `ammo` = ?
        WHERE `player_id` = ?
    ]],
        data.position,
        data.rotation,
        data.skin,
        data.interior,
        data.dimension,
        data.team,
        data.weapons_in_hand,
        data.health,
        data.armor,
        data.money,
        data.wantedlevel,
        data.clothes,
        data.hunger,
        data.thirst,
        data.stamina,
        data.weapons,
        data.ammo,
        playerId
    )
end


local function savePlayerData()
    local player = source
    local account = getPlayerAccount(player)

    if not account or isGuestAccount(account) then
        return
    end

    local playerId = getElementData(player, "playerId")
    if not playerId then
        return
    end

    -- get team name
    local team = getPlayerTeam(player)
    team = team and getTeamName(team) or "0"
    -- get position
    local x, y, z = getElementPosition(player)
    local position = toJSON({ x, y, z })
    -- get weapons in hand
    local weaponsInHand = {}
    for slot = 0, 12 do
        local weapon = getPedWeapon(player, slot)
        local ammo = getPedTotalAmmo(player, slot)
        if (weapon > 0) and (ammo > 0) then
            weaponsInHand[weapon] = ammo
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
        weapons_in_hand = toJSON(weaponsInHand),
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
    save(player, playerId, data)
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
