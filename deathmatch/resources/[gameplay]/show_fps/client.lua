-- ตัวแปรสำหรับจัดการขนาดหน้าจอ
local screenW, screenH = guiGetScreenSize()

-- ตัวแปรสำหรับการคำนวณ FPS
local fps = 0
local startTime = getTickCount()
local frames = 0

-- ฟังก์ชันหลักที่จะทำงานทุกเฟรม (Frame)
addEventHandler("onClientRender", root,
    function()
        -- 1. คำนวณ FPS
        local currentTime = getTickCount()
        frames = frames + 1 -- เพิ่มจำนวนเฟรมขึ้นเรื่อยๆ

        -- ถ้าเวลาผ่านไปครบ 1000 มิลลิวินาที (1 วินาที)
        if (currentTime - startTime) >= 1000 then
            fps = frames            -- บันทึกค่า FPS ปัจจุบัน
            frames = 0              -- รีเซ็ตตัวนับเฟรม
            startTime = currentTime -- รีเซ็ตเวลาเริ่มต้นใหม่
        end

        -- 2. ดึงค่า Ping ของผู้เล่น
        local ping = getPlayerPing(localPlayer)

        -- 3. เตรียมข้อความที่จะแสดง
        -- รูปแบบ: Ping: 45 | FPS: 60
        local displayText = "Ping: " .. ping .. " | FPS: " .. fps

        -- 4. วาดข้อความลงบนหน้าจอ (ใช้ขอบสีดำ เพื่อให้อ่านง่ายขึ้น - Outline)
        -- วาดเงาสีดำ (ขยับตำแหน่งไป 1 พิกเซล)
        dxDrawText(displayText, screenW - 10 + 1, 10 + 1, screenW - 10 + 1, 30 + 1, tocolor(0, 0, 0, 255), 1.5, "default-bold", "right", "top")
        
        -- วาดตัวหนังสือสีขาว (สีหลัก)
        -- อธิบาย parameter: ข้อความ, ตำแหน่งX, ตำแหน่งY, ขอบเขตX, ขอบเขตY, สี, ขนาด, ฟอนต์, จัดชิดขวา, จัดชิดบน
        dxDrawText(displayText, screenW - 10, 10, screenW - 10, 30, tocolor(255, 255, 255, 255), 1.5, "default-bold", "right", "top")
    end
)