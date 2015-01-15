
procedure RunningDuration
bf1=noprogress To BarkFilter: 0.03, 0.01, 3.1258431985277, 1, 19.82506243704934
Equalize intensities: 80
mdist=To Matrix
nRow=Get number of columns

if 1
#Formula... 10^(self/10)

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
select 'mdist'
Formula... self/s[col]
#Formula... self^(1/3)
endif

Formula... if col < ncol then (self[row,col+1]-self)^2 else 0 fi
Formula... self+self[row-1,col]

sdist=To Sound (slice): 17
Rename... 'sdist'
sfwd=Copy...
Rename... 'sfwd'
Formula... 0
srev=Copy...
Rename... 'srev'

cC=0.000625
for i from 1 to nRow
irev=nRow-i+1
j=nRow+1
select 'sdist'
stmp=Copy...
Rename... 'stmp'
Formula... if col >= i && col < j then self+self[col-1] else 0 fi
Formula... if col >= i && col < j then exp(-self/cC)+self[col-1] else self[col-1] fi
select 'sfwd'
Formula... if col == i then Sound_'stmp'[nRow] else self fi
select 'stmp'
Remove

select 'sdist'
stmp=Copy...
Rename... 'stmp'
Reverse
Formula... if col >= irev && col < j then self+self[col-1] else 0 fi
Formula... if col >= irev && col < j then exp(-self/cC)+self[col-1] else self[col-1] fi
select 'srev'
Formula... if col == i then Sound_'stmp'[nRow] else self fi
select 'stmp'
Remove

endfor

select 'srev'
Formula... 0.01*(self+Sound_'sfwd'[])

select 'bf1'
plus 'mdist'
plus 'sdist'
plus 'sfwd'
Remove
select 'srev'
Edit
endproc

#nocheck select all
#nocheck Remove
#Read from file: "/home/johanf/EST/lu_se_nn_nst_cg/wav-autosyl/data_00003.wav"
#Read from file: "C:\Users\ling-jfr\Documents\Praat\data_00003.wav"
call RunningDuration


