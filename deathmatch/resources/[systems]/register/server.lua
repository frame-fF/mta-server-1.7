----------------------------------------------------------------------------------------------------
---                                            NOTES                                              ---
----------------------------------------------------------------------------------------------------
-- Registers a new player account directly in MySQL (player_accounts table) instead of calling
-- a remote HTTP API. Passwords are hashed with bcrypt via passwordHash before being stored.
----------------------------------------------------------------------------------------------------

local function isValidUsername(username)
    return type(username) == "string" and #username >= 3 and #username <= 64
end

local function isValidPassword(password)
    return type(password) == "string" and #password >= 5 and #password <= 30
end

function playerRegister(source, username, email, password, password2)
    local player = source

    if not isValidUsername(username) then
        outputChatBox("Username must be between 3 and 64 characters.", player, 255, 0, 0)
        return
    end

    if not isValidPassword(password) then
        outputChatBox("Password must be between 5 and 30 characters.", player, 255, 0, 0)
        return
    end

    if password ~= password2 then
        outputChatBox("Passwords do not match.", player, 255, 0, 0)
        return
    end

    -- เช็คว่ามี username นี้อยู่แล้วในฐานข้อมูลหรือไม่
    local existing = exports.connection:databaseQuery(
        "SELECT `id` FROM `player_accounts` WHERE `username` = ?", username
    )

    if existing and existing[1] then
        outputChatBox("Username already exists.", player, 255, 0, 0)
        return
    end

    passwordHash(password, "bcrypt", {}, function(hash)
        if not hash then
            outputChatBox("Registration failed, please try again.", player, 255, 0, 0)
            return
        end

        if not isElement(player) then return end

        local ip = getPlayerIP(player)
        local serial = getPlayerSerial(player)

        local _, _, insertId = exports.connection:databaseQuery(
            "INSERT INTO `player_accounts` (`username`, `password`, `email`, `ip`, `serial`) VALUES (?, ?, ?, ?, ?)",
            username, hash, email, ip, serial
        )

        if not insertId then
            outputChatBox("Registration failed, please try again.", player, 255, 0, 0)
            return
        end

        outputChatBox('Registration successful! You can now log in.', player, 0, 255, 0)

        -- ปิดหน้าต่างลงทะเบียนและเปิดหน้าต่างล็อกอิน
        triggerClientEvent(player, "closeRegisterGUI", player)
        triggerClientEvent(player, "openLoginGUI", player)
    end)
end


-- เพิ่ม Event Handler รับค่า
addEvent("guiRegisterAttempt", true)
addEventHandler("guiRegisterAttempt", root,
    function(username, email, password, password2)
        playerRegister(source, username, email, password, password2)
    end
)
