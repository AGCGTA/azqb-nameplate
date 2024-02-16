local QBCore = exports['qb-core']:GetCoreObject()
local hidePlayers = {}
local cooldownPlayers = {}
local allPlayers = {}

RegisterNetEvent("azqb-nameplate:server:hide-force", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local cid = player.PlayerData.citizenid
    if not IsPlayerAceAllowed(src, "admin") then
        return
    end
    if hidePlayers[cid] ~= nil then
        hidePlayers[cid] = nil
    else
        hidePlayers[cid] = true
    end
    TriggerClientEvent('azqb-nameplate:client:hideSync', -1, hidePlayers)
end)

RegisterNetEvent("azqb-nameplate:server:hide", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local cid = player.PlayerData.citizenid
    if cooldownPlayers[cid] ~= nil or hidePlayers[cid] ~= nil then
        -- クールタイム中
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.cooldown"), 'error')
    else
        -- 非表示処理
        hidePlayers[cid] = true
        TriggerClientEvent('azqb-nameplate:client:hideSync', -1, hidePlayers)
        -- 30秒間timeout後cooldown
        TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t("info.invisibled"), Config.Invisible / 1000), 'success')
        SetTimeout(Config.Invisible - Config.WarnCountdown, function()
            -- 警告表示
            TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t("info.visible_countdown"), Config.WarnCountdown / 1000), 'error')
            SetTimeout(Config.WarnCountdown, function()
                -- 非表示終了
                TriggerClientEvent('QBCore:Notify', src, Lang:t("info.visibled"), 'error')
                hidePlayers[cid] = nil
                cooldownPlayers[cid] = true
                TriggerClientEvent('azqb-nameplate:client:hideSync', -1, hidePlayers)
                SetTimeout(Config.Cooldown, function()
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("info.can_invisible"), 'success')
                    cooldownPlayers[cid] = nil
                end)
            end)
        end)
    end
end)

AddEventHandler('playerJoining', function(source)
    TriggerClientEvent('azqb-nameplate:client:hideSync', source, hidePlayers)
end)

CreateThread(function()
    while true do
        local tempPlayers = {}
        for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
            tempPlayers[#tempPlayers + 1] = {
                id = k,
                cid = v.PlayerData.citizenid,
                name = v.PlayerData.charinfo.firstname .. ' ' .. v.PlayerData.charinfo.lastname,
            }
            Wait(0)
        end

        table.sort(tempPlayers, function(a, b)
            return a.id < b.id
        end)
        allPlayers = tempPlayers
        TriggerClientEvent('azqb-nameplate:client:allSync', -1, allPlayers)
        Wait(1500)
    end
end)
