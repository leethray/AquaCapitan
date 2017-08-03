
-- First we  initialize a few variables
-- TODO remove the unused ones
set myEvList to {}
set myTaskList to {}
set theTextList to ""
set theError to 0
set theImfile to ""
set theDocRef to 0
set theImFileName to ""
set gEntourageWasRunning to true
set gMinimunPBar to 0.005
set gProgression to 0
set gNTasks to 0
set gNEvents to 0

-- Creating a new calendar in iCal 

tell application "iCal"
	activate
	make new calendar with properties {title:"Entourage"}
	delay (0.5)
end tell

-- Getting the events from Entourage (not there is no way to choose which Entourage in this one)
try
	if (theError of me is equal to 0) then
		tell application "Microsoft Entourage"
			--log "Entourage import, start getting events " & (current date)
			activate
			
			set myEEvents to get every event
			set my gNEvents to count (myEEvents)
			set myTasks to tasks where its completed is equal to false
			set my gNTasks to count (myTasks)
			
			if my gNTasks is not equal to 0 then
				set entIncrement to (round ((count myEEvents) / 40) rounding up)
			else
				set entIncrement to (round ((count myEEvents) / 80) rounding up)
			end if
			set progEntIdx to 0
			
			repeat with aEEvent in myEEvents
				set tmpVal to {}
				-- append raw properties to the list as list of records have their own syntax
				set tmpVal to tmpVal & (get subject of aEEvent as Unicode text)
				
				set begDate to (get start time of aEEvent)
				set endDate to (get end time of aEEvent)
				set addFlag to (get all day event of aEEvent)
				if addFlag is equal to false then
					if (endDate - begDate) > 24 * hours then
						set addFlag to true
						set time of begDate to 0
						set time of endDate to 0
						set dday to day of endDate
						set day of endDate to dday + 1
					end if
				end if
				set tmpVal to tmpVal & addFlag
				set tmpVal to tmpVal & begDate
				set tmpVal to tmpVal & endDate
				
				set tmpVal to tmpVal & (get recurring of aEEvent)
				set tmpVal to tmpVal & (get recurrence of aEEvent)
				set tmpVal to tmpVal & (get location of aEEvent as Unicode text)
				set tmpVal to tmpVal & (get content of aEEvent as Unicode text)
				set (myEvList of me) to (myEvList of me) & tmpVal
				set progEntIdx to progEntIdx + 1
				if progEntIdx is equal to entIncrement then
					set progEntIdx to 0
				end if
			end repeat
			
			--log "Entourage import, start getting tasks " & (current date)
			if (my gNTasks) is not equal to 0 then
				--if count task is not equal to 0 then
				set my gProgression to 0.3
				set entIncrement to (round ((my gNTasks) / 40) rounding up)
				
				set progEntIdx to 0
				
				repeat with aTask in myTasks
					set tmpVal to {}
					set tmpVal to tmpVal & (get the name of aTask as Unicode text)
					set tmpVal to tmpVal & (get the due date of aTask)
					set tmpPri to the priority of aTask
					if tmpPri is equal to highest then
						set tmpVal to tmpVal & 1
					else if tmpPri is equal to high then
						set tmpVal to tmpVal & 4
					else if tmpPri is equal to low then
						set tmpVal to tmpVal & 7
					else if tmpPri is equal to lowest then
						set tmpVal to tmpVal & 7
					else
						set tmpVal to tmpVal & 0
					end if
					set tmpVal to tmpVal & (get content of aTask as Unicode text)
					
					set (myTaskList of me) to (myTaskList of me) & tmpVal
					set progEntIdx to progEntIdx + 1
					
					if progEntIdx is equal to entIncrement then
						set progEntIdx to 0
					end if
				end repeat
			end if
		end tell
	end if
	
	--correct the recurrences
	set parsidx to 0
	repeat my gNEvents times
		set entRule to (item (parsidx + 6) of (myEvList of me))
		if (entRule) is not equal to "" then
			set offUntil to offset of "UNTIL=" in entRule
			if offUntil is not equal to 0 then
				set icalRule to text 1 through (offUntil + 5) of entRule
				set remainText to (text (offUntil + 6) through (length of (entRule)) of entRule)
				set endPos to offset of ";" in remainText
				set untilDateStr to (text 1 through (endPos - 1) of remainText) as string
				set untilYear to (items 1 through 4 of untilDateStr) as string
				set untilMonth to (items 5 through 6 of untilDateStr) as string
				set untilDay to (items 7 through 8 of untilDateStr) as string
				
				set untilDate to current date
				set day of untilDate to untilDay
				set year of untilDate to untilYear
				
				if untilMonth is equal to "01" then
					set month of untilDate to January
				else if untilMonth is equal to "02" then
					set month of untilDate to February
				else if untilMonth is equal to "03" then
					set month of untilDate to March
				else if untilMonth is equal to "04" then
					set month of untilDate to April
				else if untilMonth is equal to "05" then
					set month of untilDate to May
				else if untilMonth is equal to "06" then
					set month of untilDate to June
				else if untilMonth is equal to "07" then
					set month of untilDate to July
				else if untilMonth is equal to "08" then
					set month of untilDate to August
				else if untilMonth is equal to "09" then
					set month of untilDate to September
				else if untilMonth is equal to "10" then
					set month of untilDate to October
				else if untilMonth is equal to "11" then
					set month of untilDate to November
				else if untilMonth is equal to "12" then
					set month of untilDate to December
				end if
				
				set newUntilDate to untilDate + 1 * days
				set newUntiDateStr to ((year of newUntilDate) as string)
				if (month of newUntilDate) as string is equal to "January" then
					set newUntiDateStr to newUntiDateStr & "01"
				else if (month of newUntilDate) as string is equal to "February" then
					set newUntiDateStr to newUntiDateStr & "02"
				else if (month of newUntilDate) as string is equal to "March" then
					set newUntiDateStr to newUntiDateStr & "03"
				else if (month of newUntilDate) as string is equal to "April" then
					set newUntiDateStr to newUntiDateStr & "04"
				else if (month of newUntilDate) as string is equal to "May" then
					set newUntiDateStr to newUntiDateStr & "05"
				else if (month of newUntilDate) as string is equal to "June" then
					set newUntiDateStr to newUntiDateStr & "06"
				else if (month of newUntilDate) as string is equal to "July" then
					set newUntiDateStr to newUntiDateStr & "07"
				else if (month of newUntilDate) as string is equal to "August" then
					set newUntiDateStr to newUntiDateStr & "08"
				else if (month of newUntilDate) as string is equal to "September" then
					set newUntiDateStr to newUntiDateStr & "09"
				else if (month of newUntilDate) as string is equal to "October" then
					set newUntiDateStr to newUntiDateStr & "10"
				else if (month of newUntilDate) as string is equal to "November" then
					set newUntiDateStr to newUntiDateStr & "11"
				else if (month of newUntilDate) as string is equal to "December" then
					set newUntiDateStr to newUntiDateStr & "12"
				end if
				
				if day of newUntilDate < 10 then
					set newUntiDateStr to newUntiDateStr & "0" & day of newUntilDate
				else
					set newUntiDateStr to newUntiDateStr & day of newUntilDate
				end if
				set icalRule to icalRule & newUntiDateStr & (items 9 through (length of untilDateStr) of untilDateStr) as string
				set icalRule to icalRule & (text endPos through (length of (remainText)) of remainText)
				set (item (parsidx + 6) of (myEvList of me)) to icalRule
			end if
		end if
		set parsidx to parsidx + 8
	end repeat
	-- put the events in iCal
	
	tell application "iCal"
		set my gProgression to 0.5
		set progression to my gProgression
		activate
		log "Entourage import, storing events in iCal " & (current date)
		set parsidx to 0
		set numEvents to (count (myEvList of me)) / 8
		
		if my gNTasks is not equal to 0 then
			set entIncrement to (round ((my gNEvents) / 50) rounding up)
		else
			set entIncrement to (round ((my gNEvents) / 100) rounding up)
		end if
		
		set progEntIdx to 0
		
		repeat numEvents times
			set evtSummary to (item (parsidx + 1) of (myEvList of me)) as Unicode text
			set evtStartDate to item (parsidx + 3) of (myEvList of me)
			set evtLocation to (item (parsidx + 7) of (myEvList of me))
			set evtNotes to (item (parsidx + 8) of (myEvList of me))
			set isAD to (item (parsidx + 2) of (myEvList of me)) as boolean
			
			if isAD is equal to true then
				set evtADD to true
				set evtEndDate to item (parsidx + 4) of (myEvList of me)
				if ((item (parsidx + 5) of (myEvList of me)) is equal to true) then
					set evtRecRule to (item (parsidx + 6) of (myEvList of me))
					--my translateReccurenceRule
					set myNewADEvent to make new event at the end of events of last calendar
					tell myNewADEvent
						set summary to evtSummary
						set start date to evtStartDate
						set end date to evtEndDate - 1
						set allday event to true
						set recurrence to evtRecRule
						set description to evtNotes
						set location to evtLocation
					end tell
				else
					set myNewADEvent to make new event at the end of events of last calendar
					tell myNewADEvent
						set summary to evtSummary
						set start date to evtStartDate
						set end date to evtEndDate - 1
						set allday event to true
						set description to evtNotes
						set location to evtLocation
					end tell
				end if
			else
				set evtEndDate to item (parsidx + 4) of (myEvList of me)
				if ((item (parsidx + 5) of (myEvList of me)) is equal to true) then
					set evtRecRule to (item (parsidx + 6) of (myEvList of me))
					-- my translateReccurenceRule
					make new event with properties {summary:evtSummary, start date:evtStartDate, end date:evtEndDate, recurrence:evtRecRule, location:evtLocation, description:evtNotes} at the end of events of last calendar
				else
					make new event with properties {summary:evtSummary, start date:evtStartDate, end date:evtEndDate, location:evtLocation, description:evtNotes} at the end of events of last calendar
				end if
			end if
			
			
			set parsidx to parsidx + 8
			set progEntIdx to progEntIdx + 1
			
			if progEntIdx is equal to entIncrement then
				set progEntIdx to 0
				set my gProgression to ((my gProgression) + gMinimunPBar)
				set progression to my gProgression
			end if
		end repeat
		--	log "Entourage import : end of events" & (current date)
		if my gNTasks is not equal to 0 then
			set my gProgression to 0.75
			set progression to my gProgression
			set parsjdx to 0
			set entIncrement to (round ((my gNTasks) / 50) rounding up)
			set progEntIdx to 0
			repeat my gNTasks times
				set tdSummary to (item (parsjdx + 1) of (myTaskList of me)) as Unicode text
				--				set tdPriority to no priority -- (item (parsjdx + 3) of (myTaskList of me)) as integer
				set msPriority to (item (parsjdx + 3) of (myTaskList of me)) as integer
				set tdContent to (item (parsjdx + 4) of (myTaskList of me)) as Unicode text
				if msPriority is equal to 1 then
					set tdPriority to high priority
				else if msPriority is equal to 4 then
					set tdPriority to medium priority
				else if msPriority is equal to 7 then
					set tdPriority to low priority
				else if msPriority is equal to 0 then
					set tdPriority to no priority
				end if
				set tdDueDate to item (parsjdx + 2) of (myTaskList of me)
				set yearPosDueDate to year of tdDueDate
				--Entourage marks ToDo with no due date to 1904
				if yearPosDueDate is not equal to 1904 then
					make new todo with properties {summary:tdSummary, priority:tdPriority, due date:tdDueDate, description:tdContent} at the end of todos of last calendar
				else
					make new todo with properties {summary:tdSummary, priority:tdPriority, description:tdContent} at the end of todos of last calendar
				end if
				set parsjdx to parsjdx + 4
				set progEntIdx to progEntIdx + 1
				
				if progEntIdx is equal to entIncrement then
					set progEntIdx to 0
					set my gProgression to ((my gProgression) + gMinimunPBar)
					set progression to my gProgression
				end if
			end repeat
		end if
		set progression to 1
		delay 0.9
	end tell
on error errorMessageVariable
	log errorMessageVariable
	if errorMessageVariable is equal to "Cancel Operation" then
		tell application "iCal"
			log "Operation cancelled"
		end tell
	end if
end try

--tell application "iCal"
--	dismiss progress
--end tell

-- reput Entourage to its initial state
--if (gEntourageWasRunning of me) is equal to false then
tell application "Microsoft Entourage" to quit
--end if

on translateReccurenceRule(entRule)
	set icalRule to entRule
	
	set offUntil to offset of "UNTIL=" in entRule
	if offUntil is not equal to 0 then
		set icalRule to text 1 through (offUntil + 5) of entRule
		set remainText to (text (offUntil + 6) through (length of (entRule)) of entRule)
		set endPos to offset of ";" in remainText
		set untilDateStr to (text 1 through (endPos - 1) of remainText) as string
		log untilDateStr
		set untilYear to (items 1 through 4 of untilDateStr) as string
		set untilMonth to (items 5 through 6 of untilDateStr) as string
		set untilDay to (items 7 through 8 of untilDateStr) as string
		set untilDate to date (untilMonth & "/" & untilDay & "/ " & untilYear)
		set newUntilDate to untilDate + 1 * days
		set newUntiDateStr to ((year of newUntilDate) as string)
		if (month of newUntilDate) as string is equal to "January" then
			set newUntiDateStr to newUntiDateStr & "01"
		else if (month of newUntilDate) as string is equal to "February" then
			set newUntiDateStr to newUntiDateStr & "02"
		else if (month of newUntilDate) as string is equal to "March" then
			set newUntiDateStr to newUntiDateStr & "03"
		else if (month of newUntilDate) as string is equal to "April" then
			set newUntiDateStr to newUntiDateStr & "04"
		else if (month of newUntilDate) as string is equal to "May" then
			set newUntiDateStr to newUntiDateStr & "05"
		else if (month of newUntilDate) as string is equal to "June" then
			set newUntiDateStr to newUntiDateStr & "06"
		else if (month of newUntilDate) as string is equal to "July" then
			set newUntiDateStr to newUntiDateStr & "07"
		else if (month of newUntilDate) as string is equal to "August" then
			set newUntiDateStr to newUntiDateStr & "08"
		else if (month of newUntilDate) as string is equal to "September" then
			set newUntiDateStr to newUntiDateStr & "09"
		else if (month of newUntilDate) as string is equal to "October" then
			set newUntiDateStr to newUntiDateStr & "10"
		else if (month of newUntilDate) as string is equal to "November" then
			set newUntiDateStr to newUntiDateStr & "11"
		else if (month of newUntilDate) as string is equal to "December" then
			set newUntiDateStr to newUntiDateStr & "12"
		end if
		
		if day of newUntilDate < 10 then
			set newUntiDateStr to newUntiDateStr & "0" & day of newUntilDate
		else
			set newUntiDateStr to newUntiDateStr & day of newUntilDate
		end if
		set icalRule to icalRule & newUntiDateStr & (items 9 through (length of untilDateStr) of untilDateStr) as string
		set icalRule to icalRule & (text endPos through (length of (remainText)) of remainText)
	end if
	
	return icalRule
end translateReccurenceRule

on getValueForCalRecRule(aRecRule, aRuleName)
	set ruleOffset to offset of aRuleName in aRecRule
	if ruleOffset is not equal to 0 then
		if (character (ruleOffset + (count of aRuleName)) of aRecRule) is equal to "=" then
			set remainStr to text (ruleOffset + (count of aRuleName) + 1) through (count of aRecRule) of aRecRule
			set endPos to offset of ";" in remainStr
			set result to text 1 through (endPos - 1) of remainStr
			return result
		else
			return ""
		end if
	else
		return ""
	end if
end getValueForCalRecRule

