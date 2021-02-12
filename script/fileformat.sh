#!/bin/bash

formatNameFileFolder(){
    OLDNAME=($(echo "$1" | fold -w1))
    NEWNAME=("${OLDNAME[@]}")
    K=0

    #----------------------Creating the new name-----------------------------#
    for char in ${OLDNAME[*]}
    do
        if [[ "$char" =~ [A-Z] ]] #detect uppercase character
        then
            NEWNAME[K]=$(echo "${char,}")
        fi

        if [[ "$char" =~ \ |\' ]] #detect space character
        then 
            NEWNAME[K]=$(echo "_") #ramplace with "_"
        fi
        K=$(($K + 1)) #increment K
    done
    NEWNAMESTR=$(IFS=$'\n'; echo "${NEWNAME[@]}") #transform array to string
    NEWNAMESTR=$(echo "${NEWNAMESTR//[[:blank:]]/}") #remove space
    #-------------------------------------------------------------------------#

    #----------------------actually change the name of the file---------------#
    OLDNAMESTR=$(IFS=$'\n'; echo "${OLDNAME[@]// /|}") #transform array to string
    OLDNAMESTR=$(echo "${OLDNAMESTR//[[:blank:]]/}") #remove useless generated space
    OLDNAMESTR=$(echo "$OLDNAMESTR" | tr "|" " ") #add original space
    echo "$OLDNAMESTR old name"
    echo "$NEWNAMESTR new name"

    mv "$OLDNAMESTR" "$NEWNAMESTR"

    #-------------------------------------------------------------------------#

}

formatNameUniFile(){


    COMPLETNAME=("$1")
    BASENAME=($(echo $(basename "$COMPLETNAME")))
    echo "$BASENAME base name"
    OLDNAME=($(echo "${BASENAME[*]}" | fold -w1))
    echo "${OLDNAME[@]} old name"
    NEWNAME=("${OLDNAME[@]}")
    K=0
    #----------------------Looking for the name-----------------------------#
    #echo "${COMPLETNAME[*]} complet name"
    #echo "${OLDNAME[*]} old name"

    #-------------------------------------------------------------------------#
    #----------------------Creating the new name-----------------------------#
    for char in ${OLDNAME[*]}
    do
        if [[ "$char" =~ [A-Z] ]] #detect uppercase character
        then
            NEWNAME[K]=$(echo "${char,}")
        fi

        if [[ "$char" =~ \ |\' ]] #detect space character
        then 
            NEWNAME[K]=$(echo "_") #ramplace with "_"
        fi
        K=$(($K + 1)) #increment K
    done
    NEWNAMESTR=$(IFS=$'\n'; echo "${NEWNAME[@]}") #transform array to string
    NEWNAMESTR=$(echo "${NEWNAMESTR//[[:blank:]]/}") #remove space
    #-------------------------------------------------------------------------#

    #----------------------actually change the name of the file---------------#
    OLDNAMESTR=$(IFS=$'\n'; echo "${OLDNAME[@]// /|}") #transform array to string
    OLDNAMESTR=$(echo "${OLDNAMESTR//[[:blank:]]/}") #remove useless generated space
    OLDNAMESTR=$(echo "$OLDNAMESTR" | tr "|" " ") #add original space
    echo "$OLDNAMESTR old name"
    echo "$NEWNAMESTR new name"

    #mv "$COMPLETNAME" "$NEWNAMESTR"

    #-------------------------------------------------------------------------#

}

#---------------------------------Interface Block/Main program------------------------------------------#
zenity --info --width=250 --height=150 --text "This script is intended to rename with a generic format all files in a directory of your choise "

ask=`zenity --list --title="Choose Operation type" --column="0" "Unique file" "List of files" "Whole folder" --width=250 --height=150 --hide-header`

if [ "$ask" == "Unique file" ]; then
    INBUILD=($(echo "1"))
    if [ "$INBUILD" == "1" ]; then
        zenity --info --width=250 --height=150 --text "This function is under devellopement"
    else
        FILE=`zenity --file-selection --title="Select a File"`
        case $? in
                    0)
                        echo ""$FILE" selected.";;
                    1)
                        echo "No file selected.";;
                    -1)
                        echo "No file selected.";;
        esac

        formatNameUniFile "${FILE[*]}"
    fi

fi

if [ "$ask" == "List of files" ]; then
    INBUILD=($(echo "1"))
    if [ "$INBUILD" == "1" ]; then
        zenity --info --width=250 --height=150 --text "This function is under devellopement"
    else
        FILES=`zenity --file-selection --multiple --title="Select Files"`
        case $? in
                    0)
                        echo ""$FILES" selected.";;
                    1)
                        echo "No file selected.";;
                    -1)
                        echo "No file selected.";;
        esac
    fi
fi

if [ "$ask" == "Whole Folder" ]; then
    FOLDER=`zenity --file-selection --directory --title="Select a Folder"` #Selection of the folder

    case $? in
                    0)
                            echo "folder "$FOLDER" selected.";;
                    1)
                            echo "No folder selected."
                            exit;;
                    -1)
                            echo "No folder selected."
                            exit;;
            esac

    cd "$FOLDER"
    NB_FILES=$(find . -type f -name \* | wc -l)
    echo "nombrer of files "$NB_FILES""

    echo "list of file :"
    IFS='
    '
    LIST=( $(ls) )

    for nfile in ${LIST[*]}
    do
        echo "$nfile"
    done

    zenity --question --title="FILE FORMAT SCRIPT" --text "Are you sure you want to lauch this 
    script ? \nThe operation can't be undo" --width=250 --height=150

    case $? in
                    0)
                            echo "continue";;
                    1)
                            echo "operation canceled"
                            exit 1;;
                    -1)     
                            echo "operation canceled"
                            exit -1;;
            esac


    for nfile in ${LIST[*]}
    do
        formatNameFileFolder $nfile
    done

fi
#-------------------------------------------------------------------------------------#
echo "program done"
exit 0