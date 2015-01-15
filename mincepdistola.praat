nocheck select all
nocheck Remove

baseDir$="/home/johanf/EST/lu_se_nn_nst_cg/wav/"

file1$=baseDir$+"data_00003.wav"
#file2$=baseDir$+"data_00004.wav"
file2$=baseDir$+"corpus1.wav"

s1=Read from file... 'file1$'
s2=Read from file... 'file2$'
Rename... 's2'
plus 's1'

tstep=0.015
anwinlen=0.032
sywinlen=0.015
overlap=0.005
halfwin=sywinlen/2
noprogress To MFCC: 12, 'anwinlen', 'tstep', 100, 100, 0
noprogress To DTW: 1, 0, 0, 0, 0.056, "no", "no", "no restriction"

m1=To Matrix (distances)
ytime=Get y of row: 1
nrow=Get number of rows

ytime = Get y of row: 1
s3=To Sound (slice): 1
xtime=Get time of minimum: 0, 0, "None"
select 's2'
sCurrent=Extract part for overlap: xtime-halfwin, xtime+halfwin, overlap
select 's3'
Remove

last=1
for i from 2 to nrow
	select 'm1'
	ytime = Get y of row: 'i'
	s3=To Sound (slice): 'i'

	# with this we never select the same part two times after eachother (avoids ringing)
	#Set value at sample number: 0, last, 1000000
	xtime=Get time of minimum: 0, 0, "None"
	#last=Get sample number from time: xtime
	
	select 'sCurrent'
	oldCurrent=selected("Sound")

	select 's2'
	s5=Extract part for overlap: xtime-halfwin, xtime+halfwin, overlap
	plus 'sCurrent'
	sCurrent=Concatenate with overlap: overlap


	select 's3'
	#plus 's5'
	plus 'oldCurrent'
	Remove
endfor
