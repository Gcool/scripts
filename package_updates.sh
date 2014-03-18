#!/bin/sh

# Version 1.1.b2
#########################################################################################################################
### configuration setting

# # of packages in output list
list_len=8

# Conky parse code for "system is up to date" line
conky_parse_siutd=

# Conky parse code inserted before every package name
conky_parse_pkg=

# Conky parse code inserted before every package size
conky_parse_size='${goto 160}'

# Show a summary line at the end 'true' or anything
show_summary='true'

# Show remove package summary line at end. Set to 'true' or anything
show_remove_summary='true'

# # of packages in remove list, set to 0 to disable the list
rlist_len=2
# Notice that 'show_remove_summary' MUST be set to 'true' if you want to show a list of those packages

# Conky parse code inserted before summary line
conky_parse_summary=

### End of configuration
#########################################################################################################################

declare -a pkg size
IFS=`echo -en "\n\b"`

    if [ "$show_remove_summary" = 'true' ]; then
    for i in $(pacman -Qu | sed -n '/Remove/,/Total Re/p' | sed 's/\t/\n/; s/: /\n/; s/  /\n/g' | sed 's/^ //; /^$/d' | grep ']' | sed 's/ /!/' | cut -d '!' -f1 ); 
       do rpkg=( "${rpkg[@]}" "$i" )
    done

    for i in $(pacman -Qu | sed -n '/Remove/,/Total Re/p' | sed 's/\t/\n/; s/: /\n/; s/  /\n/g' | sed 's/^ //; /^$/d' | grep ']' | sed 's/ /!/' | cut -d '!' -f2 ); 
       do rsize=( "${rsize[@]}" "$i" )
    done
fi

    for i in $(pacman -Qu | sed 's/\t/\n/; s/: /\n/; s/  /\n/g' | sed -n '/Targets /,$p' | sed 's/^ //; /^$/d' | grep ']' | sed 's/ /!/' | cut -d '!' -f1 ); 
       do pkg=( "${pkg[@]}" "$i" )
    done

    for i in $(pacman -Qu | sed 's/\t/\n/; s/: /\n/; s/  /\n/g' | sed -n '/Targets /,$p' | sed 's/^ //; /^$/d' | grep ']' | sed 's/ /!/' | cut -d '!' -f2 ); 
       do size=( "${size[@]}" "$i" )
    done

IFS=$ORIGIFS
curr=0

if [ "$list_len" -gt "${#pkg[@]}" ]; then list_len=${#pkg[@]}; fi
if [ "$rlist_len" -gt "${#rpkg[@]}" ]; then rlist_len=${#rpkg[@]}; fi


if [ "${#pkg[@]}" = "0" ]; then echo $conky_parse_siutd "System is up to date"; exit 0; fi

while [ $curr != $list_len ]
do
    echo $conky_parse_pkg ${pkg[$curr]} $conky_parse_size ${size[$curr]}
    let "curr += 1"
done

if [ "$show_summary" = "true" ]; then echo $conky_parse_summary "${#pkg[@]} Packages to update"; fi

if [ $show_remove_summary = 'true' ]; then
    if [ "${#rpkg[@]}" -gt "0" ]; then
        echo $conky_parse_siutd "${#rpkg[@]} Packages will be removed"; 
    fi
fi

if [ "$rlist_len" -gt "0" ]; then
    if [ "${#rpkg[@]}" -gt "0" ]; then
            curr=0
            while [ $curr != $rlist_len ]
            do
                echo $conky_parse_pkg ${rpkg[$curr]} $conky_parse_size ${rsize[$curr]}
                let "curr += 1"
            done
    fi
fi
