SELECT pat.patient_id
      ,pat.gender
      ,pat.birth_date
      ,enc.cpt as procedure
      ,pro.zip
      ,"Not Available" as employer_id
FROM `all_data.patients` pat
left join `all_data.encounters_details` enc
on enc.patient_id = pat.patient_id
left join `all_data.providers` pro
on pro.npi = enc.npi

union all

select patient_id
      ,gender
      ,birth_date
      ,procedure
      ,zip
      ,employer_id
from `all_data.referrals`