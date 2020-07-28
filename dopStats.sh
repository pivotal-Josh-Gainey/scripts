#!/bin/bash

login(){
    cf login -a api.system.joshbot.pas -u dopStats -p dopStats -o system -s system --skip-ssl-validation > /dev/null
}

initVars(){
    export DOPINFO_INDEXES_UNSORTED=`cf query "ingress{source_id='doppler'}" |  jq -r '.data.result[] | .metric.index'`
    export DOPINFO_INDEXES=`echo "$DOPINFO_INDEXES_UNSORTED" | tr ' ' '\n' | sort | tr '\n' ' '`
    export DOPINFO_INGRESS=`cf query "rate(ingress{source_id='doppler'}[30s])"|  jq -r '.data.result[] | .metric.index,.value[1]'`
    export DOPINFO_INGRESS_DROP=`cf query "dropped{source_id='doppler', direction='ingress'}" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export DOPINFO_EGRESS=`cf query "rate(egress{source_id='doppler'}[30s])" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export DOPINFO_EGRESS_DROP=`cf query "dropped{source_id='doppler', direction='egress'}" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export DOPINFO_DISPLAY_LOOP_FIRST_ITERATION='true'
}

display(){
    for dopindex in `echo $DOPINFO_INDEXES`
    do 
        if [[ $DOPINFO_DISPLAY_LOOP_FIRST_ITERATION == 'true' ]]; then
            printf "%40s %15s %15s %15s %15s\n" "INDEX" "INGRESS_RATE" "INGRESS_DROP" "EGRESS_RATE" "EGRESS_DROP"
            DOPINFO_DISPLAY_LOOP_FIRST_ITERATION='false'
        fi
        INGRESS=`cut -d " " -f2 <<< "$DOPINFO_INGRESS" | grep $dopindex -A 1 | grep -v $dopindex`
        INDROP=`cut -d " " -f2 <<< "$DOPINFO_INGRESS_DROP" | grep $dopindex -A 1 | grep -v $dopindex`
        EGRESS=`cut -d " " -f2 <<< "$DOPINFO_EGRESS" | grep $dopindex -A 1 | grep -v $dopindex`
        EDROP=`cut -d " " -f2 <<< "$DOPINFO_EGRESS_DROP" | grep $dopindex -A 1 | grep -v $dopindex`
        printf "%40s %15.0f %15.0f %15.0f %15.0f\n" $dopindex "$INGRESS" "$INDROP" "$EGRESS" "$EDROP" 
    done
}
