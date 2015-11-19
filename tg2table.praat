# This is developed using praat version 5.4.01
form TextGrid2Table
	comment This script converts TextGrids to tables.
	comment Output is printed both to the info window and to the file given in 'Outfile'.
	sentence Path /home/user
	word Extension *.TextGrid
	word Outfile all.txt
endform

clearinfo
if right$(path$,1) != "/"
	path$=path$+"/"
endif
outfilename$=path$+outfile$

searchPattern$=path$+extension$

fl=Create Strings as file list: "fileList", searchPattern$
nStr=Get number of strings

clearinfo

writeInfoLine: outfilename$+newline$,"-----------------------------"
appendInfoLine: "filename,tmin,tier,text,tmax"
writeFileLine: outfilename$, "filename,tmin,tier,text,tmax"

for i from 1 to nStr
	select 'fl'
	current$=Get string: i
	filename$=path$+current$
	tg1=Read from file... 'filename$'

	Down to Table: "no", 6, "yes", "no"
	text$=List: "no"
	text_r1$=replace_regex$(text$,".*"+newline$,"",1)
	text_r2$=replace_regex$(text_r1$,tab$,",",0)
	text_r3$=replace_regex$(text_r2$,"^(.)",current$+",\1",0)
	appendInfo: text_r3$
	appendFile: outfilename$, text_r3$
	plus 'tg1'
	Remove
endfor

select 'fl'
Remove
