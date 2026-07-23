function playerRegister(source, username, email, password, password2)
    local player = source
    local url = exports.settings:baseUrl() .. '/api/player/register/'
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "POST",
        formFields = {
            username = username,
            email = email,
            password = password,
            password2 = password2
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 201 then
            addAccount(username, password)
            outputChatBox('Registration successful! You can now log in.', player, 0, 255, 0)
            -- ปิดหน้าต่างลงทะเบียนและเปิดหน้าต่างล็อกอิน
            triggerClientEvent(player, "closeRegisterGUI", player)
            triggerClientEvent(player, "openLoginGUI", player)
        else
            outputChatBox('Error: ' .. data, player)
        end
    end)
end


-- เพิ่ม Event Handler รับค่า
addEvent("guiRegisterAttempt", true)
addEventHandler("guiRegisterAttempt", root,
    function(username, email, password, password2)
        playerRegister(source, username, email, password, password2)
    end
)