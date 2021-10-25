#!/usr/bin/env fish

set primary_screen (i3-msg -t get_config | grep 'set $primary_screen' | cut -d ' ' -f 3)
set maxWorkspaceNum (i3-msg -t get_workspaces | jq '.[] | select(.output=="'$primary_screen'") | .num' | sort -n | tail -n1)
set focusWorkspaceNum (i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .num' | sort -n | tail -n1)

echo $maxWorkspaceNum $focusWorkspaceNum
if test $maxWorkspaceNum -eq $focusWorkspaceNum
    set nextWorkspaceNum (expr $maxWorkspaceNum + 1)
    echo maxWorkspaceNum $maxWorkspaceNum
    echo nextWorkspaceNum $nextWorkspaceNum

    if test $nextWorkspaceNum -lt 10
        i3-msg workspace number $nextWorkspaceNum
    else
        # back to first
        i3-msg workspace number 1
    end
else
    set nextWorkspaceNum (expr $focusWorkspaceNum + 1)
    echo focusWorkspaceNum $focusWorkspaceNum
    echo nextWorkspaceNum $nextWorkspaceNum

    i3-msg workspace number $nextWorkspaceNum
end
