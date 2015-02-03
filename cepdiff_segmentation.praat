nocheck select all
nocheck Remove

#s1=Read from file: "/home/johanf/dev/compare_HCopy_praat/sa1.wav"
#s1=Read from file: "/home/johanf/EST/lu_se_nn_nst_cg/wav/data_00003.wav"
s1=Read from file: "C:\Users\ling-jfr\Dropbox\data_00003.wav"
#s1=Read from file: "C:\Users\ling-jfr\Dropbox\sa1.wav"
Copy: "sa1"
plus 's1'
noprogress To MFCC: 12, 0.025, 0.01, 100, 100, 0
noprogress To DTW: 1, 0, 0, 0, 0.056, "no", "no", "no restriction"
To Matrix (distances)
Formula: "self[col+1,col-1]"
#Formula: "self[col+1,col]+self[col-1,col]"
To Sound (slice): 1
#Filter (pass Hann band): 1/0.200, 1/0.100, 1
Filter (formula): "self*(exp(-(x/1.2011224/10)^2)-exp(-(x/1.2011224/5)^2))"
To PointProcess (extrema): 1, "yes", "no", "Sinc70"
np=Get number of points
for i from 1 to np
	p[i]=Get time from index: i
endfor
Up to TextTier: "peak"
Into TextGrid
Insert interval tier: 2, ""
for i from 1 to np
	Insert boundary: 2, p[i]
endfor
Remove tier: 1
plus 's1'
Edit




