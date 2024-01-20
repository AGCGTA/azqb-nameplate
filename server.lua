local QBCore = exports['qb-core']:GetCoreObject()
local hidePlayers = {}
local cooldownPlayers = {}
local allPlayers = {}

RegisterNetEvent("azqb-nameplate:server:hide", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local cid = player.PlayerData.citizenid
    local players = allPlayers
    if cooldownPlayers[cid] ~= nil or hidePlayers[cid] ~= nil then
        -- TODO: クールタイム中
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.cooldown"), 'error')
    else
        -- TODO: 非表示処理
        hidePlayers[cid] = true
        TriggerClientEvent('azqb-nameplate:client:sync', -1, hidePlayers, players)
        -- TODO: 30秒間timeout後cooldown
        TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t("info.invisibled"), Config.Invisible / 1000), 'success')
        -- TriggerClientEvent('QBCore:Notify', src, Lang:t(string.format(, )), 'success')
        SetTimeout(Config.Invisible - Config.WarnCountdown, function()
            -- 警告表示
            TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t("info.visible_countdown"), Config.WarnCountdown / 1000), 'error')
            -- TriggerClientEvent('QBCore:Notify', src, Lang:t(string.format(, )), 'error')
            SetTimeout(Config.WarnCountdown, function()
                -- 非表示終了
                TriggerClientEvent('QBCore:Notify', src, Lang:t("info.visibled"), 'error')
                hidePlayers[cid] = nil
                cooldownPlayers[cid] = true
                TriggerClientEvent('azqb-nameplate:client:sync', -1, hidePlayers, players)
                SetTimeout(Config.Cooldown, function()
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("info.can_invisible"), 'success')
                    cooldownPlayers[cid] = nil
                end)
            end)
        end)
    end
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
        end

        table.sort(tempPlayers, function(a, b)
            return a.id < b.id
        end)
        allPlayers = tempPlayers
        TriggerClientEvent('azqb-nameplate:client:sync', -1, hidePlayers, allPlayers)
        Wait(1500)
    end
end)