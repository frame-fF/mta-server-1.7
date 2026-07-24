----------------------------------------------------------------------------------------------------
---                                            NOTES                                              ---
----------------------------------------------------------------------------------------------------
-- Authenticates players against the MySQL `player_accounts` table (bcrypt via passwordHash /
-- passwordVerify) instead of a remote HTTP API. Once the credentials are verified, the player is
-- still logged into MTA's own account system (addAccount/logIn) so that ACL, admin panels, and
-- other resources that rely on getPlayerAccount keep working as before. Saved gameplay data is
-- then loaded from the `player_data` table.
----------------------------------------------------------------------------------------------------

local function loadPlayerData(player, playerId)
    local rows = exports.connection:databaseQuery(
        "SELECT * FROM `player_data` WHERE `player_account_id` = ?", playerId
    )
    local playerData = rows and rows[1]

    if not playerData then
        outputChatBox("Warning: could not load your saved data.", player, 255, 150, 0)
        fadeCamera(player, true)
        setCameraTarget(player, player)
        return
    end

    local position = fromJSON(playerData.position)
    if type(position) ~= "table" then
        position = {-1969.4, 137.85, 27.69}
    end
    local x, y, z = position[1], position[2], position[3]
    local team = playerData.team and playerData.team ~= "0" and getTeamFromName(playerData.team) or nil

    spawnPlayer(
        player, -- player
        x, y, z, -- x y z
        playerData.rotation, -- rotation
        playerData.skin, -- skin
        playerData.interior, -- interior
        playerData.dimension, -- dimension
        team -- team
    )

    -- 1. Give weapons in hand
    local weapons = fromJSON(playerData.weapons) or {}
    takeAllWeapons(player)
    for weapon, ammo in pairs(weapons) do
        giveWeapon(player, tonumber(weapon), ammo, true)
    end

    -- 2. Health / Armor / Money / Wanted level
    setElementHealth(player, playerData.health)
    setPedArmor(player, playerData.armor)
    setPlayerMoney(player, playerData.money)
    setPlayerWantedLevel(player, playerData.wantedlevel)

    -- 3. Clothes
    local clothes = fromJSON(playerData.clothes) or {}
    for _, cloth in ipairs(clothes) do
        addPedClothes(player, cloth[1], cloth[2], cloth[3])
    end

    -- 4. Stats
    local stats = fromJSON(playerData.stats)
    if type(stats) == "table" then
        for stat, value in pairs(stats) do
            setPedStat(player, tonumber(stat), value)
        end
    end

    -- 5. Fighting style
    if playerData.fighting_style then
        setPedFightingStyle(player, tonumber(playerData.fighting_style) or 4)
    end

    -- 6. Element data (used by other gameplay resources)
    setElementData(player, "zombie_kills", playerData.zombie_kills)

    fadeCamera(player, true)
    setCameraTarget(player, player)
end

local function playerLogin(source, username, password)
    local player = source

    if type(username) ~= "string" or type(password) ~= "string" or username == "" or password == "" then
        outputChatBox("Please enter a valid username and password.", player, 255, 0, 0)
        return
    end

    local rows = exports.connection:databaseQuery(
        "SELECT `id`, `username`, `password` FROM `player_accounts` WHERE `username` = ?", username
    )
    local accountRow = rows and rows[1]

    if not accountRow then
        outputChatBox("Account not found. Please register first.", player, 255, 0, 0)
        return
    end

    passwordVerify(password, accountRow.password, {}, function(matches)
        if not isElement(player) then return end

        if not matches then
            outputChatBox("Incorrect username or password.", player, 255, 0, 0)
            return
        end

        -- Bridge the verified MySQL account into MTA's own account system so ACL/admin
        -- resources relying on getPlayerAccount / getAccountName keep working unchanged.
        local account = getAccount(accountRow.username)
        if not account then
            account = addAccount(accountRow.username, password)
        end

        if not account then
            outputChatBox("Login failed, please try again.", player, 255, 0, 0)
            return
        end

        setElementData(player, "playerId", accountRow.id)

        if not logIn(player, account, password) then
            outputChatBox("Login failed, please try again.", player, 255, 0, 0)
        end
    end)
end

local function onPlayerLogin(_, account)
    local player = source
    local playerId = getElementData(player, "playerId")

    if not playerId then
        -- Login triggered outside of the MySQL flow (e.g. console/admin login), nothing to load.
        return
    end

    loadPlayerData(player, playerId)
end

-- เพิ่ม Event Handler รับค่า
addEvent("guiLoginAttempt", true)
addEventHandler("guiLoginAttempt", root,
    function(username, password)
        playerLogin(source, username, password)
    end
)

addEventHandler("onPlayerLogin", root, onPlayerLogin)
