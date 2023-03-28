#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { MITOHIFI_MITOHIFI } from '../../../../../modules/nf-core/mitohifi/mitohifi/main.nf'

workflow test_mitohifi_mitohifi {
    
    input = file(params.test_data['sarscov2']['illumina']['test_single_end_bam'], checkIfExists: true)

    MITOHIFI_MITOHIFI ( input )
}
