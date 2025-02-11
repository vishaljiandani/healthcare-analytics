with cpt_totals as (
      select cpt
            ,count(*) as cpt_count -- gets most common procedures
      from `all_data.encounters_details`
      group by cpt
)

, cpt_ranking as (
      select npi
            ,top_procedure
      from (
            select e.npi
                  ,e.cpt as top_procedure
                  ,dense_rank() over (partition by npi order by (count(a.encounter_id)/count(*)) asc, count(*) desc, c.cpt_count desc) as rank_num
            from `all_data.encounters_details` e
            left join `all_data.adverse_events` a
            on a.encounter_id = e.encounter_id
            left join cpt_totals as c
            on c.cpt = e.cpt
            group by e.npi, e.cpt, c.cpt_count
            order by e.npi
      )
      where rank_num = 1
)

, in_network_employers as (
      select employer_id
            ,trim(npi) as npi
      from `all_data.employer_in_network`,
      unnest(split(in_network_npis, ',')) as npi
)

, total_referrals as (
  select procedure
      ,zip
      ,count(patient_id) as incoming_demand
from `all_data.referrals`
group by 1, 2
order by procedure, zip
)

select e.npi
      ,coalesce(p.provider_name, 'Ortega-Garcia, Jose-Raul') as provider_name -- accounting for missing npi
      ,case when e.npi = '1992787402' then '334113504' else p.zip end as provider_zip
      ,c.top_procedure
      ,count(distinct e.encounter_id) as total_encounters
      ,ref.incoming_demand
      ,round(avg(cast(e.paid_amount as int)), 0) as provider_avg_cost
      ,count(distinct a.encounter_id) as adverse_event_count
      ,round((count(distinct e.encounter_id)-count(distinct a.encounter_id))/count(distinct e.encounter_id) * 100, 1) as provider_success_rate
      ,count(distinct net.employer_id) as in_network_employers
from `all_data.encounters_details` e
left join `all_data.providers` p
on p.npi = e.npi
left join `all_data.adverse_events` a
on a.encounter_id = e.encounter_id
left join cpt_ranking as c
on c.npi = e.npi
left join in_network_employers net
on net.npi = e.npi
left join total_referrals ref
on ref.procedure = c.top_procedure and ref.zip = p.zip
group by 1, 2, 3, 4, ref.incoming_demand