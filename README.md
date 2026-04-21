# mz_notify

[![FiveM](https://img.shields.io/badge/FiveM-Resource-blue)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Language-Lua-yellow)](https://www.lua.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

Sistema de notificações NUI para o ecossistema `mz_`. Uma solução leve e elegante para exibir notificações no seu servidor FiveM.

## 📋 Descrição

O `mz_notify` é um sistema de notificações baseado em NUI (Native UI) para FiveM, projetado para ser simples, leve e altamente configurável. Permite exibir notificações de diferentes tipos com suporte a ícones, barras de progresso e posicionamento personalizado.

## ✨ Recursos

- **4 tipos de notificação**: `success`, `error`, `warning`, `info`
- **Interface NUI leve e responsiva**
- **Uso via evento client-side**
- **Uso via export client-side**
- **Comandos de teste integrados**
- **Posição configurável** (top-left, top-right, bottom-left, bottom-right)
- **Barra de progresso opcional**
- **Dedupe por ID** para evitar notificações duplicadas
- **Suporte a ícones personalizados**

## 🚀 Instalação

1. Baixe o resource `mz_notify`.
2. Adicione a pasta `mz_notify` na sua pasta de resources do servidor.
3. Adicione a linha abaixo no seu `server.cfg`:

```cfg
ensure mz_notify
```

4. Reinicie o servidor ou execute `refresh` e `ensure mz_notify` no console.

## 📖 Uso

### Via Evento (Server-Side)

```lua
TriggerClientEvent('mz_notify:client:show', source, {
    type = 'success',
    title = 'Inventário',
    message = 'Item adicionado com sucesso.',
    duration = 5000
})
```

### Via Export (Client-Side)

```lua
exports['mz_notify']:Notify({
    type = 'info',
    title = 'Sistema',
    message = 'Olá mundo.',
    duration = 5000
})
```

## ⚙️ Configuração

O payload completo suportado é:

```lua
{
    type = 'success',        -- success | error | warning | info
    title = 'Título',        -- Título da notificação
    message = 'Mensagem',    -- Mensagem da notificação
    duration = 5000,         -- Duração em milissegundos (opcional, padrão: 5000)
    id = 'unique_id',        -- ID único para dedupe (opcional)
    persistent = false,      -- Se a notificação é persistente (opcional)
    position = 'top-right',  -- Posição: top-left | top-right | bottom-left | bottom-right
    icon = 'check'           -- Ícone personalizado (opcional)
}
```

### Tipos Disponíveis

- `success` - Verde, para ações bem-sucedidas
- `error` - Vermelho, para erros
- `warning` - Amarelo, para avisos
- `info` - Azul, para informações gerais

## 🛠️ Comandos de Teste

Use os comandos abaixo no chat do jogo para testar as notificações:

- `/notify success` - Testa notificação de sucesso
- `/notify error` - Testa notificação de erro
- `/notify warning` - Testa notificação de aviso
- `/notify info` - Testa notificação de informação

## 📁 Estrutura do Projeto

```
mz_notify/
├── fxmanifest.lua      # Manifesto do resource
├── client/
│   └── main.lua        # Lógica client-side
├── server/
│   └── main.lua        # Lógica server-side
├── shared/
│   └── config.lua      # Configurações compartilhadas
└── web/
    ├── index.html      # Interface NUI
    ├── style.css       # Estilos CSS
    └── app.js          # Lógica JavaScript
```

## 📝 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests no repositório.

---

Feito com ❤️ para a comunidade FiveM.
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
│ └─ config.lua
├─ server/
│ └─ main.lua
├─ client/
│ └─ main.lua
└─ web/
├─ index.html
├─ style.css
└─ app.js
Objetivo da v1

A proposta da v1 do mz*notify é ser um sistema simples, reutilizável e padronizado para o ecossistema mz*, sem depender de frameworks pesados de frontend e sem acoplar a lógica ao mz_core.

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

Este resource faz parte do ecossistema mz\_ e foi pensado para ser pequeno, limpo e fácil de expandir.
