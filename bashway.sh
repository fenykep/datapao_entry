wget abelbodis.hu
cat index.html | sed -n -e '/chItem/,/description/ p' > table.txt
