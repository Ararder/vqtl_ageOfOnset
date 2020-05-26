# Introduction
In this repository i show the code and analysis pipeline used for a genome-wide vQTL analysis on age of onset for depression, on the UK Biobank pioneered by Wang et al (https://advances.sciencemag.org/content/5/8/eaaw3538).
For more information about the vQTL method, checkout the paper!



## Step 1)
The UK Biobank data was stored on the computing cluster UPPMAX in bgen v1.2 format.
The software used for the vQTL analysis, OSCA, requires the input format to be in plink binary format (.bed , .bim, .fam).

The first step was therefore to convert from bgen to plink format. To do this, we generated a .sample file as it's needed for
plink2 to convert between filetypes.
OSCA does not accept duplicate SNPs, and we therefore removed duplicate SNPs in the conversion step.
This was done for each of the chromosomes.

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

## Step 2)
With the data in correct format, we used the --vqtl command with OSCA.
The code was duplicated for each chromosome, with input data changed, and output named brit_chrX.vqtl.
For computing power, we used 16 cores with 256GB ram each. We excluded SNPs with MAF < 0.05. This resulted in a lot less SNPs to analyze. Largest memory usage was for chr2, with 178.5GB in ram used. Method used was Levene's test with the mean.
Running time was between 90 minutes and 10.5 hours, depending on chromosome.


```bash
#!/bin/bash
#SBATCH --job-name=testing_vqtl
#SBATCH --account=sens2017519
#SBATCH --time=00-24:00:00
#SBATCH --ntasks=16
#SBATCH -C mem256GB
#SBATCH -p node

/home/arvhar/programs/osca/osca_Linux  \
--vqtl \
--bfile /proj/sens2017519/nobackup/b2016326_nobackup/private/arvhar/ukb_imp_chr3_v3_conv_excl \
--vqtl-mtd 1 \
--pheno /home/arvhar/samples_and_pheno/pheno_only_brits \
--maf 0.05  \
--thread-num 16 \
--out brit_chr3_vqtl
```


## Step 3)
The results were bound into one dataframe using R. The top 10 SNPs were extracted and used in an linear interaction model.
The full code can be found in the gei_interaction folder. The fifty linear model were fit with the following code, where
data[[17] is age of onset


### A) - extract allele count for the top 10 snps.
Plink was used to extract genetic data for the 10 SNPS. the AD format is good as it can be read in by R.

```bash
module load bioinfo-tools
module load plink

plink \
--bfile /proj/sens2017519/nobackup/b2016326_nobackup/private/arvhar/ukb_imp_chr3_v3_conv_excl \
--snps rs347074 \
--keep /home/arvhar/samples_and_pheno/only_brits.list \
--recodeAD \
--out ~/top_snps/3chr_topsnp.txt \

```




### B) Linear interaction model in R

```R
for(i in 1:length(snps)) {
  snp <- snps[i]
  for(f in 1:length(phenotypes)) {
    pheno <- phenotypes[f]
    coefs <- tibble()
    c <- c+1
    model <- lm(data[[17]] ~ data[[snp]] + data[[pheno]] + data[[snp]] * data[[pheno]])
    results[[c]] <- model
    tracking[c,1] <- snp
    tracking[c,2] <- pheno
  }
}

#extracing information about each model
pvals <- tibble()
for(i in 1:length(results)){

    pvals[i,1:4] <- tidy(results[[i]]) %>% 
    filter(term == "data[[snp]]:data[[pheno]]") %>% 
    select(estimate, std.error, statistic, p.value)

}

```
## Results

The four measures of childhood trauma all showed succesive decrease in mean age of onset, by trauma severity.


![](/plots/felt_hated_better.png)
![](/plots/sexual_abuse.png)
![](/plots/phys_abuse_better.png)
![](/plots/felt_loved.png)


The vQTL genome-wide analysis found no significant SNPs, but one cluster on chromosome 7 was very close.

![](/plots/final_mhplot.png)





As described above, we extracted the top ten independant SNPs, and tested them in an linear interaction model with the measures of childhood trauma. The graph visualizes all the interaction terms with a p-value less than 0.05. However, since we tested 50 models, the significance threshhold was bonferonni-adjusted to p < 0.001. No interaction term reached the stringent significance threshold

![](/plots/gei_pvals.png)









## Conclusion
This was a short description of the analytic pipeline used for the Bachelor thesis - Interplay of genetic and environmental factors in Age of Onset of Depression.

Full code for each step of the analysis can be found in respective folders.






