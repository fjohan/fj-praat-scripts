# praatmbrola.psc
#
# /d/ Produces a *.pho file, calls mbrola and returns a sound. The segments and durations are taken from a TextGrid-object and pitch information from a Sound object.
######################################################################

#form Praat mbrola
#	choice Mbrola_database 1
#		button sw1 (Lukas, male Swedish)
#		button sw2 (Ofelia, female Swedish)
#		button en1
#endform

mbrola_database = 1

nsel = numberOfSelected("Sound")
ntg = numberOfSelected("TextGrid")
nsp = numberOfSelected("PitchTier")

if (ntg != 1 || nsel != 1) && (ntg != 1 && nsp != 1)
	exit Please select exactly one TextGrid, plus either exactly one Sound or exactly one PitchTier.
endif

# mbrola should be in the path
mbrolaprog$ = "c:\cygwin\usr\local\bin\mbrola"
if mbrola_database == 1
	#mbrolapath$ = "/usr/local/speech/mbrola/sw1/sw1"
	mbrolapath$ = "c:\EST\festival\lib\voices\swedish\sw2_mbrola\sw2"
elsif mbrola_database == 2
	mbrolapath$ = "/home/spraktek/sw2"
elsif mbrola_database == 3
	mbrolapath$ = "/usr/local/speech/mbrola/en1/en1"
endif

wavtmp$ = environment$("TMP")+"\praatmbrola.wav"
photmp$ = environment$("TMP")+"\praatmbrola.pho"

# quick'n dirty
#double = 1

clearinfo
if nsel > 0
	s1 = selected("Sound")
endif
if nsp > 0
	pt1 = selected("PitchTier")
endif
tg1 = selected("TextGrid")

if nsp != 1
	select 's1'
	To Pitch (ac)... 0.01 75 15 no 0.03 0.45 0.01 0.35 0.14 600
	p1 = selected("Pitch")
	Down to PitchTier
	pt1 = selected("PitchTier")
	Stylize... 1 Semitones
	select 'p1'
	Remove
endif

select 'pt1'
npp = Get number of points

select 'tg1'
niv = Get number of intervals... 1
for i from 1 to niv
	select 'tg1'
	labi$ = Get label of interval... 1 'i'
	if labi$ != ""
	sti = Get starting point... 1 'i'
	eni = Get end point... 1 'i'
	dur = round((eni - sti) * 1000)

	#dur = 100
	print 'labi$' 'dur''tab$'
	select 'pt1'
	for j from 1 to npp
		tpp = Get time from index... 'j'
		if tpp > sti && tpp < eni
			pc = round(((tpp - sti) / dur) * 100000)
			hz = Get value at index... 'j'
			hzr = round(hz)
			#if double = 1
			#	hzr = hzr * 2
			#	hzr = 220
			#endif
			print 'pc' 'hzr''tab$'
		endif
	endfor
	print 'newline$'
	endif
endfor

head$ = "; created with praatmbrola.psc"

head$ > 'photmp$'
newline$ >> 'photmp$'
fappendinfo 'photmp$'

exit
pause 
system 'mbrolaprog$' 'mbrolapath$' 'photmp$' 'wavtmp$'
Read from file... 'wavtmp$'

filedelete 'photmp$'
filedelete 'wavtmp$'



