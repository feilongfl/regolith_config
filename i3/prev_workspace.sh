#!/usr/bin/env fish

set primary_screen (i3-msg -t get_config | grep 'set $primary_screen' | cut -d ' ' -f 3)
set minWorkspaceNum (i3-msg -t get_workspaces | jq '.[] | select(.output=="'$primary_screen'") | .num' | sort -n | head -n1)
set maxWorkspaceNum (i3-msg -t get_workspaces | jq '.[] | select(.output=="'$primary_screen'") | .num' | sort -n | tail -n1)
set focusWorkspaceNum (i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .num' | sort -n | tail -n1)

echo $minWorkspaceNum $focusWorkspaceNum
if test $minWorkspaceNum -eq $focusWorkspaceNum
    # to end
    i3-msg workspace number $maxWorkspaceNum
else
    set prevWorkspaceNum (expr $focusWorkspaceNum - 1)
    echo focusWorkspaceNum $focusWorkspaceNum
    echo prevWorkspaceNum $prevWorkspaceNum

    i3-msg workspace number $prevWorkspaceNum
end
