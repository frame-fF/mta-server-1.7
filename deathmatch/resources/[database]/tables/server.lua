addEventHandler("onResourceStart", resourceRoot,
function ()
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
end)