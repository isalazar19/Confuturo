select b.*,nat.*,
round(((months_between(add_months(to_date('20231231','yyyymmdd'),1), nat_fec_nacim)) / 1), 0),
round(((months_between(add_months(to_date('20231231','yyyymmdd'),1), nat_fec_nacim)) / 1), 1),
round(((months_between(add_months(to_date('20231231','yyyymmdd'),1), nat_fec_nacim)) / 1), 2),
round(((months_between(add_months(to_date('20231231','yyyymmdd'),1), nat_fec_nacim)) / 1), 3)
from rentarsv.beneficiarios b,rentarsv.persnat nat where
(b.ben_relacion in (3, 5) and b.ben_ind_der_re <> 1 and
 (b.ben_invalido in (2) and nat_fec_inval is null and
 nat.nat_id = ben_beneficiario and
 round(((months_between(add_months(to_date('20231231','yyyymmdd'),1), nat_fec_nacim)) / 1), 3) >= 288 and
 round(((months_between(add_months(to_date('20231231','yyyymmdd'),1), nat_fec_nacim)) / 1), 3) < 289));
