

* Enter the filepath to .csv file in the local variable. 
local path = "/Users/allanwheeler/Documents/Projects/Personal/preppin_data/2022/week_1"

import delimited "`path'/PD 2022 Wk 1 Input - Input.csv", clear

generate Pupils_Name = pupillastname + ", " + pupilfirstname
generate Parental_Name = parentalcontactname_2 + ", " + parentalcontactname_1
generate Parental_Contact_Email_Address = parentalcontactname_1 + "." + parentalcontactname_2 + "@" + preferredcontactemployer + ".com"
generate dateofbirth2 = date(dateofbirth, "MDY")
	format dateofbirth2 %tdCCYY-NN-DD
generate Academic_Year = .
	replace Academic_Year = 1 if dateofbirth2 >= td(01sep2014)
	replace Academic_Year = 2 if dateofbirth2 >= td(01sep2013) & dateofbirth2 <= td(01sep2014)
	replace Academic_Year = 3 if dateofbirth2 >= td(01sep2012) & dateofbirth2 <= td(01sep2013)
	replace Academic_Year = 4 if dateofbirth2 >= td(01sep2011) & dateofbirth2 <= td(01sep2012)
	
keep Academic_Year Pupils_Name Parental_Name Parental_Contact_Email_Address
order Academic_Year, first

save "`path'/week1.dta", replace


