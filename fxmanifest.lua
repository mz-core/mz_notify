fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name 'mz_notify'
author 'Mazus'
description 'Sistema de notificacoes NUI do ecossistema mz_'
version '1.0.0'

ui_page 'web/index.html'

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/lucide.min.js'
}