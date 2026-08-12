
#!/bin/bash
source ./functions.sh # import the functions from functions.sh


# The function that will start the script
main() {

    search_path="./"
    is_case_sensitive="true"

    while true 
    do 
        echo "========== Text File Search Tool ==========" 
        echo "1. Search Text"
        echo "2. Set Search Directory/File"
        echo "3. Filter by File Type"
        echo "4. Toggle Case Sensitivity"
        echo "5. Save Results to File"
        echo "6. Help"
        echo "7. Exit"
        echo "==========================================="

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

