nocheck select all
nocheck Remove
s1=Read from file... C:\Users\ling-jfr\Downloads\kdt_001.wav
Rename... id_'s1'
s2=Copy... copy
Rename... id_'s2'
Formula... Sound_id_'s1'[row,col+1]-self

select 's1'
p1=noprogress To Pitch... 0 75 300
plus 's2'
pp1=noprogress To PointProcess (peaks)... yes no
tg1=To TextGrid (vuv)... 0.02 0.01

select 'pp1'
np=Get number of points
for i from 1 to np
	timePoint'i'=Get time from index... i
endfor

select 's1'
s3=Resample... 96000 50
for i from 1 to np
	zcr'i'=Get nearest zero crossing... 1 timePoint'i'
endfor

#tg1=To TextGrid... zcr 
#for i from 1 to np
#	Insert boundary... 1 zcr'i'
#endfor

zA=zcr1
for i from 2 to np
	select 's3'
	zB=zcr'i'
	s4=Extract part... zA zB rectangular 1 no
	
	select 'tg1'
	iA=Get interval at time... 1 zA
	iB=Get interval at time... 1 zB

	select 's4'
	#if iA==iB
		Scale times to... 0 0.01
	#endif
	#Scale intensity... 70
	#Scale peak... 0.99
	ns'i'=Resample... 16000 50


	select 's4'
	Remove
	zA=zB
endfor

select ns2
for i from 3 to np
	plus ns'i'
endfor
Concatenate recoverably
s5=selected("Sound")
tg5=selected("TextGrid")

select ns2
for i from 3 to np
	plus ns'i'
endfor
Remove