#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { MITOHIFI_MITOHIFI } from '../../../../../modules/nf-core/mitohifi/mitohifi/main.nf'

workflow test_mitohifi_mitohifi_contigs {
    
    input = 
    [
        [ id:'test', contigs:true, reads:false ], // meta map
        [ file("https://github.com/marcelauliano/MitoHiFi/blob/master/exampleFiles/test.fa", checkIfExists: true) ]
    ]
    mitoref_fasta = file("https://github.com/marcelauliano/MitoHiFi/blob/master/exampleFiles/NC_016067.1.fasta", checkIfExists: true)
    mitoref_gb    = file("https://github.com/marcelauliano/MitoHiFi/blob/master/exampleFiles/NC_016067.1.gb", checkIfExists: true)

    MITOHIFI_MITOHIFI ( input, mitoref_fasta, mitoref_gb )
}


workflow test_mitohifi_mitohifi_reads {
    
    input =
    [
        [ id:'ilDeiPorc1', contigs:false, reads:true ], // meta map
        [ file("https://github.com/marcelauliano/MitoHiFi/blob/master/exampleFiles/ilDeiPorc1.reads.fa", checkIfExists: true) ]
    ]
    mitoref_fasta = file("https://github.com/marcelauliano/MitoHiFi/blob/master/exampleFiles/NC_016067.1.fasta", checkIfExists: true)
    mitoref_gb    = file("https://github.com/marcelauliano/MitoHiFi/blob/master/exampleFiles/NC_016067.1.gb", checkIfExists: true)

    MITOHIFI_MITOHIFI ( input, mitoref_fasta, mitoref_gb )
}
