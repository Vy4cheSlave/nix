#!/bin/sh

# Функция для получения ID активного рабочего пространства,
# которая обрабатывает разные форматы вывода niri
get_active_id() {
  niri msg -j workspaces | jq --raw-output '
    if type == "object" then
      .[] | .[] | select(.is_active) | .id
    elif type == "array" then
      .[] | select(.is_active) | .id
    else
      "null"
    end
  '
}
# Выводим начальное состояние
get_active_id

# Подписка на поток событий
niri msg -j event-stream | jq --unbuffered --raw-output '
  select(.WorkspaceActivated or .WindowOpenedOrChanged) |
  (
    .WorkspaceActivated.id // 
    .WindowOpenedOrChanged.window.workspace_id // 
    "null"
  )
'

###########################################################

# # Функция для получения ID активного рабочего пространства
# get_active_id() {
#   niri msg -j workspaces | jq --raw-output '
#     if type == "object" then
#       .[] | .[] | select(.is_active) | .id
#     elif type == "array" then
#       .[] | select(.is_active) | .id
#     else
#       "null"
#     end
#   '
# }

# # Выводим начальное состояние
# get_active_id

# # Подписка на поток событий
# niri msg -j event-stream | jq --unbuffered --raw-output '
#   select(.WorkspaceActivated or .WindowOpenedOrChanged or .WorkspacesChanged)
# ' | while read -r event; do
#   # При получении любого из нужных событий, просто запрашиваем и выводим актуальное состояние
#   get_active_id
# done | uniq
