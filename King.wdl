version 1.0

import "https://raw.githubusercontent.com/mgbpm/biofx-workflows/refs/heads/main/steps/VCFUtils.wdl" as VCFUtils
import "https://raw.githubusercontent.com/mgbpm/biofx-workflows/refs/heads/feature/ibd/workflows/ibd/subwdls/king.wdl" as KingWorkflow
import "https://raw.githubusercontent.com/mgbpm/biofx-workflows/refs/heads/feature/ibd/workflows/ibd/subwdls/ldpruning.wdl" as LdPruningWorkflow
import "https://raw.githubusercontent.com/mgbpm/biofx-workflows/refs/heads/feature/ibd/workflows/ibd/subwdls/vcf-to-gds.wdl" as Vcf2GdsWorkflow

workflow KingOrchestrationWorkflow {
    input {
        Array[File] input_vcfs
        File? input_bed
        File? sample_include_file
        File? variant_include_file
        File? phenotype_file
        String? group
        Float sparse_threshold = 0.02209709
        Float kinship_plot_threshold = 0.04419417382
        Boolean ld_pruning = false
        String genome_build = "hg38"
        Boolean check_gds = false
        String output_basename
        String king_docker_image = "uwgac/topmed-master@sha256:f2445668725434ea6e4114af03f2857d411ab543f42a553f5856f2958e6e9428"
        String bcftools_docker_image = "us-central1-docker.pkg.dev/mgb-lmm-gcp-infrast-1651079146/mgbpmbiofx/bcftools:1.17"
    }

    if (genome_build == "hg38" || genome_build == "GRCh38" || genome_build == "grch38") {
        String build38 = "hg38"
    }
    if (genome_build == "hg18" || genome_build == "GRCh37" || genome_build == "grch37") {
        String build37 = "hg19"
    }
    String input_build = select_first([build38, build37])
    if (!defined(input_build)) {
        call Utilities.FailTask {
            input:
                error_message = "Genome build must be hg38/GRCh38 or hg19/GRCh37. Default is hg38."
        }
    }

    if (defined(input_bed)) {
        scatter (vcf in input_vcfs) {
            call VCFUtils.FilterVCFWithBEDTask as FilterVcfs {
                input:
                    input_vcf = vcf,
                    input_bed = select_first([input_bed]),
                    output_index = false,
                    docker_image = bcftools_docker_image
            }
        }
    }

    call Vcf2GdsWorkflow.vcftogds as ConvertVcfs {
        input:
            vcf_files = select_first([
                FilterVcfs.output_vcf_gz,
                input_vcfs
            ]),
            king_docker_image = king_docker_image
    }

    if (ld_pruning) {
        call LdPruningWorkflow.ldpruning as LdPruning {
            input:
                gds_files = ConvertVcfs.gds_with_unique_ids,
                sample_include_file = sample_include_file,
                variant_include_file = variant_include_file,
                out_prefix = output_basename,
                check_gds = check_gds,
                genome_build = genome_build,
                king_docker_image = king_docker_image
        }
    }
    if (!ld_pruning) {
        call LdPruningWorkflow.merge_gds as MergeGds {
            input:
                gdss = ConvertVcfs.gds_with_unique_ids,
                docker_image = king_docker_image
        }
    }

    call KingWorkflow.king as RunKing {
        input:
            gds_file = select_first([
                LdPruning.merged_gds,
                MergeGds.merged_gds_output
            ]),
            sample_include_file = sample_include_file,
            variant_include_file = variant_include_file,
            phenotype_file = phenotype_file,
            out_prefix = output_basename,
            group = group,
            kinship_plot_threshold = kinship_plot_threshold,
            sparse_threshold = sparse_threshold,
            king_docker_image = king_docker_image
    }

    output {
        File? ibdseg_matrix = RunKing.king_ibdseg_matrix
        File? ibdseg_plots = RunKing.king_ibdseg_plots
        File? ibdseg_seg = RunKing.king_ibdseg_output
        File? kin_file = RunKing.king_kin_output
    }
}
