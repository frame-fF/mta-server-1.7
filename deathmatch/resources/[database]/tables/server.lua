----------------------------------------------------------------------------------------------------
---                                          FUNCTIONS                                           ---
----------------------------------------------------------------------------------------------------

-- Adds a column to a table only if it doesn't already exist, so existing installs can be
-- upgraded in place without erroring on resource restart.
local function ensureColumn(tableName, columnName, definition)
    local rows = exports.connection:databaseQuery(
        "SELECT COUNT(*) AS cnt FROM `information_schema`.`COLUMNS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = ? AND `COLUMN_NAME` = ?",
        tableName, columnName
    )

    if rows and rows[1] and tonumber(rows[1].cnt) == 0 then
        exports.connection:databaseQuery(("ALTER TABLE `%s` ADD COLUMN `%s` %s"):format(tableName, columnName, definition))
    end
end

addEventHandler("onResourceStart", resourceRoot,
function ()
    -- สร้างตาราง player_accounts ถ้ายังไม่มี
    exports.connection:databaseQuery([[
        CREATE TABLE IF NOT EXISTS `player_accounts` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `username` VARCHAR(64) NOT NULL,
            `password` VARCHAR(255) NOT NULL,
            `email` VARCHAR(255) DEFAULT NULL,
            `ip` VARCHAR(45) DEFAULT NULL,
            `serial` VARCHAR(32) DEFAULT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `username_unique` (`username`)
        )
    ]])

    -- สร้างตาราง player_data ถ้ายังไม่มี
    exports.connection:databaseQuery([[
        CREATE TABLE IF NOT EXISTS `player_data` (
            `player_id` INT UNSIGNED NOT NULL,
            `position` JSON DEFAULT NULL,
            `rotation` FLOAT DEFAULT 0,
            `skin` INT DEFAULT 0,
            `interior` INT DEFAULT 0,
            `dimension` INT DEFAULT 0,
            `team` VARCHAR(50) DEFAULT '0',
            `health` INT DEFAULT 100,
            `money` INT DEFAULT 0,
            `weapons_in_hand` JSON DEFAULT NULL,
            `weapons` JSON DEFAULT NULL,
            `ammo` JSON DEFAULT NULL,
            `armor` FLOAT DEFAULT 100.00,
            `clothes` JSON DEFAULT NULL,
            `stats` JSON DEFAULT NULL,
            `wantedlevel` INT DEFAULT 0,
            `hunger` INT DEFAULT 100,
            `thirst` INT DEFAULT 100,
            `stamina` INT DEFAULT 100,
            PRIMARY KEY (`player_id`),
            CONSTRAINT `fk_player_data_player` FOREIGN KEY (`player_id`) REFERENCES `player_accounts` (`id`) ON DELETE CASCADE
        )
    ]])

    -- อัพเกรดตารางเดิม (ถ้ามีอยู่แล้วก่อนเพิ่มคอลัมน์เหล่านี้) ให้มีคอลัมน์ hunger/thirst/stamina
    ensureColumn("player_data", "hunger", "INT DEFAULT 100")
    ensureColumn("player_data", "thirst", "INT DEFAULT 100")
    ensureColumn("player_data", "stamina", "INT DEFAULT 100")

    -- ลบ trigger เดิมก่อน (ถ้ามี) เพื่อรองรับการ restart resource โดยไม่ error
    exports.connection:databaseQuery([[
        DROP TRIGGER IF EXISTS `trg_player_accounts_after_insert`
    ]])

    -- เมื่อมีการเพิ่ม player_accounts ใหม่ ให้สร้างแถว player_data คู่กันอัตโนมัติ (พร้อมค่า default ตามที่กำหนด)
    exports.connection:databaseQuery([=[
        CREATE TRIGGER `trg_player_accounts_after_insert`
        AFTER INSERT ON `player_accounts`
        FOR EACH ROW
        INSERT INTO `player_data` (
            `player_id`, `position`, `rotation`, `skin`, `interior`, `dimension`, `team`,
            `health`, `money`, `weapons_in_hand`, `weapons`, `ammo`, `armor`, `clothes`, `stats`, `wantedlevel`,
            `hunger`, `thirst`, `stamina`
        ) VALUES (
            NEW.id,
            '[-1969.4, 137.85, 27.69]',
            0,
            0,
            0,
            0,
            '0',
            100,
            0,
            '[]',
            '[]',
            '[]',
            100.00,
            '[["hoodyAblack", "hoodyA", 0], ["player_face", "head", 1], ["chongergrey", "chonger", 2], ["sneakerbincblk", "sneaker", 3], ["hockey", "hockeymask", 16]]',
            '[]',
            0,
            100,
            100,
            100
        )
    ]=])

end)
