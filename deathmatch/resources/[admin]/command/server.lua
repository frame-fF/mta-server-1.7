function getPosition(source)
    x, y, z = getElementPosition(source)
    rx, ry, rz = getElementRotation(source)
    local interior = getElementInterior(source)
    local dimension = getElementDimension(source)
    outputChatBox("Posicion: " .. x .. ", " .. y .. ", " .. z, source, 255, 255, 0)
    outputChatBox("Rotacion: " .. rx .. ", " .. ry .. ", " .. rz, source, 255, 255, 0)
end
addCommandHandler("getpos", getPosition)

addEvent("onPlayerInteriorWarped", true)
addEventHandler("onPlayerInteriorWarped", root,
    function(warpedInterior)
        local interiorName = exports.interiors:getInteriorName(warpedInterior)
        local interior = getElementInterior(source)
        local dimension = getElementDimension(source)
        outputChatBox("Has entrado en el interior: " .. interiorName, source, 0, 255, 0)
        outputChatBox("Interior ID: " .. interior, source, 255, 255, 0)
        outputChatBox("Dimension ID: " .. dimension, source, 255, 255, 0)
    end
)

addCommandHandler("bot", function(player)
    -- ดึงพิกัดของผู้เล่นที่พิมพ์คำสั่ง
    local x, y, z = getElementPosition(player)
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)
    
    -- สร้างบอทให้อยู่ใกล้ๆ ผู้เล่น (X + 2)
    -- exports.slothbot:spawnBot(x, y, z, rotation, skin, interior, dimension, team, weapon, mode)
    -- ตัวอย่าง: สกิน 287 (ทหาร), อาวุธ 31 (M4), โหมด "hunting" (เดินตามล่า)
    local bot = exports.slothbot:spawnBot(x + 2, y, z, 0, 287, interior, dimension, nil, 31, "hunting")
    
    if bot then
        outputChatBox("สร้างบอทสำเร็จ!", player, 0, 255, 0)
    else
        outputChatBox("สร้างบอทไม่สำเร็จ โปรดตรวจสอบว่าเปิด resource slothbot หรือยัง", player, 255, 0, 0)
    end
end)
