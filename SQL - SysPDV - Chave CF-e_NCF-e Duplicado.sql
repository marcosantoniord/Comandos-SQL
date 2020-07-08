select trnchvcfe, trndat, count (*) as total
from transacao
where trndat >='01/10/2019'
and TRNTIP = '1'
and TRNIMPCOD = '98'
group by TRNCHVCFE, trndat
having count (*) >='2'
order by total desc, trndat asc