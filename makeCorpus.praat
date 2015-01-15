nocheck select all
nocheck Remove

minpi=50
maxpi=175
longpe=1/minpi
shortpe=1/maxpi
vlper=0.02
targetper=0.015

baseDir$="/home/johanf/EST/lu_se_nn_nst_cg/wav/"
obaseDir$="/home/johanf/EST/lu_se_nn_nst_cg/wavpn/"
str1=Create Strings as file list: "fileList", "/home/johanf/EST/lu_se_nn_nst_cg/wav/data_*.wav"

nstr=Get number of strings

#######################
# method 1: without epoch synch
if 1
for fileno from 1000 to 1100
	select 'str1'
	mystr$=Get string: fileno
	file$ = baseDir$+mystr$
	s1=Read from file... 'file$'
endfor
select all
minus 'str1'
Concatenate
Save as WAV file: "/home/johanf/EST/lu_se_nn_nst_cg/wav/corpus1.wav"
endif

##########################
# method 2: window centered over PP
if 0
winlen=0.015
halfwin=winlen/2
overlap=0.005
vlper=0.02

for fileno from 1000 to 1100
	select 'str1'
	mystr$=Get string: fileno
	file$ = baseDir$+mystr$
	s1=Read from file... 'file$'

	pp1=noprogress To PointProcess (periodic, cc): 50, 175
	Voice: vlper, 0.02000000001
	np=Get number of points

	for i from 1 to np
		pptime[i]=Get time from index: i
	endfor
	Remove

	select 's1'
	sChain=Extract part for overlap: pptime[1]-halfwin, pptime[1]+halfwin, overlap

	for i from 2 to np
		select 's1'
		sOld=sChain
		sCurrent=Extract part for overlap: pptime[i]-halfwin, pptime[i]+halfwin, overlap
		plus 'sChain'
		sChain=Concatenate with overlap: overlap
		select 'sOld'
		plus 'sCurrent'
		Remove
	endfor
	select 's1'
	Remove
endfor
#Save as WAV file: "/home/johanf/EST/lu_se_nn_nst_cg/wav/corpus2.wav"
endif

####################
# method 3: with epoch synch

# step 1: resample all epochs, can be skipped if already done
if 0
for fileno from 1000 to 1100
	select 'str1'
	mystr$=Get string: fileno
	file$ = baseDir$+mystr$
	s1=Read from file... 'file$'
	ofile$ = obaseDir$+mystr$

	sf=Get sampling frequency
	p1=noprogress To Pitch: 0, minpi, maxpi
	pp1=To PointProcess
	Voice: vlper, 0.02000000001
	np=Get number of points

	select 's1'
	pp2=To PointProcess (zeroes): 1, "yes", "no"

	nRaisers=Get number of points
	for i from 1 to nRaisers
		raise'i'=Get time from index: i
	endfor

	select 'pp1'
	k=0
	for i from 1 to np
		epochtime'i'=Get time from index: i
		for j from 1 to nRaisers
			if raise'j' > epochtime'i'
				k=k+1
				epnext'k'=raise'j'
				j = nRaisers
			endif
		endfor
	endfor

	select 's1'
	lb=epnext1
	rb=epnext2
	s2=Extract part: lb, rb, "rectangular", 1, "no"
	Scale times to: 0, targetper
	sCurrent=Resample: sf, 50
	select 's2'
	Remove

for i from 2 to k
	rb=epnext'i'
	#dur=rb-lb
	#if dur >= shortpe && dur <= longpe
		select 's1'
		s2=Extract part: lb, rb, "rectangular", 1, "no"
		Scale times to: 0, targetper
		s3=Resample: sf, 50
		select 'sCurrent'
		l1=Get total duration
		sOld=selected("Sound")
		plus 's3'
		sCurrent=Concatenate
		l2=Get total duration
		select 's2'
		plus 's3'
		plus 'sOld'
		Remove
	#endif
	lb=rb
endfor

	select 'sCurrent'
	#Save as WAV file: 'ofile$'
	Save as WAV file: ofile$


	select 's1'
	plus 'p1'
	plus 'pp1'
	plus 'pp2'
	plus 'sCurrent'
	Remove
endfor

# step 2: build corpus

str2=Create Strings as file list: "fileList", "/home/johanf/EST/lu_se_nn_nst_cg/wavpn/data_*.wav"
nstr=Get number of strings

for fileno from 1 to nstr
	select 'str2'
	mystr$=Get string: fileno
	file$ = obaseDir$+mystr$
	s1=Read from file... 'file$'
endfor
endif

select all
minus 'str1'
sTarget=Concatenate
noprogress To MFCC: 12, 0.015, 0.015, 100, 100, 0
fr1=Get time from frame number: 1
sLpad=Create Sound from formula: "pad", 1, 0, fr1/2, 16000, "0"
select 'sTarget'
sTarget=Copy...
select 'sLpad'
sRpad=Copy...
plus 'sLpad'
plus 'sTarget'
Concatenate
Save as WAV file: "/home/johanf/EST/lu_se_nn_nst_cg/wav/corpus.wav"
totdur=Get total duration
writeInfoLine: totdur
