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

    exports.connection:databaseQuery([[
        CREATE TABLE IF NOT EXISTS `player_data` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `account_id` INT UNSIGNED NOT NULL,
            `key` VARCHAR(64) NOT NULL,
            `value` LONGTEXT DEFAULT NULL,
            `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `account_key_unique` (`account_id`, `key`),
            CONSTRAINT `fk_player_data_account` FOREIGN KEY (`account_id`) REFERENCES `player_accounts` (`id`) ON DELETE CASCADE
        )
    ]])
end)
