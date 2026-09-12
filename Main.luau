-- Define the URLs for the required scripts
local scriptURL = "https://raw.githubusercontent.com/hamletirl/sunjingwoo/refs/heads/main/sunjingwoo"
local notificationLibraryURL = "https://raw.githubusercontent.com/IceMinisterq/Notification-Library/Main/Library.lua"

-- Function to fetch data from a URL
local function fetchScript(url)
    if not url or type(url) ~= "string" then
        warn("Invalid URL provided. The script cannot be fetched.")
        return nil
    end

    local success, response = pcall(game.HttpGet, game, url)

    if success and response then
        print("Successfully fetched script from: " .. url)
        return response
    else
        warn("Failed to fetch script from: " .. url)
        return nil
    end
end

-- Function to load and execute a script
local function executeScript(scriptContent)
    if not scriptContent or type(scriptContent) ~= "string" then
        warn("Invalid script content. Execution aborted.")
        return
    end

    local scriptFunction, loadError = loadstring(scriptContent)

    if scriptFunction then
        print("Script successfully loaded. Executing now...")
        local success, executionError = pcall(scriptFunction)

        if success then
            print("Script executed successfully!")
        else
            warn("Error encountered while executing the script: " .. tostring(executionError))
        end
    else
        warn("Failed to load script: " .. tostring(loadError))
    end
end

-- Function to load the notification library
local function loadNotificationLibrary()
    local fetchedLibraryScript = fetchScript(notificationLibraryURL)

    if fetchedLibraryScript then
        local NotificationLibrary = loadstring(fetchedLibraryScript)()

        if NotificationLibrary then
            print("Notification Library loaded successfully!")
            return NotificationLibrary
        else
            warn("Failed to initialize the Notification Library.")
            return nil
        end
    else
        warn("Library retrieval failed. Execution terminated.")
        return nil
    end
end

-- Function to send notifications and console messages
local function notify(theme, message, duration)
    if _G.NotificationLibrary then
        _G.NotificationLibrary:SendNotification(theme, message, duration)
    end
    print(message)
end

-- Load Notification Library globally
_G.NotificationLibrary = loadNotificationLibrary()

-- Fetch and execute the main script
print("Attempting to fetch and execute the main script...")
local fetchedScript = fetchScript(scriptURL)

if fetchedScript then
    notify("Info", "Main script retrieved. Executing now...", 3)
    executeScript(fetchedScript)
    notify("Success", "Main script executed successfully!", 3)
else
    notify("Error", "Main script retrieval failed. Execution terminated.", 3)
end