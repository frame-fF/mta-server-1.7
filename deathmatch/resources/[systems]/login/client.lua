-- สร้างตัวแปรสำหรับเก็บ GUI elements
local loginWindow, usernameEdit, passwordEdit, loginButton, registerButton
local usernameLabel, passwordLabel
local sWidth, sHeight = guiGetScreenSize()
local bgTexture = nil


local function closeLoginGUI()
    removeEventHandler("onClientRender", root, renderBackground)
    -- ล้างเมมโมรี่รูปภาพ (Optional)
    if bgTexture then
        destroyElement(bgTexture)
        bgTexture = nil
    end

    if loginWindow and isElement(loginWindow) then
        destroyElement(loginWindow) 
        loginWindow = nil 
    end
    showCursor(false) 
end

local function renderBackground()
    if bgTexture then
        -- dxDrawImage(x, y, w, h, image, rotation, rotX, rotY, color, postGUI)
        -- จุดสำคัญคือ parameter สุดท้ายต้องเป็น 'false' เพื่อให้รูปอยู่หลัง Chatbox
        dxDrawImage(0, 0, sWidth, sHeight, bgTexture, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
end

local function createLoginGUI()
    if loginWindow and isElement(loginWindow) then return end

    if not bgTexture then
        bgTexture = dxCreateTexture("background.jpg")
    end

    removeEventHandler("onClientRender", root, renderBackground) 
    addEventHandler("onClientRender", root, renderBackground)
    
    -- ## 1. กำหนดค่าคงที่สำหรับขนาดและระยะห่าง ##
    local winWidth, winHeight = 350, 250 -- (เพิ่มความสูงหน้าต่างเล็กน้อย)
    local colWidth = 280 -- ความกว้างของช่องกรอกและปุ่ม
    local padding = 15  -- ระยะห่างระหว่างองค์ประกอบ
    local itemHeight = 28 -- ความสูงของช่องกรอก/ปุ่ม
    local labelHeight = 20 -- ความสูงของตัวหนังสือ

    -- คำนวณตำแหน่งกลางจอ
    local winX, winY = (sWidth - winWidth) / 2, (sHeight - winHeight) / 2
    local colX = (winWidth - colWidth) / 2 -- คำนวณ X กึ่งกลางสำหรับองค์ประกอบ

    -- สร้างหน้าต่าง
    loginWindow = guiCreateWindow(winX, winY, winWidth, winHeight, "Login", false)
    
    -- ## 2. ใช้ตัวแปร 'currentY' เพื่อติดตามตำแหน่งแนวตั้ง ##
    local currentY = padding * 2 -- เริ่มต้นที่ระยะห่างจากขอบบน

    -- Username
    usernameLabel = guiCreateLabel(colX, currentY, colWidth, labelHeight, "Username:", false, loginWindow) 
    currentY = currentY + labelHeight + (padding / 2) -- ขยับ Y ลงมา
    usernameEdit = guiCreateEdit(colX, currentY, colWidth, itemHeight, "", false, loginWindow) 
    currentY = currentY + itemHeight + padding -- ขยับ Y ลงมา (เว้นระยะห่าง)
    -- Password
    passwordLabel = guiCreateLabel(colX, currentY, colWidth, labelHeight, "Password:", false, loginWindow)
    currentY = currentY + labelHeight + (padding / 2) -- ขยับ Y ลงมา
    passwordEdit = guiCreateEdit(colX, currentY, colWidth, itemHeight, "", false, loginWindow)
    guiEditSetMasked(passwordEdit, true)
    currentY = currentY + itemHeight + (padding * 2) -- ขยับ Y ลงมา (เว้นระยะห่างเยอะหน่อย)

    -- Buttons
    local buttonWidth = (colWidth - padding) / 2 -- คำนวณความกว้างปุ่ม 2 ปุ่ม
    
    loginButton = guiCreateButton(colX, currentY, buttonWidth, itemHeight, "Login", false, loginWindow) 
    
    registerButton = guiCreateButton(colX + buttonWidth + padding, currentY, buttonWidth, itemHeight, "Register", false, loginWindow)

    -- เพิ่มอีเวนต์เมื่อกดปุ่ม Login
    addEventHandler("onClientGUIClick", loginButton,
        function()
            local username = guiGetText(usernameEdit)
            local password = guiGetText(passwordEdit)

            if username ~= "" and password ~= "" then
                triggerServerEvent("guiLoginAttempt", localPlayer, username, password)
            else
                outputChatBox("กรุณากรอกชื่อผู้ใช้และรหัสผ่าน")
            end
        end,
    false)
    
    -- เพิ่มอีเวนต์เมื่อกดปุ่ม Register
    addEventHandler("onClientGUIClick", registerButton,
        function()
            closeLoginGUI()
            triggerEvent("openRegisterGUI", localPlayer)
        end,
    false)

    -- แสดงเมาส์
    showCursor(true)
end



-- Handle Events

addEvent( "openLoginGUI", true )
addEventHandler( "openLoginGUI", localPlayer, createLoginGUI)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        createLoginGUI()
    end
)

addEventHandler("onClientPlayerSpawn", localPlayer,
    function()
        closeLoginGUI()
    end
)