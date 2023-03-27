process MITOHIFI_FINDMITOREFERENCE {
    tag '$species'
    label 'process_low'

    // MitoHifi does not exist as conda package
    // The MitoHiFi image is only available on Dockerhub
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://biocontainers/mitohifi:2.2_cv1' }"

    input:
    val species
    val email
    val min_length

    output:
    path "*.fasta",                 emit: mitoref_fasta
    path "*.gb",                    emit: mitoref_gb
    path "versions.yml",            emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    findMitoReference.py \\
        --species $species \\
        --email $email \\
        --min_length $min_length \\
        --outfolder .

     cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mitohifi: \$( mitohifi.py --version )
    END_VERSIONS
    """
}