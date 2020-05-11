#!/bin/bash
#SBATCH --job-name=testing_vqtl
#SBATCH --account=sens2017519
#SBATCH --time=00-24:00:00
#SBATCH --ntasks=16
#SBATCH -C mem256GB
#SBATCH -p node

~/osca/osca_Linux \
--vqtl \
--bfile /proj/sens2017519/nobackup/b2016326_nobackup/private/arvhar/ukb_imp_chr22_v3_conv_excl \
--pheno /proj/sens2017519/nobackup/b2016326_nobackup/private/arvhar/ukb_phen_FID.phen \
--thread-num 16 \
--out testing_vqtl



