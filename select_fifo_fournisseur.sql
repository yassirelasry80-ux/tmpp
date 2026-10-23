select 
    g.vcrnum_0                                  as bon_livraison,
    g.vcrlin_0                                  as ligne_bl,
    g.iptdat_0                                  as date_livraison,
    g.itmref_0                                  as article,
    g.qtypcu_0                                  as qte_livree,
    g.fifo                                      as valeur_fifo,
    rec.bpsnum_0                                as code_fournisseur,
    bp.bpcnam_0                                 as nom_fournisseur,
    rec.pthnum_0                                as dernier_bon_reception,
    rec.rcpdat_0                                as date_reception,
    rec.netpri_0                                as dernier_prix_achat
from stojou_cmgp_Global_D g

-- Jointure latérale pour chercher la DERNIÈRE réception de l'article dans preceiptd
left join (
    select *
    from (
        select 
            p.itmref_0,
            p.bpsnum_0,
            p.pthnum_0,
            p.rcpdat_0,
            p.netpri_0,
            row_number() over (partition by p.itmref_0 order by p.rcpdat_0 desc) as rn
        from preceiptd p
        where p.netpri_0 > 0  -- ignore les réceptions à prix nul
    )
    where rn = 1
) rec on rec.itmref_0 = g.itmref_0

-- Récupération du nom du fournisseur dans la table des tiers
left join bpartner bp on bp.bprnum_0 = rec.bpsnum_0

where g.trstyp_0 = 4 
  and (g.fifo is null or g.fifo = 0)
order by g.iptdat_0 desc;
