# mz_notify

[![FiveM](https://img.shields.io/badge/FiveM-Resource-f28c28?style=for-the-badge)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Lua-5.4-2c2d72?style=for-the-badge)](https://www.lua.org/)
[![Version](https://img.shields.io/badge/version-1.0.0-1f9d55?style=for-the-badge)](#)
[![NUI](https://img.shields.io/badge/UI-NUI-111827?style=for-the-badge)](#)

> Sistema de notificações NUI para o ecossistema `mz_`, feito para ser leve, direto e fácil de integrar em qualquer servidor FiveM.

## Visão Geral

O `mz_notify` é um resource de notificações com interface NUI, animação de entrada e saída, barra de progresso, suporte a posições diferentes na tela e integração simples por evento ou export.

Ele foi pensado para resolver o básico muito bem:

- visual limpo e responsivo
- integração rápida com outros resources
- baixo acoplamento com o restante do ecossistema
- configuração simples para uso imediato

## Destaques

- 4 tipos nativos de notificação: `success`, `error`, `warning` e `info`
- NUI leve com layout moderno e animações suaves
- envio por evento client-side
- export client-side
- export server-side
- dedupe por `id` para substituir notificações repetidas
- barra de progresso automática para notificações temporárias
- suporte a notificações persistentes
- posição configurável: `top-right`, `top-left`, `bottom-right`, `bottom-left`
- fallback por `print` no client quando habilitado
- limite de notificações visíveis configurável
- comandos prontos para teste no jogo

## Instalação

1. Coloque a pasta `mz_notify` dentro da sua pasta de resources.
2. Adicione o resource no `server.cfg`:

```cfg
ensure mz_notify
```

3. Reinicie o servidor ou rode:

```cfg
refresh
ensure mz_notify
```

## Uso Rápido

### Server -> Client com evento

```lua
TriggerClientEvent('mz_notify:client:show', source, {
    type = 'success',
    title = 'Garagem',
    message = 'Veículo guardado com sucesso.',
    duration = 5000
})
```

### Server export

```lua
exports['mz_notify']:Notify(source, {
    type = 'warning',
    title = 'Atenção',
    message = 'Seu veículo está com o motor danificado.',
    duration = 5000
})
```

### Client export

```lua
exports['mz_notify']:Notify({
    type = 'info',
    title = 'Sistema',
    message = 'Notificação enviada pelo client.',
    duration = 5000
})
```

### Evento server-side para o próprio jogador

```lua
TriggerServerEvent('mz_notify:server:notify', {
    type = 'error',
    title = 'Inventário',
    message = 'Você não tem espaço suficiente.',
    duration = 5000
})
```

## Payload Suportado

Use esta estrutura para enviar notificações:

```lua
{
    type = 'success',
    title = 'Título',
    message = 'Mensagem da notificação',
    duration = 5000,
    id = 'unique_id',
    persistent = false,
    position = 'top-right',
    icon = 'check'
}
```

### Campos

| Campo        | Tipo      | Descrição                                                  |
| ------------ | --------- | ---------------------------------------------------------- |
| `type`       | `string`  | Tipo da notificação: `success`, `error`, `warning`, `info` |
| `title`      | `string`  | Título exibido no card                                     |
| `message`    | `string`  | Conteúdo principal da notificação                          |
| `duration`   | `number`  | Duração em ms. Valores abaixo de `1000` caem no padrão     |
| `id`         | `string`  | Identificador único para substituir notificações iguais    |
| `persistent` | `boolean` | Se `true`, não remove automaticamente                      |
| `position`   | `string`  | `top-right`, `top-left`, `bottom-right`, `bottom-left`     |
| `icon`       | `string`  | Campo aceito no payload para uso/customização futura       |

## Comportamento Padrão

As configurações atuais do resource são:

```lua
Config.Debug = false
Config.DefaultDuration = 5000
Config.DefaultPosition = 'top-right'
Config.MaxVisible = 4
Config.EnableFallbackPrint = true
```

Na prática, isso significa:

- duração padrão de `5000ms`
- posição padrão em `top-right`
- até `4` notificações visíveis por container
- fallback no client via `print` quando habilitado
- tipos inválidos viram `info`

## Comandos de Teste

### Comandos server-side

```text
/mnotifytest success
/mnotifytest error
/mnotifytest warning
/mnotifytest info
```

```text
/mnotify success Inventário|Item recebido com sucesso|5000
/mnotify error Sistema|Algo deu errado|5000
/mnotify warning Atenção|Você está sem permissão|5000
/mnotify info MZ Core|Teste visual da notify|5000
```

### Comando local no client

```text
/mnotifylocal success
/mnotifylocal error
/mnotifylocal warning
/mnotifylocal info
```

## Permissões ACE

Se quiser restringir os comandos de teste para um grupo específico, você pode usar um padrão como este:

```cfg
add_ace group.mz_owner command allow
add_ace group.mz_owner command.quit deny

add_principal identifier.fivem:SEU_ID_FIVEM_AQUI group.mz_owner
add_principal identifier.fivem:ID_DO_SOCIO_AQUI group.mz_owner
```

## Estrutura do Projeto

```text
mz_notify/
|-- fxmanifest.lua
|-- README.md
|-- shared/
|   `-- config.lua
|-- server/
|   `-- main.lua
|-- client/
|   `-- main.lua
`-- web/
    |-- index.html
    |-- style.css
    `-- app.js
```

## Escopo da V1

O objetivo da primeira versão é ser um sistema de notificação:

- simples de integrar
- reutilizável entre resources
- visualmente consistente
- desacoplado de frameworks pesados
- fácil de expandir no futuro

Fora do escopo da V1:

- histórico persistente
- central de notificações
- múltiplos temas visuais
- ações clicáveis
- integração com banco de dados
- animações complexas
- sistema avançado de sons

## Roadmap

Ideias naturais para próximas versões:

- ícones SVG mais refinados
- som opcional por tipo
- botão de fechar para notificações persistentes
- identidade visual ainda mais alinhada com a marca `mz_`
- fallback alternativo via chat
- helpers prontos para integração com `mz_core`

## Observações

- notificações com o mesmo `id` substituem a anterior no mesmo container
- a NUI respeita limite de itens visíveis por posição
- notificações persistentes não exibem remoção automática por tempo
- o resource foi desenhado para permanecer pequeno, limpo e fácil de manter
