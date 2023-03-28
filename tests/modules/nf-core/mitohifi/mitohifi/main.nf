#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { MITOHIFI_MITOHIFI } from '../../../../../modules/nf-core/mitohifi/mitohifi/main.nf'

workflow test_mitohifi_mitohifi_contigs {
    
    input = [
        [ id:'test', contigs:true, reads:false ], // meta map
        [ file(params.test_data['homo_sapiens']['pacbio']['fasta']['alz.ccs.fasta'], checkIfExists: true) ]
    ]

    MITOHIFI_MITOHIFI ( input )
}


workflow test_mitohifi_mitohifi_reads {
    
    input = [
        [ id:'test', contigs:false, reads:true ], // meta map
        [ file(params.test_data['homo_sapiens']['pacbio']['fasta']['alz.ccs.fasta'], checkIfExists: true) ]
    ]

    MITOHIFI_MITOHIFI ( input )
}
