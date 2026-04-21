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

local function normalizePosition(position)
    if type(position) ~= 'string' then
        return Config.DefaultPosition
    end

    if not Config.Positions[position] then
        return Config.DefaultPosition
    end

    return position
end

local function splitByPipe(raw)
    local parts = {}

    if type(raw) ~= 'string' or raw == '' then
        return parts
    end

    for part in string.gmatch(raw, '([^|]+)') do
        parts[#parts + 1] = part
    end

    return parts
end

local function buildPayload(data)
    data = type(data) == 'table' and data or {}

    return {
        type = normalizeType(data.type),
        title = tostring(data.title or Config.DefaultTitle),
        message = tostring(data.message or ''),
        duration = normalizeDuration(data.duration),
        position = normalizePosition(data.position),
        persistent = data.persistent == true,
        id = data.id and tostring(data.id) or nil,
        icon = data.icon and tostring(data.icon) or nil
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

    sendNotify(source, {
        type = notifyType,
        title = 'Teste rápido',
        message = ('Tipo "%s" funcionando.'):format(notifyType),
        duration = 5000
    })
end, true)

RegisterCommand('mnotify', function(source, args)
    if source <= 0 then
        print('[mz_notify] Esse comando foi feito para player in-game.')
        return
    end

    local notifyType = args[1] or 'info'
    local raw = table.concat(args, ' ', 2)
    local parts = splitByPipe(raw)

    sendNotify(source, {
        type = notifyType,
        title = parts[1] or 'Teste mz_notify',
        message = parts[2] or 'Mensagem de teste.',
        duration = parts[3] and tonumber(parts[3]) or 5000
    })
end, true)

RegisterCommand('mnotifypos', function(source, args)
    if source <= 0 then
        print('[mz_notify] Esse comando foi feito para player in-game.')
        return
    end

    local notifyType = args[1] or 'info'
    local position = args[2] or Config.DefaultPosition
    local raw = table.concat(args, ' ', 3)
    local parts = splitByPipe(raw)

    sendNotify(source, {
        type = notifyType,
        position = position,
        title = parts[1] or ('Posição: %s'):format(position),
        message = parts[2] or 'Teste de posição.',
        duration = parts[3] and tonumber(parts[3]) or 5000
    })
end, true)

RegisterCommand('mnotifypersistent', function(source, args)
    if source <= 0 then
        print('[mz_notify] Esse comando foi feito para player in-game.')
        return
    end

    local notifyType = args[1] or 'warning'
    local position = args[2] or Config.DefaultPosition
    local raw = table.concat(args, ' ', 3)
    local parts = splitByPipe(raw)

    sendNotify(source, {
        type = notifyType,
        position = position,
        title = parts[1] or 'Persistent',
        message = parts[2] or 'Essa notify não deve sumir sozinha.',
        persistent = true,
        id = parts[3] or 'persistent_notify'
    })
end, true)

RegisterCommand('mnotifyid', function(source, args)
    if source <= 0 then
        print('[mz_notify] Esse comando foi feito para player in-game.')
        return
    end

    local notifyType = args[1] or 'info'
    local replaceId = args[2] or 'test_replace'
    local raw = table.concat(args, ' ', 3)
    local parts = splitByPipe(raw)

    sendNotify(source, {
        type = notifyType,
        id = replaceId,
        title = parts[1] or ('ID: %s'):format(replaceId),
        message = parts[2] or 'Se enviar novamente com o mesmo id, substitui.',
        duration = parts[3] and tonumber(parts[3]) or 5000
    })
end, true)

RegisterCommand('mnotifyall', function(source)
    if source <= 0 then
        print('[mz_notify] Esse comando foi feito para player in-game.')
        return
    end

    local types = {
        'success', 'error', 'warning', 'info',
        'police', 'money', 'vehicle', 'social',
        'location', 'phone', 'mechanic', 'health',
        'death', 'achievement', 'timer', 'mission'
    }

    for i = 1, #types do
        local notifyType = types[i]

        sendNotify(source, {
            type = notifyType,
            title = ('Tipo: %s'):format(notifyType),
            message = 'Preview de estilo/cor.',
            duration = 6000,
            position = Config.DefaultPosition,
            id = ('preview_%s'):format(notifyType)
        })
    end
end, true)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= RESOURCE_NAME then
        return
    end

    debugLog('resource iniciado')
end)