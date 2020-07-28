/********************************************************************************************/
/* Banking Industry Dynamics - Pablo/Dean										   N. Goyal */
/* Last Edit: ongoing	 						 				    	 Created: 9.26.2013 */
/*																						    */
/* PURPOSE:  Pull data for commercial banks from the Board of Governors' website.		    */
/*			 Also clean data: (To get to this section, hit Ctrl+F and search for *Clean*)	*/
/* RELATED DATA SETS: 	   								*/
/* RELATED FILES:   								*/
/********************************************************************************************/


libname PMdata 'X:\Neeraj Goyal\Pablo DErasmo\Bank Dynamics - Dean Corbae\Data\Mass download'; 
libname Pdata 'X:\Neeraj Goyal\Pablo DErasmo\Bank Dynamics - Dean Corbae\Data'; 
libname Q4s 'X:\Neeraj Goyal\Pablo DErasmo\Bank Dynamics - Dean Corbae\Data\Master Datasets - Cleaned';
/* This is where the data is stored*/

/* The SQL statement is used to pull data from the mainframe - here we set the parameters for: dates, variables, 
bank type, state, etc. Make changes here */


proc sql; 
	connect to ODBC (prompt= "uid=XXXXXXXX;pswd=XXXXXXXX;dsn=XXXXXXXX"); /* This is needed to access the mainframe */
%macro data_pull(startdt, enddt, year);
	create table Act_data1_&year as /*This is the name of the file that is created on our end*/

		/*These are the variables that are output to the file created abotve*/
		select id_rssd, dt, nm_short, NM_LGL, DT_OPEN, CITY, state_cd, ZIP_CD, INSUR_PRI_CD,
			CHTR_TYPE_CD, reg_hh_1_id, REG_HH_1_PCT, ID_FDIC_CERT,
			/*Pulling Asset side (Consolidated Offices) variables*/
			rcfd2170, rcfd2145, rcfd3123, rcfd3128,
			/*Pulling Asset side (Domestic Offices) variables*/
			rcon2170, rcon2145, 
			/*Pulling Liabilities side (Consolidated offices) variables*/
			rcfd2948, rcfd2200, rcfd2950, rcfd3210, rcfd2800,
			/*Pulling Liabilities side (Domestic offices) variables*/
			rcon2948, rcon2200, rcon2950, rcon3210, rcon2800,
			rcon2122, rcfd2122, rcfd2125, rcon1773, rcon0390, rcfd0390, 
			rcfd2146, rcfd8434, rcfd5610
		

		from connection to odbc(

			
		SELECT /*These are the variables that we tell the board to output*/
			/*Pulling attributes*/
			r1.id_rssd, r1.dt, nm_short, NM_LGL, DT_OPEN, CITY, state_cd, ZIP_CD, INSUR_PRI_CD,
			A.CHTR_TYPE_CD, reg_hh_1_id, REG_HH_1_PCT, ID_FDIC_CERT,
			/*Pulling Asset side (Consolidated Offices) variables*/
			r1.rcfd2170, r1.rcfd2145, r1.rcfd3123, r1.rcfd3128,
			/*Pulling Asset side (Domestic Offices) variables*/
			r1.rcon2170, r1.rcon2145, 
			/*Pulling Liabilities side (Consolidated offices) variables*/
			r1.rcfd2948, r1.rcfd2200, r1.rcfd2950, r1.rcfd3210, r1.rcfd2800,
			/*Pulling Liabilities side (Domestic offices) variables*/
			r1.rcon2948, r1.rcon2200, r1.rcon2950, r1.rcon3210, r1.rcon2800,
			r1.rcon2122, r1.rcfd2122, r1.rcfd2125, r1.rcon1773, r1.rcon0390, r1.rcfd0390, 
			r1.rcfd2146, r1.rcfd8434, r1.rcfd5610

 	 			/*These are the tables on the BOG's mainframe FROM which the variables are selected*/
				/*If a table hasn't previously been selected, add it here. You can visit this website to determine 
				  which table the var lies on: http://m-fwapp2p.frb.gov/content/rs_c/MDRM/html/fdr_report.html */
			FROM NARI.CUV_ATTRIBUTES A, nari.cuv_derived_items d, fdrp.cuv_rcri01_nc R1
 	 			WHERE r1.dt between a.dt_start and a.dt_end
 	 				and r1.dt between d.dt_start and d.dt_end
  					and r1.dt between &startdt and &enddt
    				AND a.CHTR_TYPE_CD in (200)
					and r1.id_rssd=d.id_rssd
					and r1.id_rssd=a.id_rssd
					
  	ORDER BY id_rssd, dt );
	
	create table Act_data2_&year as /*This is the name of the file that is created on our end*/

		/*These are the variables that are output to the file created abotve*/
		select id_rssd, dt,
			/*Pulling Asset side (Consolidated Offices) variables*/
			 rcfd2165, rcfd1766, rcfd1410, rcfd1975, rcfd1590, rcfd1403, rcfd1407,
			rcfd1406, 
			/*Pulling Asset side (Domestic Offices) variables*/
			 rcon2165, rcon1766, rcon1410, rcon1975, rcon1590, rcon1403, rcon1407,
			rcon1406,  
			/*Pulling Liabilities side (Domestic offices) variables*/
			rcon2210,
			/*Pulling Income Statement Variables*/
			riad4011, riad4012, riad4013, riad4107, riad4000, riad4170, riad4172,	
			riad4073, riad4130, riad4074, riad4079, riad4093, riad4135, riad4301,
			riad4300, riad4243, riad4185, riad4180, riad4150, riad4217,	
			/* Pulling miscellaneous variables*/
			rcon1400, rcfd1400, riad4059, riad4010,
			rcon2146,
			rcfd3368
		

		from connection to odbc(

			
		SELECT /*These are the variables that we tell the board to output*/
			
			r3.id_rssd, r3.dt,
			/*Pulling Asset side (Consolidated Offices) variables*/
			 r3.rcfd2165, r3.rcfd1766, r3.rcfd1410, r3.rcfd1975, r3.rcfd1590, r2.rcfd1403, r2.rcfd1407,
			r2.rcfd1406, 
			/*Pulling Asset side (Domestic Offices) variables*/
			 r3.rcon2165, r3.rcon1766, r3.rcon1410, r3.rcon1975, r3.rcon1590, r2.rcon1403, r2.rcon1407,
			r2.rcon1406, 
			/*Pulling Liabilities side (Domestic offices) variables*/
			r4.rcon2210, 
			/*Pulling Income Statement Variables*/
			r6.riad4011, r6.riad4012, r6.riad4013, r6.riad4107, r6.riad4000, r6.riad4170, r6.riad4172,	
			r6.riad4073, r6.riad4130, r6.riad4074, r6.riad4079, r6.riad4093, r6.riad4135, r6.riad4301,
			r6.riad4300, r6.riad4243, r6.riad4185, r6.riad4180, r6.riad4150, r6.riad4217,		
			/* Pulling miscellaneous variables*/
			r3.rcon1400, r3.rcfd1400, r6.riad4059, r6.riad4010,
			r3.rcon2146,
		    r6.rcfd3368

 	 			/*These are the tables on the BOG's mainframe FROM which the variables are selected*/
				/*If a table hasn't previously been selected, add it here. You can visit this website to determine 
				  which table the var lies on: http://m-fwapp2p.frb.gov/content/rs_c/MDRM/html/fdr_report.html */
			FROM NARI.CUV_ATTRIBUTES A, fdrp.cuv_rcri03_nc R3,
				 fdrp.cuv_rcri02_nc R2, fdrp.cuv_rcri04_nc R4,
				 fdrp.cuv_rcri06_nc R6
 	 			WHERE R2.dt between a.dt_start and a.dt_end
 	 				and R2.dt between &startdt and &enddt
    				AND a.CHTR_TYPE_CD in (200)
					and R2.id_rssd=a.id_rssd
					and R2.id_rssd=R3.id_rssd
					and R2.id_rssd=R4.id_rssd
					and R2.id_rssd=R6.id_rssd
										
					and R2.dt=R3.dt
					and R2.dt=R4.dt
					and R2.dt=R6.dt
					

  	ORDER BY id_rssd, dt );
	

	create table Act_data3_&year as /*This is the name of the file that is created on our end*/

		/*These are the variables that are output to the file created abotve*/
		select 	id_rssd, dt,
			/*Pulling Asset side (Consolidated Offices) variables*/
			rcfd0010, 
			/*Pulling Asset side (Domestic Offices) variables*/
			rcon0010, 
			/*Pulling Income Statement Variables*/
			 riad4635, riad4605, riad4230, riad4608, riad4609,
			riad4613, riad4616, riad4638, riad4639, 
			/* Pulling miscellaneous variables*/
			rcon1754, rcfd1754,	rcfd1773, rcon0390, rcon0400, rcfd0400, rcon0600, rcfd0600,  
			rcfd8274, rcfda224, 
			rcfda223, rcfd3792, riadb509
		

		from connection to odbc(

			
		SELECT /*These are the variables that we tell the board to output*/
			r7.id_rssd, r7.dt,
			/*Pulling Asset side (Consolidated Offices) variables*/
			r9.rcfd0010, 
			/*Pulling Asset side (Domestic Offices) variables*/
			r9.rcon0010, 
			/*Pulling Income Statement Variables*/
			r8.riad4635, r8.riad4605, r8.riad4230, r8.riad4608, r8.riad4609,
			r8.riad4613, r8.riad4616, r8.riad4638, r8.riad4639, 
			/* Pulling miscellaneous variables*/
			r11.rcon1754, r11.rcfd1754, r11.rcfd1773, r7.rcon0390, r7.rcon0400, r7.rcfd0400, r7.rcon0600, r7.rcfd0600, 
			r9.rcfd8274, r9.rcfda224, 
			r9.rcfda223, r9.rcfd3792, r7.riadb509

 	 			/*These are the tables on the BOG's mainframe FROM which the variables are selected*/
				/*If a table hasn't previously been selected, add it here. You can visit this website to determine 
				  which table the var lies on: http://m-fwapp2p.frb.gov/content/rs_c/MDRM/html/fdr_report.html */
			FROM NARI.CUV_ATTRIBUTES A, fdrp.cuv_rcri09_nc R9, 
				 fdrp.cuv_rcri08_nc R8, fdrp.cuv_rcri11_nc R11, fdrp.cuv_rcri07_nc R7
				
 	 			WHERE R7.dt between a.dt_start and a.dt_end
 	 				and R7.dt between &startdt and &enddt
    				AND a.CHTR_TYPE_CD in (200)
					and R7.id_rssd=a.id_rssd
					and R7.id_rssd=R8.id_rssd
					and R7.id_rssd=R9.id_rssd
					and R7.id_rssd=R11.id_rssd
										
					and R7.dt=R8.dt
					and R7.dt=R9.dt
					and R7.dt=R11.dt
					

  	ORDER BY id_rssd, dt );

	create table Act_data4_&year as /*This is the name of the file that is created on our end*/

		/*These are the variables that are output to the file created abotve*/
		select 
			id_rssd, dt,
			/*Pulling Asset side (Domestic Offices) variables*/
			rcon3123, rcon3128,
			rcon0900,
			rcon0380, 
			rcfd7204, rcfd7205, rcfd7206
		
		from connection to odbc(
			
		SELECT /*These are the variables that we tell the board to output*/
			r12.id_rssd, r12.dt,			
			/*Pulling Asset side (Domestic Offices) variables*/
			r13.rcon3123, r13.rcon3128,
			r16.rcon0900, 
			r16.rcon0380,
			r12.rcfd7204, r12.rcfd7205, r12.rcfd7206

 	 			/*These are the tables on the BOG's mainframe FROM which the variables are selected*/
				/*If a table hasn't previously been selected, add it here. You can visit this website to determine 
				  which table the var lies on: http://m-fwapp2p.frb.gov/content/rs_c/MDRM/html/fdr_report.html */
			FROM NARI.CUV_ATTRIBUTES A, fdrp.cuv_rcri13_nc R13, fdrp.cuv_rcri12_nc R12, fdrp.cuv_rcri16_nc R16
 	 			WHERE r12.dt between a.dt_start and a.dt_end
 	 				and r12.dt between &startdt and &enddt
    				AND a.CHTR_TYPE_CD in (200)
					and r12.id_rssd=a.id_rssd

					and R12.id_rssd=R13.id_rssd
					and R12.id_rssd=R16.id_rssd	
					and R12.dt=R13.dt
					and R12.dt=R16.dt


  		ORDER BY id_rssd, dt );

	create table Act_data5_&year as /*This is the name of the file that is created on our end*/

		/*These are the variables that are output to the file created abotve*/
		select 
			id_rssd, dt,
			
			/* Pulling miscellaneous variables*/
			rcfd0900, 
			rcfd0380 
		
		from connection to odbc(
			
		SELECT /*These are the variables that we tell the board to output*/
			r15.id_rssd, r15.dt,
				
			/* Pulling miscellaneous variables*/
			 r15.rcfd0900, 
			 r15.rcfd0380

 	 			/*These are the tables on the BOG's mainframe FROM which the variables are selected*/
				/*If a table hasn't previously been selected, add it here. You can visit this website to determine 
				  which table the var lies on: http://m-fwapp2p.frb.gov/content/rs_c/MDRM/html/fdr_report.html */
			FROM NARI.CUV_ATTRIBUTES A, fdrp.cuv_rcri15_nc R15
 	 			WHERE R15.dt between a.dt_start and a.dt_end
 	 				and R15.dt between &startdt and &enddt
    				AND a.CHTR_TYPE_CD in (200)
					and R15.id_rssd=a.id_rssd
									
			ORDER BY id_rssd, dt );

	create table pmdata.Act_Data_&year as
		select *
		from Act_data1_&year a, Act_data2_&year b, Act_data3_&year c, Act_data4_&year d, Act_data5_&year e
		where a.id_rssd=b.id_rssd
		 and a.id_rssd=c.id_rssd
		 and a.id_rssd=d.id_rssd
		 and a.id_rssd=e.id_rssd

		 and a.dt=b.dt
		 and a.dt=c.dt
		 and a.dt=d.dt
		 and a.dt=e.dt

	order by id_rssd, dt;
%mend;
	
quit;

%data_pull(19760101,19761231,1976)
%data_pull(19770101,19771231,1977)
%data_pull(19780101,19781231,1978)
%data_pull(19790101,19791231,1979)
%data_pull(19800101,19801231,1980)
%data_pull(19810101,19811231,1981)
%data_pull(19820101,19821231,1982)
%data_pull(19830101,19831231,1983)
%data_pull(19840101,19841231,1984)
%data_pull(19850101,19851231,1985)
%data_pull(19860101,19861231,1986)
%data_pull(19870101,19871231,1987)
%data_pull(19880101,19881231,1988)
%data_pull(19890101,19891231,1989)
%data_pull(19900101,19901231,1990)
%data_pull(19910101,19911231,1991)
%data_pull(19920101,19921231,1992)
%data_pull(19930101,19931231,1993)
%data_pull(19940101,19941231,1994)
%data_pull(19950101,19951231,1995)
%data_pull(19960101,19961231,1996)
%data_pull(19970101,19971231,1997)
%data_pull(19980101,19981231,1998)
%data_pull(19990101,19991231,1999)
%data_pull(20000101,20001231,2000)
%data_pull(20010101,20011231,2001)
%data_pull(20020101,20021231,2002)
%data_pull(20030101,20031231,2003)
%data_pull(20040101,20041231,2004)
%data_pull(20050101,20051231,2005)
%data_pull(20060101,20061231,2006)
%data_pull(20070101,20071231,2007)
%data_pull(20080101,20081231,2008)
%data_pull(20090101,20091231,2009)
%data_pull(20100101,20101231,2010)
%data_pull(20110101,20111231,2011)
%data_pull(20120101,20121231,2012)

/*Fix download issues*/
proc sql; 
%macro data_merge(startdt, enddt, year);

	create table pmdata.Act_Data_&year as
		select *
		from Act_data1_&year a, Act_data2_&year b, Act_data3_&year c, Act_data4_&year d
		where a.id_rssd=b.id_rssd
		 and a.id_rssd=c.id_rssd
		 and a.id_rssd=d.id_rssd
		
		 and a.dt=b.dt
		 and a.dt=c.dt
		 and a.dt=d.dt

	order by id_rssd, dt;
%mend;
quit;

%data_merge(19900101,19901231,1990)
%data_merge(19910101,19911231,1991)
%data_merge(19920101,19921231,1992)
%data_merge(19930101,19931231,1993)
%data_merge(19940101,19941231,1994)
%data_merge(19950101,19951231,1995)
%data_merge(19960101,19961231,1996)
%data_merge(19970101,19971231,1997)
%data_merge(19980101,19981231,1998)
%data_merge(19990101,19991231,1999)
%data_merge(20000101,20001231,2000)
%data_merge(20010101,20011231,2001)
%data_merge(20020101,20021231,2002)
%data_merge(20030101,20031231,2003)
%data_merge(20040101,20041231,2004)
%data_merge(20050101,20051231,2005)
%data_merge(20060101,20061231,2006)
%data_merge(20070101,20071231,2007)
%data_merge(20080101,20081231,2008)
%data_merge(20090101,20091231,2009)
%data_merge(20100101,20101231,2010)
%data_merge(20110101,20111231,2011)
%data_merge(20120101,20121231,2012)

%macro append(file);
proc append 
	base = pmdata.Act_Data_1976
	data = &file;
run;
%mend;
%append(pmdata.act_data_1977)
%append(pmdata.act_data_1978)
%append(pmdata.act_data_1979)
%append(pmdata.act_data_1980)
%append(pmdata.act_data_1981)
%append(pmdata.act_data_1982)
%append(pmdata.act_data_1983)
%append(pmdata.act_data_1984)
%append(pmdata.act_data_1985)
%append(pmdata.act_data_1986)
%append(pmdata.act_data_1987)
%append(pmdata.act_data_1988)
%append(pmdata.act_data_1989)
%append(pmdata.act_data_1990)
%append(pmdata.act_data_1991)
%append(pmdata.act_data_1992)
%append(pmdata.act_data_1993)
%append(pmdata.act_data_1994)
%append(pmdata.act_data_1995)
%append(pmdata.act_data_1996)
%append(pmdata.act_data_1997)
%append(pmdata.act_data_1998)
%append(pmdata.act_data_1999)
%append(pmdata.act_data_2000)
%append(pmdata.act_data_2001)
%append(pmdata.act_data_2002)
%append(pmdata.act_data_2003)
%append(pmdata.act_data_2004)
%append(pmdata.act_data_2005)
%append(pmdata.act_data_2006)
%append(pmdata.act_data_2007)
%append(pmdata.act_data_2008)
%append(pmdata.act_data_2009)
%append(pmdata.act_data_2010)
%append(pmdata.act_data_2011)
%append(pmdata.act_data_2012)

/*Just renaming some of the attribute variables to their RSSD number equivalents*/

data pmdata.Master_dataset;
rename id_rssd = rssd9001
nm_lgl = rssd9017 
dt_open = rssd9950 
city = rssd9130 
state_cd = rssd9210 
zip_cd = rssd9220 
insur_pri_cd = rssd9424 
reg_hh_1_id = rssd9348 
reg_hh_1_pct = rssd9349 
chtr_type_cd = rssd9048
nm_short = rssd9010
id_fdic_cert = rssd9050; 
set pmdata.act_data_1976;
run;

/* *Clean* Getting Quarterly Data and Cleaning */

/*proc freq data = Q4s.yearly_dataset noprint;
tables rssd9424/out=test;
run;*/

/* Creating dataset with only year-end observations*/
/* Also cleaning the file*/
data Q4s.Master_data_Q4; 
set pmdata.Master_dataset;
Year_end=substrn(dt,5,4);
if year_end = 1231;
if rssd9424 ^=0; /*Dropping observations if No Insurer is found */
if rssd9210 > 0 and rssd9210 <57;  /*Dropping observations that are not in 1 of the 50 states*/
if rcfd2170 in (0,.) then delete; *and Need to figure out what else Pablo wanted to condition on*/;
run;

data Q4s.Master_data; 
set pmdata.Master_dataset;
Year_end=substrn(dt,5,4);
if rssd9424 ^=0; /*Dropping observations if No Insurer is found */
if rssd9210 > 0 and rssd9210 <57;  /*Dropping observations that are not in 1 of the 50 states*/
if rcfd2170 in (0,.) then delete; *and Need to figure out what else Pablo wanted to condition on*/;
run;

