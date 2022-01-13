// Variables
local path = "preppin_data/2022/week_2"
local current_year = "2022"

// Input the data set
import delimited "`path'/PD 2022 Wk 1 Input - Input.csv", clear

// Format the pupil's name in First Name Last Name format
// Limitation: Stata does not allow for spaces or special characters in column names
generate Pupils_Name = pupilfirstname + " " + pupillastname

// Create the date for the pupil's birthday in calendar year 2022
generate date_length = strlen(dateofbirth) 

generate This_Years_Birthday = ""
	forvalues i = 8/10 {
		replace This_Years_Birthday = substr(dateofbirth, 1, `i' - 4) + "`current_year'" if date_length == `i'
	}

// Find month
generate month_number = month(date(This_Years_Birthday, "MDY"))
generate Month = ""
	replace Month = "January" 	if month_number == 1
	replace Month = "February" 	if month_number == 2
	replace Month = "March" 	if month_number == 3
	replace Month = "April" 	if month_number == 4
	replace Month = "May" 		if month_number == 5
	replace Month = "June" 		if month_number == 6
	replace Month = "July" 		if month_number == 7
	replace Month = "August" 	if month_number == 8
	replace Month = "September" if month_number == 9
	replace Month = "October" 	if month_number == 10
	replace Month = "November" 	if month_number == 11
	replace Month = "December" 	if month_number == 12

// Find day of the week
// Account for weekends and move them to Friday
generate day_of_week = dow(date(This_Years_Birthday, "MDY"))
	replace day_of_week = 5 if day_of_week == 0 | day_of_week == 6
generate Cake_Needed_On = ""
	replace Cake_Needed_On = "Monday" 	 if day_of_week == 1
	replace Cake_Needed_On = "Tuesday" 	 if day_of_week == 2
	replace Cake_Needed_On = "Wednesday" if day_of_week == 3
	replace Cake_Needed_On = "Thursday"  if day_of_week == 4
	replace Cake_Needed_On = "Friday" 	 if day_of_week == 5

// Create a two-condition count (IN PROGRESS)
egen BDs_per_Weekday_and_Month = count(id), by (Month Cake_Needed_On)

// Rename, order, and remove uneccessary columns
rename dateofbirth Date_of_Birth
order Pupils_Name Date_of_Birth This_Years_Birthday Month Cake_Needed_On BDs_per_Weekday_and_Month
keep Pupils_Name Date_of_Birth This_Years_Birthday Month Cake_Needed_On BDs_per_Weekday_and_Month

// Export to excel
export delimited "`path'/PD 2022 Wk 2 Output.csv", replace




