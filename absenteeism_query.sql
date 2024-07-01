-- CREATE A JOIN TABLE --

select * from absenteeism as a
left join compensation as b on a.ID = b.ID
left join reasons as r on a.`Reason for absence` = r.`Number`;


-- find the healthiest employees for the bonus --

select * from absenteeism
where `Social drinker` = 0 and 
`Social smoker` = 0 and 
`Body mass index` < 25 and
`Absenteeism time in hours` < (select avg(`Absenteeism time in hours`) from absenteeism);


-- compensation rate increase for non-smokers --
select count(*) as count_of_nonsmokers from absenteeism
where `Social smoker` = 0;
# thus, the number of non-smokers is 686
# total available bonus amount for non-smokers is $983,221
# total working hours of non-smokers per year is 686x5x8x52 = 1,426,880 hours
# bonus per each working hour is $0,68
# total yearly bonus per employee is 0.68x1,426,880 / 686 = $1414,4

-- optimize the compensation query --

select a.ID,  r.Reason, a.`Month of absence`, 
case when `Month of absence` in (12,1,2) then 'Winter'
	 when `Month of absence` in (3,4,5) then 'Spring'
	 when `Month of absence` in (6,7,8) then 'Summer'	
     when `Month of absence` in (9,10,11) then 'Fall'
     else 'Unknown' end as season_name,
     
a.`Day of the week`, a.`Body mass index`,

case when `Body mass index` < 18.5 then 'underweight'
     when `Body mass index` between 18.5 and 25 then 'healthy weight'
     when `Body mass index` between 25 and 30 then 'overweight'
  	 when `Body mass index` > 30 then 'obese'
     else 'Unknown' end as BMI_Category,
     
case when Age between 0 and 16 then 'child'
     when Age between 16 and 30 then 'yound adult'
     when Age between 30 and 45 then 'middle-aged adult'
  	 when Age>45 then 'old-aged adult'
     else 'Unknown' end as Age_Category,

a.Age, a.Education, a.`Social drinker`, a.`Social smoker`, a.Height, a.Weight, a.Son, a.Pet, a.`Work load Average/day`, a.`Distance from Residence to Work`
from absenteeism as a
left join compensation as b on a.ID = b.ID
left join reasons as r on a.`Reason for absence` = r.`Number`;
