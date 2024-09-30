#!/bin/bash

# =================================================
# DOOM Launcher
# by whipowill
# =================================================

echo ""
echo "██████╗░░█████╗░░█████╗░███╗░░░███╗"
echo "██╔══██╗██╔══██╗██╔══██╗████╗░████║"
echo "██║░░██║██║░░██║██║░░██║██╔████╔██║"
echo "██║░░██║██║░░██║██║░░██║██║╚██╔╝██║"
echo "██████╔╝╚█████╔╝╚█████╔╝██║░╚═╝░██║"
echo "╚═════╝░░╚════╝░░╚════╝░╚═╝░░░░░╚═╝"
echo ""

# Change to directory of this script
cd "$(dirname "$0")"

# File to save the last command
last_command_file="last_command.txt"

# Check if there's a saved command and ask if the user wants to use it
if [ -f "$last_command_file" ]; then
    last_command=$(<"$last_command_file")
    echo "LAST COMMAND:"
    echo "--------------"
    echo "$last_command"
    echo ""
    read -p "Do you want to reuse this command? (y/n): " use_last_command
    if [ "$use_last_command" = "y" ]; then
        eval "$last_command"
        exit 0
    fi
fi

# Helper function
list_files() {
    local dir="$1"
    local -n array=$2
    local i=1
    array=()
    while IFS= read -r -d $'\0' file; do
        echo "$i) $(basename "$file")"
        array+=("$file")
        ((i++))
    done < <(find "$dir" -maxdepth 1 -type f \( -iname "*.wad" -o -iname "*.WAD" -o -iname "*.pk3" -o -iname "*.PK3" \) -print0 | sort -z)
}

# Initialize command variable
command="gzdoom"

# Ask if the user wants to play a network game
read -p "Do you want to play a network game? (y/n): " network_choice

if [ "$network_choice" = "y" ]; then
    echo ""
    echo "NETWORKING:"
    echo "------------"
    read -p "Are you hosting or joining? (h/j): " host_join

    if [ "$host_join" = "h" ]; then
        read -p "Enter the number of players: " player_num
        read -p "Enter the episode number: " episode_num
        read -p "Enter the mission number: " mission_num
        read -p "Enter the skill level (1-5): " skill_num

        echo ""

        # Prepare command for hosting
        command+=" -host $player_num -warp $episode_num $mission_num -skill $skill_num"

    elif [ "$host_join" = "j" ]; then
        read -p "Enter the IP address to join: " ip_address

        echo ""

        # Prepare command for joining
        command+=" -join $ip_address"

    else
        echo "Invalid option. Exiting."
        exit 1
    fi
fi

if [ "$network_choice" != "y" ] || [ "$host_join" != "j" ]; then
    # Scan IWADs directory
    echo "BASE GAME:"
    echo "-----------"
    list_files "IWADs" iwads

    # Get user input for IWAD selection
    read -p "Select an IWAD (enter number): " iwad_choice

    # Validate IWAD selection
    if [[ "$iwad_choice" =~ ^[0-9]+$ ]] && [ "$iwad_choice" -gt 0 ] && [ "$iwad_choice" -le "${#iwads[@]}" ]; then
        selected_iwad="${iwads[iwad_choice-1]}"

        echo ""

        # Scan PWADs directory for the selected IWAD
        pwad_dir="PWADs/$(basename "${selected_iwad%.*}")"
        echo "CUSTOM CAMPAIGN:"
        echo "-----------------"
        list_files "$pwad_dir" pwads

        # Get user input for PWAD selection
        read -p "Select a PWAD (enter number): " pwad_choice

        # Validate PWAD selection
        if [[ "$pwad_choice" =~ ^[0-9]+$ ]] && [ "$pwad_choice" -gt 0 ] && [ "$pwad_choice" -le "${#pwads[@]}" ]; then
            selected_pwad="${pwads[pwad_choice-1]}"
        else
            selected_pwad=""
            echo "No valid PWAD selected."
        fi

        echo ""

        # Scan MODs directory for available mods
        echo "MODIFICATIONS:"
        echo "---------------"
        list_files "MODs" mods

        # Get user input for MOD selection (multiple selections allowed)
        read -p "Select MODs (enter numbers separated by spaces, order matters): " -a mod_choices

        selected_mods=()

        for choice in "${mod_choices[@]}"; do
            if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -gt 0 ] && [ "$choice" -le "${#mods[@]}" ]; then
                selected_mods+=("${mods[choice-1]}")
            fi
        done

        echo ""

        # Init the command with IWAD only if selected_iwad is set.
        command+=" -iwad \"$selected_iwad\""

        # If a PWAD or a mod...
        if [ -n "$selected_pwad" ] || [ ${#selected_mods[@]} -gt 0 ]; then
            command+=" -file"

            # Add the selected PWAD if valid.
            if [ -n "$selected_pwad" ]; then
                command+=" \"$selected_pwad\""
            fi

            # Add the selected mods.
            for mod in "${selected_mods[@]}"; do
                command+=" \"$mod\""
            done
        fi
    else
        echo "No valid IWAD selected. Exiting."
        exit 1
    fi
fi

# Print final command.
echo "COMMAND:"
echo "---------"
echo "$command"

# Save the last command to a file.
echo "$command" > "$last_command_file"

# Option to execute the command.
read -p "Do you want to run this command? (y/n): " run_choice
if [ "$run_choice" = "y" ]; then
    eval "$command"
fi
