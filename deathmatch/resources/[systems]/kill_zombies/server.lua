addEvent("onZombieWasted", true)

addEventHandler("onZombieWasted", root, function(killer, weapon, bodypart)
    if killer and getElementType(killer) == "player" then
        if bodypart == 9 then
            givePlayerMoney(killer, 1000) -- ยิงหัวได้ 1000
        else
            givePlayerMoney(killer, 100)  -- ยิงส่วนอื่นได้ 100
        end
    end
end)