#!/bin/bash
ssh deploy@som-production.shopofme.com << 'ENDSSH'
export PGPASSWORD="safdg87gdfsgsd8"
mkdir shopofme_db_dumps
cd shopofme_db_dumps 
pg_dump -U shopofme_production shopofme_production -f current.sql
tar jcvf current.tar.bz2 current.sql
ENDSSH
DATE_STAMP=$(date +%Y%m%d_%H%M%S)
echo $DATE_STAMP
scp deploy@som-production.shopofme.com:/home/deploy/shopofme_db_dumps/current.tar.bz2 ./$DATE_STAMP.tar.bz2
rm current.sql
tar jxvf ./$DATE_STAMP.tar.bz2
cp current.sql $DATE_STAMP.sql 
