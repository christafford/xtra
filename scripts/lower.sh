#!/bin/bash

pkill -f "tcpserver 127\.0\.0"
aws eks update-kubeconfig --region us-east-2 --name bs-eqs-usoh

# Check if the user provided the -i argument
if [[ "$1" == "-i" ]]; then
    kubectl -n oxs-test-tools exec -it pod/kafdrop-jforero -- apt install -y netcat
fi

tcpserver 127.0.0.2 80 kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc nuget.orderexecution.internal 80 &
tcpserver 127.0.0.3 35770 kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc wowtrader-qa.bs-eqs-usoh.nite.internal 35770 &
tcpserver 127.0.0.4 35772 kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc wowtrader-qa.orderexecution.internal 35772 &
tcpserver 127.0.0.5 10001 kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc wowtrader-qa.orderexecution.internal 10001 &
tcpserver 127.0.0.5 10002 kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc wowtrader-qa.orderexecution.internal 10002 &
tcpserver 127.0.0.6 52999 kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc wowtrader-stg.orderexecution.internal 52999 &

tcpserver 127.0.0.7 6000  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.use2.orderexecution.internal 6000 &
tcpserver 127.0.0.7 6001  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.use2.orderexecution.internal 6001 &
tcpserver 127.0.0.7 6002  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.use2.orderexecution.internal 6002 &
tcpserver 127.0.0.7 6003  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.use2.orderexecution.internal 6003 &
tcpserver 127.0.0.7 6004  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.use2.orderexecution.internal 6004 &

tcpserver 127.0.0.8 6000  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.orderexecution.internal 6000 &
tcpserver 127.0.0.8 6001  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.orderexecution.internal 6001 &
tcpserver 127.0.0.8 6002  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.orderexecution.internal 6002 &
tcpserver 127.0.0.8 6003  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.orderexecution.internal 6003 &
tcpserver 127.0.0.8 6004  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.orderexecution.internal 6004 &

tcpserver 127.0.0.9 6000  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.oxv3.use2.orderexecution.internal 6000 &
tcpserver 127.0.0.9 6001  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.oxv3.use2.orderexecution.internal 6001 &
tcpserver 127.0.0.9 6002  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.oxv3.use2.orderexecution.internal 6002 &
tcpserver 127.0.0.9 6003  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.oxv3.use2.orderexecution.internal 6003 &
tcpserver 127.0.0.9 6004  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.oxv3.use2.orderexecution.internal 6004 &

tcpserver 127.0.0.10 6000  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.dump.orderexecution.internal 6000 &
tcpserver 127.0.0.10 6001  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.dump.orderexecution.internal 6001 &
tcpserver 127.0.0.10 6002  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.dump.orderexecution.internal 6002 &
tcpserver 127.0.0.10 6003  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.dump.orderexecution.internal 6003 &
tcpserver 127.0.0.10 6004  kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc kafka.dump.orderexecution.internal 6004 &

# tcpserver 127.0.0.11 443 kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc grpc-qa1-tools-streaming-balances.bs-eqs-usoh.nite.tradestation.io 443 &
tcpserver 127.0.0.12 58732 kubectl -n oxs-test-tools exec -i kafdrop-jforero -- nc 172.27.32.22 58732 &
