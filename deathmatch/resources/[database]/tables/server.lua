addEventHandler("onResourceStart", resourceRoot,
function ()
    -- สร้างตาราง player_accounts ถ้ายังไม่มี
    exports.connection:databaseQuery([[
        CREATE TABLE IF NOT EXISTS `player_accounts` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `account` VARCHAR(64) NOT NULL,
            `serial` VARCHAR(32) DEFAULT NULL,
            `money` INT DEFAULT 0,
            `data` LONGTEXT DEFAULT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `account_unique` (`account`)
        )
    ]])
    
    -- สร้างตาราง player_data ถ้ายังไม่มี
    exports.connection:databaseQuery([[
        CREATE TABLE IF NOT EXISTS `player_data` (
            `account_id` INT UNSIGNED NOT NULL,
            `level` INT DEFAULT 1,
            `exp` INT DEFAULT 0,
            `kills` INT DEFAULT 0,
            `deaths` INT DEFAULT 0,
            `playtime` INT DEFAULT 0,
            PRIMARY KEY (`account_id`),
            CONSTRAINT `fk_player_data_account` FOREIGN KEY (`account_id`) REFERENCES `player_accounts` (`id`) ON DELETE CASCADE
        )
    ]])

    -- ลบ trigger เดิมก่อน (ถ้ามี) เพื่อรองรับการ restart resource โดยไม่ error
    exports.connection:databaseQuery([[
        DROP TRIGGER IF EXISTS `trg_player_accounts_after_insert`
    ]])

    -- เมื่อมีการเพิ่ม player_accounts ใหม่ ให้สร้างแถว player_data คู่กันอัตโนมัติ
    exports.connection:databaseQuery([[
        CREATE TRIGGER `trg_player_accounts_after_insert`
        AFTER INSERT ON `player_accounts`
        FOR EACH ROW
        INSERT INTO `player_data` (`account_id`) VALUES (NEW.id)
    ]])

end)
