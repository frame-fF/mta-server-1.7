local function onPlayerWasted()
    local player = source -- เก็บค่า source ไว้ใน local variable

    -- get team name
    local team = getPlayerTeam(player)
    local team = team and getTeamName(team)

    -- Set Health Armor Money Wantedlevel
    setElementHealth(player, 100)
    setPedArmor(player, 0)
    takePlayerMoney(player, get("wasted.take_player_money_value")) -- ลดเงินผู้เล่น 1000
    setPlayerWantedLevel(player, getPlayerWantedLevel(player))
    
    -- Set clothes
    local clothes = {}
    for type = 0, 17 do
        local texture, model = getPedClothes(player, type)
        if (texture) and (model) then
            table.insert(clothes, { texture, model, type })
        end
    end
    for _, cloth in ipairs(clothes) do
        addPedClothes(player, cloth[1], cloth[2], cloth[3])
    end

    -- Set Fighting style
    setPedFightingStyle(player, getPedFightingStyle(player))

    -- Set stats
    for stat = 0, 230 do
        local v = getPedStat(player, stat)
        if v and v > 0 then
            setPedStat(player, stat, v)
        end
    end

    -- รอ 3 วินาที แล้วสปอนผู้เล่นที่ San Fierro
    setTimer(function()
        spawnPlayer(
            player,
            -1969.4, 137.85, 27.69,
            0,
            getElementModel(player),
            0,
            0,
            team
        )
        fadeCamera(player, true)
        setCameraTarget(player, player)
    end, 3000, 1)
end

-- Event Handlers

addEventHandler("onPlayerWasted", root, onPlayerWasted)
