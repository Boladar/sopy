
h_flag=false
s_flag=false
i_flag=false
files=''
delimiter=';'

while getopts 'hd:f:s:i' flag; do
    case "${flag}" in
    h) h_flag=true;;
    d)  delimiter=$OPTARG;;
    f) files+=("$OPTARG");;
    s) s_flag=true
        s_mode=$OPTARG;;
    i) i_flag=true;;
    esac
done

if [ "$h_flag" = true ]; then

    echo "Usage: fiszki [FLAGS]"
    echo "FLAGS: "
    echo "-h            Show help"
    echo "-d            Set custom delimiter for files(default is ';')"
    echo "-f            Give a file to script, if you want to use multiple files call multiple -f flags"
    echo "-s            Set this flag if you want to hear the words 
                        s flag has two modes:
                        0 - speak and write to screen,
                        1 - where you only hear the word,
                        You can choose either by passing a parameter to -s"
    echo "-i            Inverse the direction of flash cards, by default default - [native;foreign]"

    exit 0
fi

total_number=0
correct=0

for filename in ${files[@]}
do
    #echo $filename
    while read line; do
        #reading each line
        total_number=$((total_number + 1))

        native=$(echo $line | cut -d $delimiter -f1)
        foreign=$(echo $line | cut -d $delimiter -f2)
        
        if [ "$i_flag" = true ];then
            temp=$native
            native=$foreign
            foreign=$temp
        fi

        # generalnie to to załatwia mówienie tekstu ale 
        # nie chce mi się specjalnie instalować linuxa  
        # bo na subsystemie do win10 nie chce działać.

        if [ "$s_flag" = true ]; then
            espeak $native

                if [ "$s_mode" = 0 ]; then
                    echo $native
                fi

            else
                echo $native
        fi
        read -p "Word in foreign language: " response < /dev/tty

        if [[ "$response" == "$foreign" ]]; then
            correct=$((correct + 1))
            echo "poprawna odpowiedź"
        else
            echo "musisz jeszcze popracować"
        fi


    done  < $filename
done

percentage=$(bc <<< "scale=1;$correct/$total_number*100")
echo "wynik : $correct / $total_number, procentowo : $percentage% "
exit 0