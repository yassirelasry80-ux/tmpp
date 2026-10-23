-- Code fournisseur preceiptd par ligne de la table stojou_cmgp_Global_D (pour trstyp_0 = 4 et FIFO nul/0)

select 
    g.*,
    (select max(p.bpsnum_0) keep (dense_rank last order by p.rcpdat_0)
     from preceiptd p 
     where p.itmref_0 = g.itmref_0 
       and p.rcpdat_0 <= g.iptdat_0) as code_fournisseur
from stojou_cmgp_Global_D g
where g.trstyp_0 = 4 
  and (g.fifo is null or g.fifo = 0);
