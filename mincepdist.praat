nocheck select all
nocheck Remove

baseDir$="/home/johanf/EST/lu_se_nn_nst_cg/wav/"

file1$=baseDir$+"data_00003.wav"
#file2$=baseDir$+"data_00004.wav"
file2$=baseDir$+"corpus1.wav"

s1=Read from file... 'file1$'
sp=Get sampling period
#Edit
s4=Copy...
Rename... new
Formula... 0
#Edit
s2=Read from file... 'file2$'
Rename... 's2'
plus 's1'

tstep=0.03
winlen=0.03
halfwin=winlen/2
shift=halfwin/2
sstep=tstep/sp
swinlen=winlen/sp
noprogress To MFCC: 12, 'winlen', 'tstep', 100, 100, 0
noprogress To DTW: 1, 0, 0, 0, 0.056, "no", "no", "no restriction"

m1=To Matrix (distances)
ytime=Get y of row: 1
nrow=Get number of rows

select 's1'
sn1=Get sample number from time: ytime-halfwin
sn2=sn1+swinlen

writeInfoLine: ""
last=1
for i from 1 to nrow
	select 'm1'
	ytime = Get y of row: 'i'
	s3=To Sound (slice): 'i'

	# with this we never select the same part two times after eachother (avoids ringing)
	#Set value at sample number: 0, last, 1000000
	xtime=Get time of minimum: 0, 0, "None"
	#last=Get sample number from time: xtime
	
	select 's2'
	#Edit
	#editor: 's2'
	#Select... xtime-halfwin xtime+halfwin
	#endeditor
	#appendInfoLine: xtime-halfwin, " ", xtime+halfwin




	
	#s5=Extract part: xtime-halfwin, xtime+halfwin, "Hanning", 1, "no"
	#s5=Extract part: xtime-halfwin, xtime+halfwin, "rectangular", 1, "no"

	s5=Extract part for overlap: xtime-halfwin, xtime+halfwin, 0.005


	#pause
	#writeInfoLine: "Ytime: ", ytime, ": Xtime: ", xtime
	#appendInfoLine: xtime-halfwin, " ", xtime+halfwin
	Rename... 's5'
	select 's4'
	Formula... if col >=sn1 && col <= sn2 then self+Sound_'s5'[col-sn1] else self fi
	#pause
	sn1=sn1+sstep
	sn2=sn2+sstep
	select 's3'
	#plus 's5'
	Remove
endfor
#writeInfoLine: "Ytime: ", ytime, ": Xtime: ", xtime
