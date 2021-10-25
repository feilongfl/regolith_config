#!/usr/bin/env fish

function toWorkspace
    i3-msg workspace number $argv
end

function moveToWorkspace
    i3-msg move container to workspace number $argv
    i3-msg workspace number $argv
end

set primary_screen (i3-msg -t get_config | grep 'set $primary_screen' | cut -d ' ' -f 3)
set minWorkspaceNum (i3-msg -t get_workspaces | jq '.[] | select(.output=="'$primary_screen'") | .num' | sort -n | head -n1)
set maxWorkspaceNum (i3-msg -t get_workspaces | jq '.[] | select(.output=="'$primary_screen'") | .num' | sort -n | tail -n1)
set focusWorkspaceNum (i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .num' | sort -n | tail -n1)

function prev_workspace
    echo $minWorkspaceNum $focusWorkspaceNum
    if test $minWorkspaceNum -eq $focusWorkspaceNum
        # to end
        eval $argv $maxWorkspaceNum
    else
        set prevWorkspaceNum (expr $focusWorkspaceNum - 1)
        echo focusWorkspaceNum $focusWorkspaceNum
        echo prevWorkspaceNum $prevWorkspaceNum

        eval $argv $prevWorkspaceNum
    end
end

function next_workspace
    echo $maxWorkspaceNum $focusWorkspaceNum
    if test $maxWorkspaceNum -eq $focusWorkspaceNum
        set nextWorkspaceNum (expr $maxWorkspaceNum + 1)
        echo maxWorkspaceNum $maxWorkspaceNum
        echo nextWorkspaceNum $nextWorkspaceNum

        if test $nextWorkspaceNum -lt 10
            eval $argv $nextWorkspaceNum
        else
            # back to first
            eval $argv 1
        end
    else
        set nextWorkspaceNum (expr $focusWorkspaceNum + 1)
        echo focusWorkspaceNum $focusWorkspaceNum
        echo nextWorkspaceNum $nextWorkspaceNum

        eval $argv $nextWorkspaceNum
    end
end
