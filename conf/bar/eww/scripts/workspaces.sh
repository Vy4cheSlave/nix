#!/bin/sh

# niri msg -j workspaces | jq -c '[.[] | {idx, is_active, active_window_id}] | sort_by(.idx)'

# # Функция для получения текущих рабочих столов
# get_workspaces() {
#     niri msg -j workspaces | jq -c 'sort_by(.idx)'
# }

# # Вывод начального состояния
# get_workspaces

# # Отслеживание событий
# niri msg -j event-stream | jq --unbuffered -c '
#     # Если пришло событие WorkspacesChanged, выводим обновленный список
#     if .WorkspacesChanged then
#         .WorkspacesChanged.workspaces | [.[] | {id, idx, is_active, is_focused, active_window_id}] | sort_by(.idx)
#     # Если пришло событие WorkspaceActivated, обновляем состояние
#     elif .WorkspaceActivated then
#         # Здесь мы не можем просто обновить один элемент,
#         # поэтому придется перечитать все рабочие столы.
#         # Это не идеально, но работает с одним потоком.
#         "" | empty # Просто ничего не выводим
#     else
#         empty
#     end
# '

# Запрос начального состояния
niri msg -j workspaces | jq --compact-output '[.[] | {id, idx, is_active, is_focused, active_window_id}] | sort_by(.idx)'

# Подписка на поток событий
niri msg -j event-stream | jq --unbuffered --compact-output '
  select(.WorkspacesChanged) |
  .WorkspacesChanged.workspaces |
  [.[] | {id, idx, is_active, is_focused, active_window_id}] |
  sort_by(.idx)
'