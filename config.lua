Config = {}

Config.discordLogs = false
Config.discordWebhook = "ENTER_YOUR_WEBHOOK"

Config.command = "steamreward"
Config.serverName = "YOUR_SERVER_NAME" -- this is the name of your server, it will be checked if the player has it in his steam name


Config.reward = {
    type = "money", -- or item / weapon
    value = 1000, -- here you can set the amount of money or the item/weapon name
    count = 1 -- here you can set the amount of items the player gets or the amount of ammo for the weapon

    -- example for item:
    -- type = "item",
    -- value = "bread",
    -- count = 1

    -- example for weapon:
    -- type = "weapon",
    -- value = "WEAPON_PISTOL",
    -- count = 100
}


Config.lang = {
    ["already_claimed"] = "You have already claimed your reward!",
    ["wrong_name"] = "You need to have the name of the server in your steam, insert this name: " .. Config.serverName,
    ["claimed"] = "Nice! Your reward has been sent to your inventory!",
}


-- If you use other notifications than esx:showNotification, you can change it here
function Notify (src,msg) 
    TriggerClientEvent('esx:showNotification', src, msg)
end