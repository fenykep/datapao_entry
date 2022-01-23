#!/bin/bash
Hanysor=20
#lehetne a sepcharnak is var, ha esetleg egy olyan film lenne a top 20-ban amiben van ;
wget -q -O- https://www.imdb.com/chart/top/ \
| grep -m $Hanysor -A5 'name="ir"' \
| sed -n -e '/name="ir" /p;/name="nv" /p;/a href/p;/img /p' \
| sed -e 's/.*ir" data-value="//' -e 's/.*nv" data-value="//' -e 's/.*title\///' -e 's/.*alt="//' \
| sed 's/">.*/;/;s/\/"/;/;s/"\/>/>/' | tr -d '\n' | tr '>' '\n' >> processed.csv

awkmegoldja(){
	maxos=1
	awk -F';' -v maxika=1 '{ cmd = "wget -q -O - https://www.imdb.com/title/"$3" | grep -o \"Won [[:digit:]]* Oscar\" | cut -c 5-6"
		cmd | getline result
		if($2>maxika){maxika=$2}
		if(length(result)==0) {
			print $4";"$3";"$1";"$2";0" > "newproci.csv"
		}
		else{
			print $4";"$3";"$1";"$2";"result > "newproci.csv"
		}
		close(cmd);
	} END { print maxika }' processed.csv
}

echo "TITLE;ID;IMDb SCORE;RATING NO;OSCAR NO;AJDUSTED SCORE" > almafa.csv
awkmegoldja | xargs -n 2 ./progi newproci.csv >> almafa.csv
rm processed.csv newproci.csv
#a c-s binbe kuldd bele az awkmegoldja returnjét és a csv-t
# így cat <(command1) <(command2)
#meg amúgy azt is lehetne, hogy az első blokk se filet generál hanem
# az awkmegoldjába pipeolod bele

# -m20 -A5 hogy husz darab cuccot irj ki, ahol van a nameIR plussz a kövi öt sort, 
#aztán a sed csöndben(n) printeli azokat a sorokat, ahol vannak a keresett szettek
# és utána kiszedjük ami nem fontos meg bedobáljuk a sepcharokat, nyúlálynokat
