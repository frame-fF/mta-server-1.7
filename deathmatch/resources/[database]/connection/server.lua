----------------------------------------------------------------------------------------------------
---                                            NOTES                                              ---
----------------------------------------------------------------------------------------------------
-- Owns the single MySQL connection handle for the project. Other resources should never call
-- dbConnect() themselves; they must go through exports.database (databaseGetConnection / databaseQuery)
-- so the connection stays centralized and swappable from one place.
----------------------------------------------------------------------------------------------------
---                                            TABLES                                            ---
----------------------------------------------------------------------------------------------------
local connection = nil

----------------------------------------------------------------------------------------------------
---                                          FUNCTIONS                                           ---
----------------------------------------------------------------------------------------------------

-- Opens (or returns the existing) MySQL connection using the settings configured in meta.xml.
function databaseConnect()
    if isElement(connection) then return connection end

    local host     = get("host") or "127.0.0.1"
    local port     = tonumber(get("port")) or 3306
    local username = get("username") or "root"
    local password = get("password") or "password"
    local dbname   = get("database") or "mta_server"
    local charset  = get("charset") or "utf8mb4"

    local connectionString = ("dbname=%s;host=%s;port=%d;charset=%s"):format(dbname, host, port, charset)

    connection = dbConnect("mysql", connectionString, username, password)

    if not connection then
        outputDebugString(("[database] Failed to connect to MySQL '%s' at %s:%d"):format(dbname, host, port), 1)
        return false
    end

    outputDebugString(("[database] Connected to MySQL '%s' at %s:%d"):format(dbname, host, port), 3)
    return connection
end

-- Closes the connection if it is open.
function databaseDisconnect()
    if isElement(connection) then
        destroyElement(connection)
    end
    connection = nil
end

-- Returns the raw connection handle (dbQuery/dbExec/etc. can be used directly with it).
function databaseGetConnection()
    return connection
end

function databaseIsConnected()
    return isElement(connection)
end

-- Convenience synchronous query helper for other resources, e.g.:
--   local result = exports.database:databaseQuery("SELECT * FROM accounts WHERE username = ?", username)
function databaseQuery(query, ...)
    if not isElement(connection) then
        outputDebugString("[database] Query attempted with no active connection: "..tostring(query), 1)
        return false
    end

    local queryHandle = dbQuery(connection, query, ...)
    local result, numAffectedRows, lastInsertId = dbPoll(queryHandle, -1)
    return result, numAffectedRows, lastInsertId
end

----------------------------------------------------------------------------------------------------
---                                        RESOURCE START                                        ---
----------------------------------------------------------------------------------------------------
addEventHandler("onResourceStart", resourceRoot,
function ()
    if not databaseConnect() then
        outputDebugString("[database] Resource started but could not establish a MySQL connection. Check the settings in meta.xml.", 1)
    end
end)

addEventHandler("onResourceStop", resourceRoot,
function ()
    databaseDisconnect()
end)
