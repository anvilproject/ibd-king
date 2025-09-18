# KING Tasks

## FilterVcfTask

### Input Parameters

| Type | Name | Req'd | Description | Default Value |
| :--- | :--- | :---: | :--- | :--- |
| File | input_vcf | Yes | VCF or VCF gz to filter | |
| File | input_bed | Yes | BED file containing regions to filter to | |
| String | output_basename | No | Basename for output filtered VCF | Defaults to basename of input VCF |
| Int | addldisk | No | Addition disk space to add to the final runtime disk space in GB | 10 |
| Int | preemptible | No | Number of retries for VM | 1 |

### Output Parameters

| Type | Name | When | Description |
| :--- | :--- | :--- | :--- |
| File | output_vcf_gz | If an input BED is supplied | VCF filtered to regions in the input BED file |
| Int | num_snps | Always | Number of SNPs in the input bed file |
| Int | num_samples | Always | Number of samples in the output VCF |

## MergeVcfsTask

### Input Parameters

| Type | Name | Req'd | Description | Default Value |
| :--- | :--- | :---: | :--- | :--- |
| Array[File] | input_vcfs | Yes | VCFs with non-overlapping samples to merge into one VCF | |
| Array[File] | input_vcfs_idx | No | Index files corresponding to input VCFs; must be in the same order as the input VCF array | |
| File | input_bed | No | BED file with regions to filter the merged VCF to | |
| String | output_basename | Yes | Basename for output files | |
| String | docker_image | Yes | Docker image for bcftools | |
| Int | addldisk | No | Addition disk space to add to the final runtime disk space in GB | 10 |
| Int | mem_size | No | Memory for runtime | Defaults to 4; If the size of input VCFs is greater than 10, defaults to 8 |
| Int | preemptible | No | Number of retries for VM | 2 |

### Output Parameters

| Type | Name | When | Description |
| :--- | :--- | :--- | :--- |
| File | merged_vcf | Always | Merged VCF of all input VCFs, filtered to regions in the input BED file if given |
| Int | num_snps | Always | Number of SNPs in the input bed file |
| Int | num_samples | Always | Number of samples in the output VCF |

## Vcf2BedTask

### Input Parameters

| Type | Name | Req'd | Description | Default Value |
| :--- | :--- | :---: | :--- | :--- |
| File | input_vcf | Yes | VCF to convert to PLINK BED | |
| String | output_basename | No | Basename for output files | Defaults to basename of input VCF |
| String | docker_image | Yes | Docker image that contains PLINK | |
| Int | addldisk | No | Addition disk space to add to the final runtime disk space in GB | 10 |
| Int | plink_mem | No | Memory to use for PLINK in GB; Actual runtime memory will be twice the size of the input PLINK memory | 4 |
| Int | preemptible | No | Number of retries for VM | 1 |

### Output Parameters

| Type | Name | When | Description |
| :--- | :--- | :--- | :--- |
| File | bed_file | Always | PLINK BED from VCF |
| File | bim_file | Always | BIM file corresponding to output PLINK BED |
| File | fam_file | Always | FAM file corresponding to output PLINK BED |

## IbdsegTask

### Input Parameters

| Type | Name | Req'd | Description | Default Value |
| :--- | :--- | :---: | :--- | :--- |
| File | bed_file | Yes | PLINK BED file from converting input VCF to BED | |
| File | bim_file | Yes | PLINK BIM file corresponding to input BED | |
| File | fam_file | Yes | PLINK FAM file corresponding to input BEB | |
| String | output_basename | Yes | Basename for output files | |
| Int | degree | Yes | Largest degree of relatedness allowed for KING relationships | |
| String | docker_image | Yes | Docker image for running KING | |
| Int | addldisk | No | Addition disk space to add to the final runtime disk space in GB | 10 |
| Int | cpu | No | CPU for runtime | 2 |
| Int | mem_size | No | Memory for runtime | 4 |
| Int | preemptible | No | Number of retries for VM | 2 |

### Output Parameters

| Type | Name | When | Description |
| :--- | :--- | :--- | :--- |
| File | ibdseg_output | Always | .seg file from running KING --ibdseg; contains kinship coefficients and inferred relationships of samples |

## KinshipTask

### Input Parameters

| Type | Name | Req'd | Description | Default Value |
| :--- | :--- | :---: | :--- | :--- |
| File | bed_file | Yes | PLINK BED file from converting input VCF to BED | |
| File | bim_file | Yes | PLINK BIM file corresponding to input BED | |
| File | fam_file | Yes | PLINK FAM file corresponding to input BEB | |
| String | output_basename | Yes | Basename for output files | |
| Int | degree | Yes | Largest degree of relatedness allowed for KING relationships | |
| String | docker_image | Yes | Docker image for running KING | |
| Int | addldisk | No | Addition disk space to add to the final runtime disk space in GB | 10 |
| Int | cpu | No | CPU for runtime | 2 |
| Int | mem_size | No | Memory for runtime | 4 |
| Int | preemptible | No | Number of retries for VM | 2 |

### Output Parameters

| Type | Name | When | Description |
| :--- | :--- | :--- | :--- |
| File | kinship_output | Always | .kin file from running KING --kinship; contains kinship coefficients of individuals |
| File | kinship_output_0 | Always | Second .kin file from running KING --kinship; contains kinship coefficients of between-family relationship checking |

## RelatedTask

### Input Parameters

| Type | Name | Req'd | Description | Default Value |
| :--- | :--- | :---: | :--- | :--- |
| File | bed_file | Yes | PLINK BED file from converting input VCF to BED | |
| File | bim_file | Yes | PLINK BIM file corresponding to input BED | |
| File | fam_file | Yes | PLINK FAM file corresponding to input BEB | |
| String | output_basename | Yes | Basename for output files | |
| Int | degree | Yes | Largest degree of relatedness allowed for KING relationships | |
| String | docker_image | Yes | Docker image for running KING | |
| Int | addldisk | No | Addition disk space to add to the final runtime disk space in GB | 10 |
| Int | cpu | No | CPU for runtime | 2 |
| Int | mem_size | No | Memory for runtime | 4 |
| Int | preemptible | No | Number of retries for VM | 2 |

### Output Parameters

| Type | Name | When | Description |
| :--- | :--- | :--- | :--- |
| File | related_output | Always | .kin file from running KING --related; contains kinship coefficients and inferred relationships of individuals |
| File | related_output_0 | Always | Second .kin file from running KING --related; contains kinship coefficients of between-family relationship checking |
