#!/bin/bash
Hanysor=5
#lehetne a sepcharnak is var, ha esetleg egy olyan film lenne a top 20-ban amiben van ;
#echo 'Rating;RNo;ID;Title' > processed.csv
wget -q -O- https://www.imdb.com/chart/top/ \
| grep -m $Hanysor -A5 'name="ir"' \
| sed -n -e '/name="ir" /p;/name="nv" /p;/a href/p;/img /p' \
| sed -e 's/.*ir" data-value="//' -e 's/.*nv" data-value="//' -e 's/.*title\///' -e 's/.*alt="//' \
| sed 's/">.*/;/;s/\/"/;/;s/"\/>/>/' | tr -d '\n' | tr '>' '\n' >> processed.csv

forlooposSzett(){
    for (( i = 2; i <= $Hanysor+1; i++))
    do
        hely=$(awk -F';' 'NR=='$i'{print $3}' processed.csv)
        hely="https://www.imdb.com/title/"$hely
        wget -q -O - $hely \
        | grep -o 'Won [[:digit:]]* Oscars' > $i"oszkar.txt"
	sed \nz 's/\n/;BeeBoo;/g' processed.csv
    done
}

awkmegoldja(){
	maxos=1
	awk -F';' -v maxika=1 '{ cmd = "wget -q -O - https://www.imdb.com/title/"$3" | grep -o \"Won [[:digit:]]* Oscar\" | cut -c 5-6"
		cmd | getline result
		if($2>maxika){maxika=$2}
		if(length(result)==0) {
			print $4";"$3";"$1";"$2";0" > "newproci.csv"
		}
		else{
			print $4";"$3";"$1";"$2";"result + 10 > "newproci.csv"
		}
		close(cmd);
	} END { print maxika }' processed.csv
}

penalizador(){
	echo "hallatlan"
	echo $1
}

awkmegoldja


# -m20 -A5 hogy husz darab cuccot irj ki, ahol van a nameIR plussz a kövi öt sort, 
#aztán a sed csöndben(n) printeli azokat a sorokat, ahol vannak a keresett szettek
# és utána kiszedjük ami nem fontos meg bedobáljuk a sepcharokat, nyúlálynokat

#role="presentation" class="ipc-metadata-list__item ipc-metadata-list-item--link" data-testid="award_information"

#grep 'class="ipc-page-background ipc-page-background--base MainDetailPageLayout__StyledPageBackground' \
