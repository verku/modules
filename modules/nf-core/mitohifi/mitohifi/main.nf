process MITOHIFI_MITOHIFI {
    tag "$meta.id"
    label 'process_medium'

    // MitoHifi does not exist as conda package
    // A Docker image is available at the biocontainers Dockerhub
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://biocontainers/mitohifi:2.2_cv1':
        'docker.io/biocontainers/mitohifi:2.2_cv1' }"

    input:
    tuple val(meta), path(fasta)
    path mitoref_fasta
    path mitoref_gb

    output:
    path("${prefix}_final_mitogenome.fasta"), emit: fasta
    path("${prefix}_final_mitogenome.gb")   , emit: gb
    path("${prefix}_contigs_stats.tsv")     , emit: tsv
    path "versions.yml"                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    if (meta.contigs) {
        input_file_args = "-c ${fasta}"
    } else {
        input_file_args = "-r ${fasta}"
    }

    """
    mitohifi.py \\
        $input_file_args \\
        -f $mitoref_fasta \\
        -g $mitoref_gb \\
        -t $task.cpus \\
        $args

    mv final_mitogenome.fasta ${prefix}_final_mitogenome.fasta
    mv final_mitogenome.gb ${prefix}_final_mitogenome.gb
    mv contigs_stats.tsv ${prefix}_contigs_stats.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mitohifi: \$( mitohifi.py --version 2>&1 | head -n1 | sed 's/^.*MitoHiFi //; s/ .*\$//' )
    END_VERSIONS
    """

    stub:
    """
    touch sample_final_mitogenome.fasta
    touch sample_final_mitogenome.gb
    touch sample_contigs_stats.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mitohifi: \$( mitohifi.py --version 2>&1 | head -n1 | sed 's/^.*MitoHiFi //; s/ .*\$//' )
    END_VERSIONS
    """
}
