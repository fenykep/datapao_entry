#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void fileolvasas(FILE *fp, int max){
	char coc[323]; //197title+10id+17rating+9rno+2oscarno
    char *result;
    //int max=2530793;
    int rno;
    double rating;
    double adjrating;
    int oscarno;
    //printf("TITLE;ID;IMDb SCORE;RATING NO;OSCAR NO;AJDUSTED SCORE\n");
		while((result=fgets(coc,323,fp))!=NULL) {
			char *token = strtok(coc, ";");
            int sorindex = 0;
            while (token != NULL)
            {
                if(sorindex==0 || sorindex==1){
                    printf("%s;",token);
                }
                if(sorindex==2){
                    rating=atof(token);
                    if(rating<1.0)
                    {
                        fprintf(stderr, "Bad rating to float conversion");
                    }
                    printf("%0.15f;",rating);
                }
                if(sorindex==3){
                    rno = atoi(token);
                    if(rno==0)
                    {
                        fprintf(stderr, "Bad rno to int conversion");
                    }
                    printf("%i;", rno); 
                }
                if(sorindex==4){
                    oscarno=atoi(token);
                    if(token[0]!='0'&&oscarno==0)
                    {
                        fprintf(stderr, "Bad oscarno to int conversion");
                    }
                    printf("%i;", oscarno);
                    adjrating = (double)((max-rno)/100000)*-0.1;
                    if(oscarno == 1 || oscarno == 2){adjrating+=0.3;}
                    else if(oscarno>=3 && oscarno<=5){adjrating+=0.5;}
                    else if(oscarno>=10 && oscarno<=10){adjrating+=1.0;}
                    else if(oscarno>10){adjrating+=1.5;}
                    printf("%0.15f\n",rating+adjrating);
                }
                token = strtok(NULL, ";");
                sorindex++;
            }
		}
		fclose(fp);
}

void main(int argc, char *argv[]) {
    FILE *fajlpolynter;
	if((fajlpolynter = fopen(argv[1], "r")) != NULL){
		fileolvasas(fajlpolynter, atof(argv[2]));
	}
	else{
		fprintf(stderr, "Ez most nem nyilt meg :(");
	}
}
