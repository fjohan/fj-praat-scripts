nocheck select all
nocheck Remove

baseDir$="/home/johanf/EST/lu_se_nn_nst_cg/wav/"

file1$=baseDir$+"data_00003.wav"

winlen=0.015
halfwin=winlen/2
overlap=0.005

s1=Read from file... 'file1$'

pp1=noprogress To PointProcess (periodic, cc): 50, 175
Voice: 0.02, 0.02000000001
np=Get number of points

for i from 1 to np
	pptime[i]=Get time from index: i
endfor

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

