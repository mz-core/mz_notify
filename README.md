# mz_notify

Sistema de notificações NUI para o ecossistema `mz_`.

## Recursos

- 4 tipos de notificação: `success`, `error`, `warning`, `info`
- NUI leve e simples
- uso via evento client
- uso via export client
- comandos de teste
- posição configurável
- progress bar
- dedupe por `id`

## Instalação

Adicione o resource na pasta do servidor e faça o `ensure` no seu `server.cfg`:

```cfg
ensure mz_notify
Uso via server
TriggerClientEvent('mz_notify:client:show', source, {
    type = 'success',
    title = 'Inventário',
    message = 'Item adicionado com sucesso.',
    duration = 5000
})
Uso via export client
exports['mz_notify']:Notify({
    type = 'info',
    title = 'Sistema',
    message = 'Olá mundo.',
    duration = 5000
})
Payload suportado
{
    type = 'success', -- success | error | warning | info
    title = 'Título',
    message = 'Mensagem da notificação',
    duration = 5000,
    id = 'notify_unique_id',
    persistent = false,
    position = 'top-right',
    icon = 'check'
}
Tipos disponíveis
success
error
warning
info
Posições disponíveis
top-right
top-left
bottom-right
bottom-left
Comandos de teste
Notificação rápida por tipo
/mnotifytest success
/mnotifytest error
/mnotifytest warning
/mnotifytest info
Notificação personalizada
/mnotify success Inventário|Item recebido com sucesso|5000
/mnotify error Sistema|Algo deu errado|5000
/mnotify warning Atenção|Você está sem permissão|5000
/mnotify info MZ Core|Teste visual da notify|5000
Observações
duration padrão: 5000
position padrão: top-right
persistent = true impede remoção automática
se um id igual for enviado novamente, a notificação anterior é substituída
caso a NUI não responda, o resource pode usar fallback por print no client
Exemplo de integração
Server -> client
TriggerClientEvent('mz_notify:client:show', source, {
    type = 'success',
    title = 'Garagem',
    message = 'Veículo guardado com sucesso.',
    duration = 5000
})
Client export
exports['mz_notify']:Notify({
    type = 'info',
    title = 'mz_notify',
    message = 'Notificação enviada pelo client.',
    duration = 5000
})
ACE / permissões

Se quiser restringir os comandos de teste para o grupo mz_owner, use este padrão no seu arquivo de permissões:

add_ace group.mz_owner command allow
add_ace group.mz_owner command.quit deny

add_principal identifier.fivem:SEU_ID_FIVEM_AQUI group.mz_owner
add_principal identifier.fivem:ID_DO_SOCIO_AQUI group.mz_owner
Estrutura do resource
mz_notify/
├─ fxmanifest.lua
├─ README.md
├─ shared/
│  └─ config.lua
├─ server/
│  └─ main.lua
├─ client/
│  └─ main.lua
└─ web/
   ├─ index.html
   ├─ style.css
   └─ app.js
Objetivo da v1

A proposta da v1 do mz_notify é ser um sistema simples, reutilizável e padronizado para o ecossistema mz_, sem depender de frameworks pesados de frontend e sem acoplar a lógica ao mz_core.

Fora do escopo da v1
histórico persistente
central de notificações
múltiplos temas visuais
ações clicáveis
integração com banco de dados
animações complexas
sistema avançado de sons
Roadmap futuro

Possíveis melhorias para versões futuras:

ícones SVG mais refinados
som opcional por tipo
botão de fechar para notificações persistentes
integração visual mais forte com a identidade da marca MZ
fallback alternativo com chat
helpers prontos para integração com mz_core
Licença / observação

Este resource faz parte do ecossistema mz_ e foi pensado para ser pequeno, limpo e fácil de expandir.