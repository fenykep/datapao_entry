#!/bin/bash
Help()
{
	echo "majd segítek, csak előbb megírom a dolgokat."
}

wget -O imdb.html https://www.imdb.com/chart/top/
#sed -e 's/^[ \t]*//' < imdb.html | grep -m 20 -A8 posterColumn > processed.html
grep -m 20 -A5 'name="ir"' < imdb.html \
| sed -n -e '/name="ir" /p;/name="nv" /p;/a href/p;/img /p' \
| sed -e 's/.*ir" data-value="/Rating:/' -e 's/.*nv" data-value="/RNo:/' -e 's/.*title\//ID:/' -e 's/.*alt="/Title:/' \
| sed 's/">.*/,/;s/\/"/,/;s/"\/>/>/' | tr -d '\n' | tr '>' '\n' > processed.csv
#| sed -e 's/">*\/"/;/' > processed.html
# -m20 -A5 hogy husz darab cuccot irj ki, ahol van a nameIR plussz a kövi öt sort, aztán a sed csöndben(n) printeli azokat a sorokat, ahol vannak a keresett szettek
# és utána az uccsó -e kiszedi a tabokat meg szpészeket
