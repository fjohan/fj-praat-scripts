
procedure RunningDuration3
noprogress To BarkFilter: 0.03, 0.01, 3.1258431985277, 1, 19.82506243704934
mfwd=To Matrix
Rename... 'mfwd'

if 1
Formula... exp(self/10)

tr=Transpose
nRow=Get number of rows
for i from 1 to nRow
	select 'tr'
	stmp=To Sound (slice): i
	mtmp=Down to Matrix
	s[i]=Get sum
	plus 'stmp'
	Remove
endfor
select 'tr'
Remove
select 'mfwd'
Formula... self/s[col]
Formula... self^(1/3)
endif

Formula... if col > 1 then (self-self[row,1])^2 else self fi
Formula... if col == 1 then 0 else self fi
Formula... self+self[row-1,col]

sfwd=To Sound (slice): 17
#Edit
#exit
Rename... 'sfwd'
srev=Copy...
Rename... 'srev'
Reverse

select 'sfwd'
Formula... exp(-self/0.3)+self[row,col-1]

select 'srev'
Formula... exp(-self/0.3)+self[row,col-1]
Reverse
Formula... -self-Sound_'sfwd'[]
Edit
endproc


procedure RunningDuration2
noprogress To BarkFilter: 0.03, 0.01, 3.1258431985277, 1, 19.82506243704934
mfwd=To Matrix
Rename... 'mfwd'

if 0
Formula... exp(self/10)

tr=Transpose
nRow=Get number of rows
for i from 1 to nRow
	select 'tr'
	stmp=To Sound (slice): i
	mtmp=Down to Matrix
	s[i]=Get sum
	plus 'stmp'
	Remove
endfor
select 'tr'
Remove
select 'mfwd'
Formula... self/s[col]
Formula... self^(1/3)
endif

stemp=To Sound
Reverse
mrev=Down to Matrix
Rename... 'mrev'

select 'mfwd'
Formula... if col > 1 then (self-self[row,1])^2 else self fi
Formula... if col == 1 then 0 else self fi
Formula... self+self[row-1,col]
sfwd=To Sound (slice): 17
Rename... 'sfwd'
Formula... exp(-self/600)+self[row,col-1]

select 'mrev'
Formula... if col > 1 then (self-self[row,1])^2 else self fi
Formula... if col == 1 then 0 else self fi
Formula... self+self[row-1,col]
srev=To Sound (slice): 17
Rename... 'srev'
Formula... exp(-self/600)+self[row,col-1]
Reverse
Formula... self+Sound_'sfwd'[]
Edit
endproc

procedure RunningDuration
noprogress To BarkFilter: 0.03, 0.01, 3.1258431985277, 1, 19.82506243704934
#Equalize intensities: 80
mfwd=To Matrix

#if 0
Formula... exp(self/10)

#clearinfo
tr=Transpose
nRow=Get number of rows
for i from 1 to nRow
	select 'tr'
	stmp=To Sound (slice): i
	mtmp=Down to Matrix
	s[i]=Get sum
	#s[i]=s[i]*nRow
	plus 'stmp'
	Remove
endfor
select 'tr'
Remove
select 'mfwd'
Formula... self/s[col]
Formula... self^(1/3)

if 0
tr=Transpose
nRow=Get number of rows
for i from 1 to nRow
	select 'tr'
	stmp=To Sound (slice): i
	mtmp=Down to Matrix
	s=Get sum
	printline 'i' 's'
endfor
endif
#exit
#endif

#Formula... if col > 1 then (self-self[row,1])^2 else self fi
#Formula... if col == 1 then 0 else self fi
#Formula... self+self[row-1,col]
#sfwd=To Sound (slice): 17
#Edit
#exit

Formula... (self-self[row,1])^2+self[row-1,col]
sfwd=To Sound (slice): 17
#Edit
#exit



Rename... 'sfwd'
srev=Copy...
Rename... 'srev'
Reverse
select 'sfwd'
Formula... exp(-self/600)+self[row,col-1]
select 'srev'
Formula... exp(-self/600)+self[row,col-1]
Reverse
Formula: "self + Sound_'sfwd'[]"
Formula: "if col = 1 then self[col+1] else self fi"
#myMin=Get minimum: 0, 0, "None"
#Formula: "self - myMin"
Scale... 0.99
#Formula: "self*200*3.6"
Edit
endproc

nocheck select all
nocheck Remove
#Read from file: "/home/johanf/EST/lu_se_nn_nst_cg/wav-autosyl/data_00003.wav"
Read from file: "C:\Users\ling-jfr\Documents\Praat\data_00003.wav"
call RunningDuration3


