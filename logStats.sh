#!/bin/bash

initVars(){
    export DOPINFO_INDEXES_UNSORTED=`cf query "ingress{source_id='doppler'}" |  jq -r '.data.result[] | .metric.index'`
    export DOPINFO_INDEXES=`echo "$DOPINFO_INDEXES_UNSORTED" | tr ' ' '\n' | sort | tr '\n' ' '`
    export DOPINFO_INGRESS=`cf query "rate(ingress{source_id='doppler'}[30s])"|  jq -r '.data.result[] | .metric.index,.value[1]'`
    export DOPINFO_INGRESS_DROP=`cf query "dropped{source_id='doppler', direction='ingress'}" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export DOPINFO_EGRESS=`cf query "egress{source_id='doppler'}" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export DOPINFO_EGRESS_DROP=`cf query "dropped{source_id='doppler', direction='egress'}" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export DOPINFO_SUBSCRIPTIONS=`cf query "subscriptions{source_id='doppler'}" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export DOPINFO_DISPLAY_LOOP_FIRST_ITERATION='true'

    export RLPINFO_INDEXES_UNSORTED=`cf query "ingress{source_id='reverse_log_proxy'}" |  jq -r '.data.result[] | .metric.index'`
    export RLPINFO_INDEXES=`echo "$RLPINFO_INDEXES_UNSORTED" | tr ' ' '\n' | sort | tr '\n' ' '`
    export RLPINFO_INGRESS=`cf query "rate(ingress{source_id='reverse_log_proxy'}[2m])"|  jq -r '.data.result[] | .metric.index,.value[1]'`
    export RLPINFO_EGRESS=`cf query "egress{source_id='reverse_log_proxy'}" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export RLPINFO_EGRESS_DROP=`cf query "dropped{source_id='reverse_log_proxy', direction='egress'}" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export RLPINFO_SUBSCRIPTIONS=`cf query "subscriptions{source_id='reverse_log_proxy'}" |  jq -r '.data.result[] | .metric.index,.value[1]'`
    export RLPINFO_DISPLAY_LOOP_FIRST_ITERATION='true'
}

display(){
    for dopindex in `echo $DOPINFO_INDEXES`
    do 
        if [[ $DOPINFO_DISPLAY_LOOP_FIRST_ITERATION == 'true' ]]; then
            printf "DOPPLER STATS \n"
            printf "%40s %15s %15s %15s %15s %15s\n" "INDEX" "INGRESS_RATE" "INGRESS_DROP" "EGRESS_TOTAL" "EGRESS_DROP" "SUBSCRIPTIONS"
            DOPINFO_DISPLAY_LOOP_FIRST_ITERATION='false'
        fi
        INGRESS=`cut -d " " -f2 <<< "$DOPINFO_INGRESS" | grep $dopindex -A 1 | grep -v $dopindex`
        INDROP=`cut -d " " -f2 <<< "$DOPINFO_INGRESS_DROP" | grep $dopindex -A 1 | grep -v $dopindex`
        EGRESS=`cut -d " " -f2 <<< "$DOPINFO_EGRESS" | grep $dopindex -A 1 | grep -v $dopindex`
        EDROP=`cut -d " " -f2 <<< "$DOPINFO_EGRESS_DROP" | grep $dopindex -A 1 | grep -v $dopindex`
        SUBS=`cut -d " " -f2 <<< "$DOPINFO_SUBSCRIPTIONS" | grep $dopindex -A 1 | grep -v $dopindex`
        printf "%40s %15.0f %15.0f %15.0f %15.0f %15.0F\n" $dopindex "$INGRESS" "$INDROP" "$EGRESS" "$EDROP" "$SUBS"
    done

    for rlpindex in `echo $RLPINFO_INDEXES`
    do 
        if [[ $RLPINFO_DISPLAY_LOOP_FIRST_ITERATION == 'true' ]]; then
            printf "\n\nRLP STATS\n"
            printf "%40s %15s %15s %15s %15s\n" "INDEX" "INGRESS_RATE" "EGRESS_TOTAL" "RLP_DROP" "SUBSCRIPTIONS"
            RLPINFO_DISPLAY_LOOP_FIRST_ITERATION='false'
        fi
        RLPINGRESS=`cut -d " " -f2 <<< "$RLPINFO_INGRESS" | grep $rlpindex -A 1 | grep -v $rlpindex`
        RLPEGRESS=`cut -d " " -f2 <<< "$RLPINFO_EGRESS" | grep $rlpindex -A 1 | grep -v $rlpindex`
        RLPEDROP=`cut -d " " -f2 <<< "$RLPINFO_EGRESS_DROP" | grep $rlpindex -A 1 | grep -v $rlpindex`
        RLPSUBS=`cut -d " " -f2 <<< "$RLPINFO_SUBSCRIPTIONS" | grep $rlpindex -A 1 | grep -v $rlpindex`
        printf "%40s %15.0f %15.0f %15.0f %15.0f\n" $rlpindex "$RLPINGRESS" "$RLPEGRESS" "$RLPEDROP" "$RLPSUBS"
    done
}

initVars
display

