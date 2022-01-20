
// file path
local path = "preppin_data/2022/week_3"

// grades dataset
import delimited "`path'/PD 2022 WK 3 Grades.csv", clear

local allvar maths english spanish science art history geography

egen Students_Avg_Score = rowmean(`allvar')
	replace Students_Avg_Score = round(Students_Avg_Score, 0.1)

foreach v in `allvar' {
	generate passed_`v' = 1 if `v' >= 75
	drop `v'
	rename passed_`v' `v'
}
	
egen Passed_Subjects = rowtotal(`allvar')
	
tempfile grades
save `grades'

// merge with week 1's dataset
import delimited "`path'/PD 2022 Wk 1 Input - Input.csv", clear
	rename (id gender) (studentid Gender)

merge 1:1 studentid using `grades'

rename studentid Student_ID
keep Passed_Subjects Students_Avg_Score Student_ID Gender
order Passed_Subjects Students_Avg_Score Student_ID Gender

// export to .dta and .csv
save "`path'/PD 2022 Wk 3 Output.dta", replace
export delimited "`path'/PD 2022 Wk 3 Output.csv", replace




