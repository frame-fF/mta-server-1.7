-- ฟังก์ชันสำหรับปิดวิทยุ
function disableRadio()
    -- ปิดช่องวิทยุเป็น 0 (ปิดเสียง)
    setRadioChannel(0)
end

-- ทำงานเมื่อ Resource เริ่มทำงาน (ผู้เล่นเข้าเกมหรือสคริปต์ถูก Start)
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        -- ปิดการควบคุมปุ่มเปลี่ยนวิทยุ (ถัดไป/ก่อนหน้า)
        toggleControl("next_radio", false)
        toggleControl("previous_radio", false)
        
        -- เรียกฟังก์ชันปิดเสียง
        disableRadio()
    end
)

-- ทำงานเมื่อผู้เล่นขึ้นรถ (เพื่อความชัวร์ว่าวิทยุจะไม่ดังขึ้นมาเอง)
addEventHandler("onClientPlayerVehicleEnter", localPlayer,
    function()
        disableRadio()
    end
)

-- (ตัวเลือกเสริม) บังคับปิดเสียงทุกๆ ครั้งที่มีการพยายามเปลี่ยนช่อง (เผื่อมีสคริปต์อื่นเปิดมัน)
addEventHandler("onClientPlayerRadioSwitch", root,
    function()
        disableRadio()
        cancelEvent() -- ยกเลิกการเปลี่ยนช่อง
    end
)