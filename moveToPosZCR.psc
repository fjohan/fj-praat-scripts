nocheck select all
nocheck Remove

baseDir$="/home/johanf/EST/lu_se_nn_nst_cg/wav/"

file1$=baseDir$+"corpusIn.wav"
file2$=baseDir$+"data_00004.wav"
file2$=baseDir$+"corpus.wav"

minpi=50
maxpi=175
longpe=1/minpi
shortpe=1/maxpi
vlper=0.02
targetper=0.015

s1=Read from file... 'file1$'
sf=Get sampling frequency
p1=noprogress To Pitch: 0, 50, 175
pp1=To PointProcess
Voice: vlper, 0.02000000001

#sBase=Create Sound from formula: "base", 1, 0, targetper*0.75, sf, "0"
#sCurrent=selected("Sound")

select 's1'
pp2=To PointProcess (zeroes): 1, "yes", "no"

# create a new empty pointprocess
select 'pp1'
pp3=Copy...
np=Get number of points
Remove points: 1, np

appendFileLine: "/tmp/praat.log"

select 'pp2'
nRaisers=Get number of points
for i from 1 to nRaisers
	raise'i'=Get time from index: i
endfor
appendFileLine: "/tmp/praat.log", "raisers (", i, "/", nRaisers,")"

select 'pp1'
k=0
for i from 1 to np
	epochtime'i'=Get time from index: i
	for j from 1 to nRaisers
		if raise'j' > epochtime'i'
			k=k+1
			epnext'k'=raise'j'
			#if j>1
			#	jmin1=j-1
			#	epprev'i'=raise'jmin1'
			#endif
			j = nRaisers
		endif
	endfor
	appendFileLine: "/tmp/praat.log", "epochs (", i, "/", np,")"
endfor

select 's1'
lb=epnext1
rb=epnext2
s2=Extract part: lb, rb, "rectangular", 1, "no"
Scale times to: 0, targetper
sCurrent=Resample: sf, 50
select 's2'
Remove

sLpad=Create Sound from formula: "pad", 1, 0, 0.0075, 16000, "0"
writeInfoLine: ""
lb=epnext1
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
		appendFileLine: "(", i, "/", k,")"
		#sCurrent=Concatenate with overlap: targetper/2
		select 's2'
		plus 's3'
		plus 'sOld'
		Remove
	#endif
	lb=rb
endfor
select 'sLpad'
sRpad=Copy...
plus 'sLpad'
plus 'sCurrent'
sCurrent=Concatenate

#select 'pp3'
#for i from 1 to k
#	Add point: epnext'i'
#	#Add point: epprev'i'
#endfor

select 'sCurrent'
Save as WAV file: "/home/johanf/EST/lu_se_nn_nst_cg/wav/corpus.wav"
totdur=Get total duration
#writeInfoLine: totdur






