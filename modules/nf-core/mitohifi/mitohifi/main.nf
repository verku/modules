// TODO nf-core: If in doubt look at other nf-core/modules to see how we are doing things! :)
//               https://github.com/nf-core/modules/tree/master/modules/nf-core/
//               You can also ask for help via your pull request or on the #modules channel on the nf-core Slack workspace:
//               https://nf-co.re/join
// TODO nf-core: A module file SHOULD only define input and output files as command-line parameters.
//               All other parameters MUST be provided using the "task.ext" directive, see here:
//               https://www.nextflow.io/docs/latest/process.html#ext
//               where "task.ext" is a string.
//               Any parameters that need to be evaluated in the context of a particular sample
//               e.g. single-end/paired-end data MUST also be defined and evaluated appropriately.
// TODO nf-core: Software that can be piped together SHOULD be added to separate module files
//               unless there is a run-time, storage advantage in implementing in this way
//               e.g. it's ok to have a single module for bwa to output BAM instead of SAM:
//                 bwa mem | samtools view -B -T ref.fasta
// TODO nf-core: Optional inputs are not currently supported by Nextflow. However, using an empty
//               list (`[]`) instead of a file can be used to work around this issue.

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
    path "versions.yml"                   , emit: versions

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

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mitohifi: \$( mitohifi.py --version 2>&1 | head -n1 | sed 's/^.*MitoHiFi //; s/ .*\$//' )
    END_VERSIONS
    """
}
