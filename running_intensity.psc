nocheck select all
nocheck Remove
Read from file: "C:\Users\ling-jfr\Documents\Praat\data_00003.wav"
To Intensity: 100, 0, "yes"
ifwd=Down to Matrix
Rename... 'ifwd'

Formula... if col > 1 then (self[row,col]-self[row,1])^2 else self fi
Formula... if col == 1 then 0 else self fi

stemp=To Sound
Reverse
irev=Down to Matrix
Rename... 'irev'

select 'ifwd'
Formula... exp(-self/6000)+self[row,col-1]
sfwd=To Sound
Rename... 'sfwd'

select 'irev'
Formula... exp(-self/6000)+self[row,col-1]
srev=To Sound
Rename... 'srev'
Reverse
Formula... self+Sound_'sfwd'[]

#Formula... self+self[row,col-1]
#To Sound
Edit

