local function playerLogin(source, username, password)
    local player = source
    local url = exports.settings:baseUrl() .. '/api/player/login/'
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "POST",
        formFields = {
            username = username,
            password = password,
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            -- เก็บค่า JSON data
            local result = fromJSON(data)

            -- setElementData results
            setElementData(player, "results", result)

            -- เช็คว่าเคยร์มีอยู่ในระบบหรือไม่
            local account = getAccount(username, password)
            if (account ~= false) then
                -- ถ้ามีแล้วให้ทำการล็อกอิน
                logIn(player, account, password)
            else
                -- ถ้าไม่มีให้สร้างบัญชีใหม่แล้วทำการล็อกอิน
                local new_account = addAccount(username, password)
                logIn(player, new_account, password)
            end
        else
            outputChatBox('Error: ' .. data, player)
        end
    end)
end

local function onPlayerLogin()
    local player = source  -- เก็บค่า source ไว้ใน local variable
    local username = getPlayerName(player)
    local url = exports.settings:baseUrl() .. '/api/player/me/'
    local key = getElementData(player, "results").key

    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "GET",
        headers = {
            ["Authorization"] = "Token " .. key
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then
            local result = fromJSON(data)
            local player_data = result.data

            -- Set ElementData
            setElementData(player, "weapons", player_data.weapons[1])
            setElementData(player, "ammo", player_data.ammo[1])
            setElementData(player, "hunger", 100)
            setElementData(player, "thirst", 100)
            setElementData(player, "stamina", 100)
            -- Set player positiona
            local x, y, z = unpack(player_data.position[1])

            -- Set player team
            team = player_data.team and getTeamFromName(player_data.team)

            -- Spawn player with saved datas
            spawnPlayer(
                player,
                x, y, z,
                player_data.rotation,
                player_data.skin,
                player_data.interior,
                player_data.dimension,
                team
            )

            -- Set player name
            setPlayerName(player, result.username)
            
            -- Give weapons
            local weapons_in_hand = unpack(player_data.weapons_in_hand)
            for weapon, ammo in pairs(weapons_in_hand) do
                giveWeapon(player, weapon, ammo)
            end
            -- Set Health Armor Money Wantedlevel
            setElementHealth(player, player_data.health)
            setPedArmor(player, player_data.armor)
            setPlayerMoney(player, player_data.money)
            setPlayerWantedLevel(player, player_data.wantedlevel)
            -- Set clothes
            clothes = unpack(player_data.clothes)
            for _, cloth in ipairs(clothes) do
                addPedClothes(player, cloth[1], cloth[2], cloth[3])
            end
            -- Set Camera
            fadeCamera(player, true)
            setCameraTarget(player, player)
        else
            outputChatBox('Error: ' .. data, player)
        end
    end)
end


-- local function commandLogin(source, command, username, password)
--     playerLogin(source, username, password)
-- end

-- เพิ่ม Event Handler รับค่า
addEvent("guiLoginAttempt", true)
addEventHandler("guiLoginAttempt", root,
    function(username, password)
        playerLogin(source, username, password)
    end
)

addEventHandler("onPlayerLogin", root, onPlayerLogin)