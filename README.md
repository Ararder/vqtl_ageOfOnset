In this repository i show the code and analysis pipeline used for a genome-wide vQTL analysis on age of onset for depression, on the UK Biobank pioneered by Wang et al (https://advances.sciencemag.org/content/5/8/eaaw3538).
For more information about the vQTL method, checkout the paper!



Step 1)
The UK Biobank data was stored on the computing cluster UPPMAX in bgen v1.2 format.
The software used for the vQTL analysis, OSCA, requires the input format to be in plink binary format (.bed , .bim, .fam).

The first step was therefore to convert from bgen to plink format. To do this, we generated a .sample file as it's needed for
plink2 to convert between filetypes.
OSCA doesnt not accept duplicate SNPs, and we therefore removed duplicate SNPs in the conversion step.

```bash
#!/bin/bash
#SBATCH --job-name=converting_to_pbinary
#SBATCH --account=sens2017519
#SBATCH --time=00-24:00:00
#SBATCH --partition=core
#SBATCH --ntasks=16

module load bioinfo-tools
module load plink2

plink2 \
--bgen /castor/project/proj_nobackup/b2016326_nobackup/UKBB/new_release_20180313/EGAD00010001474_decrypted/ukb_imp_chr3_v3.bgen \
--make-bed \
--out /proj/sens2017519/nobackup/b2016326_nobackup/private/arvhar/ukb_imp_chr3_v3_conv_excl \
--threads 16 \
--rm-dup exclude-all \
--sample ~/conversion/ukb2222_imp_v3_addsex.sample
```






