set -g status-justify "left"
set -g status 2
set -g status-left-style "none"
set -g message-command-style "fg=colour231,bg=colour31"
set -g status-right-style "none"
set -g pane-active-border-style "fg=colour254"
set -g status-style "none,bg=colour234"
set -g message-style "fg=colour231,bg=colour31"
set -g pane-border-style "fg=colour240"
set -g status-right-length "100"
set -g status-left-length "100"
setw -g window-status-activity-style "none"
setw -g window-status-separator ""
setw -g window-status-style "none,fg=colour250,bg=colour234"
set -g status-left "#[fg=colour16,bg=colour254,bold] #S #[fg=colour254,bg=colour234,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=colour236,bg=colour234,nobold,nounderscore,noitalics]#[fg=colour247,bg=colour236] %Y-%m-%d  %H:%M #[fg=colour252,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour235,bg=colour252] #h "
setw -g window-status-format "#[fg=colour244,bg=colour234] #I #[fg=colour250,bg=colour234] #W "
setw -g window-status-current-format "#[fg=colour234,bg=colour31,nobold,nounderscore,noitalics]#[fg=colour117,bg=colour31] #I #[fg=colour231,bg=colour31,bold] #W #[fg=colour31,bg=colour234,nobold,nounderscore,noitalics]"

# Top status bar (row 0) - Sessions
set -g status-format[0] "#[align=right]#{S:#[range=session|#{session_id}]#{?#{==:#{session_name},#{client_session}},#[fg=colour248]#[bg=colour234]#[nobold]#[nounderscore]#[noitalics]#[fg=colour235]#[bg=colour248]#[bold] #{session_name} #[fg=colour234]#[bg=colour248]#[bg=colour234]#[nobold]#[nounderscore]#[noitalics],#[fg=colour250]#[bg=colour234] #{session_name} }#[norange]}#[fg=colour236]#[bg=colour234]#[nobold]#[nounderscore]#[noitalics]#[fg=colour247]#[bg=colour236]  "

# Bottom status bar (row 1) - Windows with full mouse click support
set -g status-format[1] "#[align=left range=left #{E:status-left-style}]#[push-default]#{T;=/#{status-left-length}:status-left}#[pop-default]#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{E:window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{E:window-status-current-style},default},#{E:window-status-current-style},#{E:window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}#[nolist align=right range=right #{E:status-right-style}]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]"
