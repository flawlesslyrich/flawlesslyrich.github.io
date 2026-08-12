
#!/bin/bash
source ./functions.sh # import the functions from functions.sh


# The function that will start the script
main() {

    search_path="./"
    is_case_sensitive="true"

    while true 
    do 
	terminal_cols=$(tput cols) 
	indent_amount=$(((terminal_cols - 43) / 2)) # calculates the indentation needed to horizontally center the menu
	terminal_center=$(tput cuf $indent_amount)

        echo "$terminal_center ========== Text File Search Tool ==========" 
        echo "$terminal_center   1. Search Text"
        echo "$terminal_center   2. Set Search Directory/File"
        echo "$terminal_center   3. Filter by File Type"
        echo "$terminal_center   4. Toggle Case Sensitivity"
        echo "$terminal_center   5. Save Results to File"
        echo "$terminal_center   6. Help"
        echo "$terminal_center   7. Exit"
        echo "$terminal_center ==========================================="

        read -p "Enter your choice: " choice

        case $choice in

            1)
                echo # add a blank line for formatting

                read -p "Enter a word or phrase to search for: " search_phrase

                echo # add a blank line for formatting

                echo "Searching in: $search_path"
                echo "Search term: $search_phrase"
                echo "-----------------------------------"

                result=$(search_text "$search_phrase" "$search_path" "$is_case_sensitive")

                echo "$result"


                echo "-----------------------------------"
            ;;

            2)
                echo

                read -p "Enter directory to search: " search_path

                search_path=$(format_file_path "$search_path")

                path_exists=$(check_path_exists "$search_path")

                if [ "$path_exists" = "true" ]; then 
                    echo "Search directory set to: $search_path"
                else
                    echo "User Error: The path '$search_path' doesn't exist!" >&2
                    exit 1
                fi
            ;;

            3)
                echo

                #TODO: Filter by file type

            ;;

            4)
                echo
                
                read -p "[C]ase-Sensitive or [I]n-Case-Sensitive: " case_sensitivity_choice

                result=$(lowercase_text "$case_sensitivity_choice")

                if [ "$result" = "c" ]; then
                    is_case_sensitive="true"
                    echo "Case-Sensitivity: Sensitive"

                elif [ "$result" = "i" ]; then
                    is_case_sensitive="false"

                    echo "Case-Sensitivity: In-Sensitive"
                else
                    echo "User Error: Expected 'C' or 'I' for Case-Sensitivity but got '$case_sensitivity_choice'" >&2
                    exit 1
                fi
            ;;

            5)
                echo

                # TODO: save results to a file
            ;;

            6)
                echo

                #TODO: display Help details
            ;;

            7)
                echo #

                echo "Exiting program..."
                break
            ;;

            *)
                echo "Invalid option"
            ;;

        esac

        echo
    done
}


main # start the script

