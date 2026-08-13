#!/bin/bash

# ==========================================
# Text File Search Tool
# Group 1
# ==========================================

# Default settings
search_path="."
file_filter="*"
case_sensitive=true
last_results="search_results.txt"


# ==========================================
# Function: Display Menu
# ==========================================
display_menu()
{
    clear
    
    terminal_cols=$(tput cols) 
    indent_amount=$(((terminal_cols - 43) / 2)) # calculates the indentation needed to horizontally center the menu 
    terminal_center=$(tput cuf $indent_amount)

    echo "$terminal_center ========== Text File Search Tool =========="
    echo "$terminal_center 1. Search Text"
    echo "$terminal_center 2. Set Search Directory/File"
    echo "$terminal_center 3. Filter by File Type"
    echo "$terminal_center 4. Toggle Case Sensitivity"
    echo "$terminal_center 5. Save Results to File"
    echo "$terminal_center 6. View Previous Search Results"
    echo "$terminal_center 7. Help"
    echo "$terminal_center 8. Exit"
    echo "$terminal_center ==========================================="
}


# ==========================================
# Function: Search Text
# Mohammadali's Part
# ==========================================
search_text()
{
    echo
    read -p "Enter the word or phrase to search for: " search_term

    # Input validation
    if [ -z "$search_term" ]; then
        echo "Error: Search text cannot be empty."
        read -p "Press Enter to continue..."
        return
    fi

    # Check search location
    if [ ! -e "$search_path" ]; then
        echo "Error: The specified file or directory does not exist."
        read -p "Press Enter to continue..."
        return
    fi

    echo
    echo "Searching..."
    echo

    # Create temporary result file
    > "$last_results"

    # Case-sensitive search
    if [ "$case_sensitive" = true ]; then

        if [ "$file_filter" = "*" ]; then
            grep -rn --color=always -- "$search_term" "$search_path" 2>/dev/null \
                | tee "$last_results"
        else
            find "$search_path" -type f -name "$file_filter" -exec \
                grep -nH --color=always -- "$search_term" {} + 2>/dev/null \
                | tee "$last_results"
        fi

    # Case-insensitive search
    else

        if [ "$file_filter" = "*" ]; then
            grep -rni --color=always -- "$search_term" "$search_path" 2>/dev/null \
                | tee "$last_results"
        else
            find "$search_path" -type f -name "$file_filter" -exec \
                grep -niH --color=always -- "$search_term" {} + 2>/dev/null \
                | tee "$last_results"
        fi
    fi

    # Check whether results were found
    if [ ! -s "$last_results" ]; then
        echo
        echo "No matching results found."
    else
        echo
        echo "Search completed."
        echo "Results saved temporarily in $last_results"
    fi

    read -p "Press Enter to continue..."
}


# ==========================================
# Function: Set Search Directory/File
# Mohammadali's Part
# ==========================================
set_search_path()
{
    echo
    echo "Current search location: $search_path"
    echo

    read -p "Enter a file or directory to search: " new_path

    if [ -z "$new_path" ]; then
        echo "Error: You must enter a path."
    elif [ ! -e "$new_path" ]; then
        echo "Error: File or directory does not exist."
    else
        search_path="$new_path"
        echo "Search location successfully changed to:"
        echo "$search_path"
    fi

    read -p "Press Enter to continue..."
}


# ==========================================
# Function: Filter by File Type
# Kingsley's Part
# ==========================================
filter_file_type()
{
    echo
    echo "========== File Type Filter =========="
    echo "1. All Files"
    echo "2. Text Files (.txt)"
    echo "3. Log Files (.log)"
    echo "4. Shell Scripts (.sh)"
    echo "5. Custom File Type"
    echo "======================================"

    read -p "Enter your choice: " filter_choice

    case "$filter_choice" in

        1)
            file_filter="*"
            echo "File type filter: All files"
            ;;

        2)
            file_filter="*.txt"
            echo "File type filter: .txt"
            ;;

        3)
            file_filter="*.log"
            echo "File type filter: .log"
            ;;

        4)
            file_filter="*.sh"
            echo "File type filter: .sh"
            ;;

        5)
            read -p "Enter the file extension (example: csv): " extension

            if [ -z "$extension" ]; then
                echo "Error: File extension cannot be empty."
            else
                # Add *. automatically
                extension="${extension#.}"
                file_filter="*.$extension"
                echo "File type filter: $file_filter"
            fi
            ;;

        *)
            echo "Invalid choice. Returning to main menu."
            ;;
    esac

    read -p "Press Enter to continue..."
}


# ==========================================
# Function: Toggle Case Sensitivity
# Mohammadali's Part
# ==========================================
toggle_case()
{
    if [ "$case_sensitive" = true ]; then
        case_sensitive=false
        echo
        echo "Case sensitivity is now OFF."
        echo "Searches will be case-insensitive."
    else
        case_sensitive=true
        echo
        echo "Case sensitivity is now ON."
        echo "Searches will be case-sensitive."
    fi

    read -p "Press Enter to continue..."
}


# ==========================================
# Function: Save Results
# Kingsley's Part
# ==========================================
save_results()
{
    echo

    if [ ! -s "$last_results" ]; then
        echo "There are no search results to save."
        echo "Run a search first."
        read -p "Press Enter to continue..."
        return
    fi

    read -p "Enter the output filename: " output_file

    # Validate filename
    if [ -z "$output_file" ]; then
        echo "Error: Filename cannot be empty."
        read -p "Press Enter to continue..."
        return
    fi

    # Prevent accidental directory input
    if [ -d "$output_file" ]; then
        echo "Error: That is a directory, not a filename."
        read -p "Press Enter to continue..."
        return
    fi

    cp "$last_results" "$output_file"

    if [ $? -eq 0 ]; then
        echo
        echo "Results successfully saved to:"
        echo "$output_file"
    else
        echo
        echo "Error: Unable to save results."
    fi

    read -p "Press Enter to continue..."
}


# ==========================================
# Function: View Previous Search Results
# Kingsley's Part
# ==========================================
view_previous_results()
{
    echo
    echo "========== Previous Search Results =========="

    if [ ! -s "$last_results" ]; then
        echo "No previous search results are available."
    else
        cat "$last_results"
    fi

    echo "============================================="
    read -p "Press Enter to continue..."
}


# ==========================================
# Function: Help
# Kingsley's Part
# ==========================================
show_help()
{
    clear

    echo "=========================================="
    echo "       TEXT FILE SEARCH TOOL - HELP"
    echo "=========================================="
    echo
    echo "1. Search Text"
    echo "   Searches for a word or phrase inside"
    echo "   the selected file or directory."
    echo
    echo "2. Set Search Directory/File"
    echo "   Select the location where the search"
    echo "   will be performed."
    echo
    echo "3. Filter by File Type"
    echo "   Limit searches to file types such as:"
    echo "   .txt, .log, or .sh."
    echo
    echo "4. Toggle Case Sensitivity"
    echo "   Switch between case-sensitive and"
    echo "   case-insensitive searches."
    echo
    echo "5. Save Results to File"
    echo "   Save the results of the most recent"
    echo "   search into a text file."
    echo
    echo "6. View Previous Search Results"
    echo "   Display the results from the last search."
    echo
    echo "7. Help"
    echo "   Display this program manual."
    echo
    echo "8. Exit"
    echo "   Close the Text File Search Tool."
    echo
    echo "=========================================="

    read -p "Press Enter to return to the menu..."
}


# ==========================================
# Main Program
# ==========================================

while true
do
    display_menu

    echo
    read -p "Enter your choice: " choice

    case "$choice" in

        1)
            search_text
            ;;

        2)
            set_search_path
            ;;

        3)
            filter_file_type
            ;;

        4)
            toggle_case
            ;;

        5)
            save_results
            ;;

        6)
            view_previous_results
            ;;

        7)
            show_help
            ;;

        8)
            echo
            echo "Exiting Text File Search Tool..."
            exit 0
            ;;

        *)
            echo
            echo "Invalid choice."
            echo "Please enter a number from 1 to 8."
            read -p "Press Enter to continue..."
            ;;
    esac
done
