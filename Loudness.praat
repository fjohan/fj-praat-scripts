
procedure Loudness
dur=Get total duration
# forward masking
#coch1=To Cochleagram: 0.01, 0.1, 0.03, 0.03
# no forward masking
coch1=To Cochleagram: 0.01, 0.1, 0.03, 0

#curdur=ts1
curdur=0.028
x=1
while curdur < dur
	select 'coch1'
	To Excitation (slice): curdur
	loudness[x]=Get loudness
	Remove
	curdur=curdur+0.01
	x=x+1
endwhile
endproc

s1=selected("Sound",1)
s2=selected("Sound",2)
select 's1'
call Loudness
select 's2'
ns=Get number of samples
Copy...

x=1
while x <= ns
	Set value at sample number: 0, x, loudness[x]
	x=x+1
endwhile


