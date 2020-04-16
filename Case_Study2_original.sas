SAS Code
/* Generated Code (IMPORT) */
/* Source File: carmpgdata_2.csv.csv */
/* Source Path: /home/daedwards0/New Folder */
*%web_drop_table(CarMPG);

/*Import Data*/
FILENAME Cars '/folders/myfolders/car_mpg_data.csv';

PROC IMPORT DATAFILE=Cars
	DBMS=CSV
	OUT=CarMPG;
	GETNAMES=YES;
RUN;

/*Litewise Deletion*/
PROC REG DATA=CarMPG;
MODEL MPG = CYLINDERS SIZE HP WEIGHT ACCEL;
RUN;

/* Missing Data Pattern*/
ODS SELECT MISSPATTERN;
PROC MI DATA=CarMPG NIMPUTE=0;
var  MPG CYLINDERS SIZE HP WEIGHT ACCEL;
RUN;

/*Create Imputed Data*/
PROC MI DATA=CarMPG Out= MpgOUT seed=3599;
var  MPG CYLINDERS SIZE HP WEIGHT ACCEL;
RUN;

/*Analysis of Imputed Data*/
PROC REG DATA=MpgOUT outest=outreg covout;
MODEL MPG = CYLINDERS SIZE HP WEIGHT ACCEL;
by _Imputation_;
RUN;

/*Combine all imputed datasets*/
PROC  MIANALYZE data=outreg;
MODELEFFECTS CYLINDERS SIZE HP WEIGHT ACCEL Intercept;
run;

%web_open_table(CarMPG);
