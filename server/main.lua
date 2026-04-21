local RESOURCE_NAME = GetCurrentResourceName()

local function debugLog(msg)
    if Config.Debug then
        print(('[%s][server] %s'):format(RESOURCE_NAME, msg))
    end
end

local function normalizeType(notifyType)
    if type(notifyType) ~= 'string' then
        return 'info'
    end

    notifyType = notifyType:lower()

    if not Config.Types[notifyType] then
        return 'info'
    end

    return notifyType
end

local function normalizeDuration(duration)
    duration = tonumber(duration)
    if not duration or duration < 1000 then
        return Config.DefaultDuration
    end
    return math.floor(duration)
end

local function buildPayload(data)
    data = type(data) == 'table' and data or {}

    local notifyType = normalizeType(data.type)
    local title = tostring(data.title or Config.DefaultTitle)
    local message = tostring(data.message or '')
    local duration = normalizeDuration(data.duration)
    local position = Config.Positions[data.position] and data.position or Config.DefaultPosition
    local persistent = data.persistent == true
    local id = data.id and tostring(data.id) or nil
    local icon = data.icon and tostring(data.icon) or nil

    return {
        type = notifyType,
        title = title,
        message = message,
        duration = duration,
        position = position,
        persistent = persistent,
        id = id,
        icon = icon
    }
end

local function sendNotify(target, data)
    local payload = buildPayload(data)
    TriggerClientEvent('mz_notify:client:show', target, payload)
end

exports('Notify', function(target, data)
    sendNotify(target, data)
end)

RegisterNetEvent('mz_notify:server:notify', function(data)
    local src = source
    sendNotify(src, data)
end)

RegisterCommand('mnotifytest', function(source, args)
    if source <= 0 then
        print('[mz_notify] Esse comando foi feito para player in-game.')
        return
    end

    local notifyType = args[1] or 'info'
    local payload = {
        type = notifyType,
        title = 'Teste mz_notify',
        message = ('Notificação de teste do tipo "%s" funcionando.'):format(notifyType),
        duration = 5000
    }

    sendNotify(source, payload)
end, true)

RegisterCommand('mnotify', function(source, args)
    if source <= 0 then
        print('[mz_notify] Esse comando foi feito para player in-game.')
        return
    end

    local notifyType = args[1] or 'info'
    local raw = table.concat(args, ' ', 2)

    local title = 'Teste mz_notify'
    local message = 'Mensagem de teste.'
    local duration = 5000

    if raw and raw ~= '' then
        local parts = {}
        for part in string.gmatch(raw, '([^|]+)') do
            parts[#parts + 1] = part
        end

        if parts[1] and parts[1] ~= '' then
            title = parts[1]
        end

        if parts[2] and parts[2] ~= '' then
            message = parts[2]
        end

        if parts[3] and parts[3] ~= '' then
            duration = tonumber(parts[3]) or 5000
        end
    end

    sendNotify(source, {
        type = notifyType,
        title = title,
        message = message,
        duration = duration
    })
end, true)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= RESOURCE_NAME then
        return
    end

    debugLog('resource iniciado')
end)