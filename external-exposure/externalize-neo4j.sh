 export DEPLOYMENT=nebula
 export IP0=172.17.14.43
 export IP1=172.17.14.43
 export IP2=172.17.14.43
 export ADDR0=$IP0
 export ADDR1=$IP1
 export ADDR2=$IP2
 cat external-exposure/custom-core-configmap.yaml | envsubst | kubectl apply -f -

 helm install $DEPLOYMENT . \
   --set core.numberOfServers=3 \
   --set readReplica.numberOfServers=0 \
   --set core.configMap=$DEPLOYMENT-neo4j-externally-addressable-config \
   --set acceptLicenseAgreement=yes \
   --set neo4jPassword=mySecretPassword

 export CORE_ADDRESSES=($IP0 $IP1 $IP2)
 for x in 0 1 2 ; do
    export IDX=$x
    export IP=${CORE_ADDRESSES[$x]}
    echo $DEPLOYMENT with IDX $IDX and IP $IP ;

    cat external-exposure/load-balancer.yaml | envsubst | kubectl apply -f -
 done