form Pos data analyzer
	sentence majorPath /home/your_name_here/
	word minorPath 160427_AA_demo
	natural currentSweep 24
	comment Plot boundaries (please set sensible values here)
	integer left_X_boundaries -80
	integer right_X_boundaries 80
	integer left_Y_boundaries -80
	integer right_Y_boundaries 80
	comment Channel options
	word TT_Channel Ch1
	word TD_Channel Ch2
	word UL_Channel Ch8
	word LL_Channel Ch7
	comment Sample rate (AG500=200, AG501=250)
	integer sampleRate 250
	#sentence Categories HAT/HET/HIT/HUT/HUT/HYT/HÅT/HÄT/HÖT
endform
nocheck select all
nocheck Remove
Erase all

artX1=left_X_boundaries
artX2=right_X_boundaries
artY1=left_Y_boundaries
artY2=right_Y_boundaries
ttChX$=tT_Channel$+"_X"
tdChX$=tD_Channel$+"_X"
ulChX$=uL_Channel$+"_X"
llChX$=lL_Channel$+"_X"
ttChZ$=tT_Channel$+"_Z"
tdChZ$=tD_Channel$+"_Z"
ulChZ$=uL_Channel$+"_Z"
llChZ$=lL_Channel$+"_Z"
wavTop=100
wavBottom=80
specTop=80
specBottom=40
garnish$="yes"
analyzed=0

# uncommented to get sane syntax highlighting
if windows
  separator$ = "\"
else
  separator$ = "/"
endif

timeRange1=0
timeRange2=0
logName$=majorPath$+separator$+minorPath$+separator$+"pda_"+replace_regex$(date$ (),"[ :]", "_",0)+".log"
#call split "'categories$'" /
#printline 'split.arr$[1]'
goto GETDATA

label CLEANDATA
select 's1'
plus 'spec1'
plus 't1'
plus 'tor2'
Remove
goto GETDATA

label GETDATA
sweepAsString$=right$("000"+"'currentSweep'",4)
wavName$=majorPath$+separator$+minorPath$+separator$+"wav"+separator$+sweepAsString$+".wav"
posName$=majorPath$+separator$+minorPath$+separator$+"pos"+separator$+sweepAsString$+".txt"
s1=Read from file... 'wavName$'
soundDur=Get total duration
timeRange1=0
timeRange2=soundDur
spec1=noprogress To Spectrogram... 0.005 5000 0.002 20 Gaussian
# articulatory data
t1=Read Table from tab-separated file... 'posName$'
tor1=Down to TableOfReal... 0

# low pass filter
nCol=Get number of columns
for i from 1 to nCol
	colLab'i'$=Get column label... i
endfor

m1=To Matrix
m2=Transpose
s2=To Sound
Scale times to... 0 1
Override sampling frequency... sampleRate
s3=Filter (pass Hann band)... 0 10 1
m3=Down to Matrix
m4=Transpose
tor2=To TableOfReal
for i from 1 to nCol
	current$=colLab'i'$
	Set column label (index)... i 'current$'
endfor

select 'tor1'
plus 'm1'
plus 'm2'
plus 's2'
plus 's3'
plus 'm3'
plus 'm4'
Remove

goto REDRAW

label REDRAW
demo Erase all
demo Select outer viewport... 0 100 0 100
demo Axes... 0 100 0 100
demo Black
demo Line width... 1
demo Solid line

# Title
demo Text... 50 centre 100 top 'sweepAsString$'

# buttons
call DrawButton 0 20 12 18 Play
call DrawButton 25 45 12 18 Analyze
call DrawButton 50 70 12 18 Undo
call DrawButton 75 95 12 18 Next

call DrawButton 12 32 24 30 Left
call DrawButton 37 58 28 34 Zoom in
call DrawButton 37 58 20 26 Zoom out
call DrawButton 63 83 24 30 Right

procedure DrawButton .leftX .rightX .topY .bottomY .buttonText$
	demo Paint rectangle... pink .leftX .rightX .topY .bottomY
	demo Draw rectangle... .leftX .rightX .topY .bottomY
	.textX = (.rightX + .leftX) / 2
	.textY = (.topY + .bottomY) / 2
	demo Text... .textX centre .textY half '.buttonText$'
endproc

# waveform
demo Select outer viewport... 0 100 'wavBottom' 'wavTop'
select 's1'
demo Draw... timeRange1 timeRange2 0 0 yes Curve

# spectrogram
demo Select outer viewport... 0 100 'specBottom' 'specTop'
select 'spec1'
demo Paint... timeRange1 timeRange2 0 0 100 yes 50 6 0 yes

myDemoX1=timeRange1
myDemoX2=timeRange1
currentMark=1
goto MARK

label WAIT
while demoWaitForInput ( )
	if demoClicked ( )
		demo Select outer viewport... 0 100 0 100
		demo Axes... 0 100 0 100
		goto PLAY demoClickedIn (0, 20, 12, 18)
		goto ANALYZE demoClickedIn (25, 45, 12, 18)
		goto UNDO demoClickedIn (50, 70, 12, 18)
		goto NEXT demoClickedIn (75, 95, 12, 18)

		goto VIEWLEFT demoClickedIn (12, 32, 24, 30)
		goto ZOOMIN demoClickedIn (37, 58, 28, 34)
		goto ZOOMOUT demoClickedIn (37, 58, 20, 26)
		goto VIEWRIGHT demoClickedIn (63, 83, 24, 30)

		demo Undo

		demo Select outer viewport... 0 100 'specBottom' 'specTop'
		demo Axes... 0 'soundDur' 0 5000
		goto GETMOUSEX demoClickedIn (0, soundDur, 0, 5000)
		demo Undo
	endif
	goto EXIT demoInput ("x")
endwhile

label ZOOMIN
demo Undo
viewDur=timeRange2-timeRange1
viewCenter=(timeRange2+timeRange1)/2
viewDur=viewDur*0.5
timeRange1=viewCenter-(viewDur/2)
timeRange2=viewCenter+(viewDur/2)
goto REDRAW

label ZOOMOUT
demo Undo
viewDur=timeRange2-timeRange1
viewCenter=(timeRange2+timeRange1)/2
viewDur=viewDur*2
timeRange1=viewCenter-(viewDur/2)
timeRange2=viewCenter+(viewDur/2)
if timeRange1<0.001
	timeRange1=0
endif
if timeRange2>soundDur
	timeRange2=soundDur
endif
goto REDRAW

label VIEWLEFT
demo Undo
moveDelta=1
if timeRange1<moveDelta
	moveDelta=timeRange1
endif
timeRange1=timeRange1-moveDelta
timeRange2=timeRange2-moveDelta
goto REDRAW

label VIEWRIGHT
demo Undo
moveDelta=1
if timeRange2>soundDur-moveDelta
	moveDelta=soundDur-timeRange2
endif
timeRange1=timeRange1+moveDelta
timeRange2=timeRange2+moveDelta
goto REDRAW

label NEXT
demo Undo
currentSweep=currentSweep+1
goto CLEANDATA

label PLAY
demo Undo
#printline play 'myDemoX1' 'myDemoX2'
# check
if myDemoX1 == 0 && myDemoX2 == 0
	goto WAIT
endif
if (myDemoX1 < myDemoX2)
	mySoundSamp1 = myDemoX1
	mySoundSamp2 = myDemoX2
else
	mySoundSamp1 = myDemoX2
	mySoundSamp2 = myDemoX1
endif
select 's1'
s2=Extract part... mySoundSamp1 mySoundSamp2 rectangular 1 no
Play
Remove
goto WAIT

label UNDO
demo Undo
Undo
Undo
Undo
Undo
Undo
Undo
Undo
Undo
#printline undo
analyzed=analyzed-1
if analyzed<0
	analyzed=0
endif
if analyzed=0
	garnish$="yes"
endif
goto WAIT

label EXIT
demo Select outer viewport... 0 100 0 100
demo Axes... 0 100 0 100
demo Text... 50 centre 0 bottom Script has finished. Please close this window manually...
exit

label GETMOUSEX
demo Undo

demo Undo
demo Undo
demo Undo
demo Undo
demo Undo
if currentMark==1
	myDemoX1=demoX ( )
	currentMark=2
else
	myDemoX2=demoX ( )
	currentMark=1
endif
goto MARK

label MARK
demo Red
demo Dashed line
demo Line width... 2
demo Draw line... myDemoX1 0 myDemoX1 5000
demo Draw line... myDemoX2 0 myDemoX2 5000
goto WAIT

label ANALYZE
demo Undo
#printline analyze 'myDemoX1' 'myDemoX2'
# check
if myDemoX1 == 0 || myDemoX2 == 0
	goto WAIT
endif
if (myDemoX1 < myDemoX2)
	mySamp1 = floor(myDemoX1 * sampleRate)
	mySamp2 = ceiling(myDemoX2 * sampleRate)
else
	mySamp1 = floor(myDemoX2 * sampleRate)
	mySamp2 = ceiling(myDemoX1 * sampleRate)
endif
select 'tor2'
tor3=Extract row ranges... 'mySamp1':'mySamp2'
t2=To Table... 
Append column... labelColumn
nRow=Get number of rows
for i from 1 to nRow
	Set string value... i labelColumn +
endfor
Set string value... 1 labelColumn S
Set string value... nRow labelColumn E

# plot
Blue
Scatter plot... 'ttChX$' artX1 artX2 'ttChZ$' artY1 artY2 labelColumn 12 'garnish$'
garnish$="no"
Red
Scatter plot... 'tdChX$' artX1 artX2 'tdChZ$' artY1 artY2 labelColumn 12 'garnish$'
Green
Scatter plot... 'ulChX$' artX1 artX2 'ulChZ$' artY1 artY2 labelColumn 12 'garnish$'
Purple
Scatter plot... 'llChX$' artX1 artX2 'llChZ$' artY1 artY2 labelColumn 12 'garnish$'

ttxMed=Get quantile... 'ttChX$' 0.5
ttzMed=Get quantile... 'ttChZ$' 0.5
tdxMed=Get quantile... 'tdChX$' 0.5
tdzMed=Get quantile... 'tdChZ$' 0.5
ulxMed=Get quantile... 'ulChX$' 0.5
ulzMed=Get quantile... 'ulChZ$' 0.5
llxMed=Get quantile... 'llChX$' 0.5
llzMed=Get quantile... 'llChZ$' 0.5
time1=mySamp1/sampleRate
time2=mySamp2/sampleRate
printline 'time1:3''tab$''time2:3''tab$''ttxMed:3''tab$''ttzMed:3''tab$''tdxMed:3''tab$''tdzMed:3''tab$''ulxMed:3''tab$''ulzMed:3''tab$''llxMed:3''tab$''llzMed:3'
fileappend 'logName$' 'time1:3''tab$''time2:3''tab$''ttxMed:3''tab$''ttzMed:3''tab$''tdxMed:3''tab$''tdzMed:3''tab$''ulxMed:3''tab$''ulzMed:3''tab$''llxMed:3''tab$''llzMed:3''newline$'

analyzed=analyzed+1

plus 'tor3'
Remove
goto WAIT

procedure split .str$ .delimiter$
	.num = 1
	.arr$[.num] = .str$
	repeat
		.lastValue$ = .arr$[.num]
		.delimiterPos = index_regex(.lastValue$,.delimiter$)
		if .delimiterPos <> 0
			.arr$[.num] = left$(.lastValue$,.delimiterPos-1)
			.num += 1
			.arr$[.num] = replace_regex$(right$(.lastValue$,length(.lastValue$)-.delimiterPos+1),.delimiter$,"",1)
		endif
	until .delimiterPos = 0
endproc