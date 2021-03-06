echo "set your browser to http://${HOSTNAME}:28778/ to watch logs"
echo "NOTE: This does not add new longs in real time,"
echo "so if new nodes start up you will have to restart this."
confFile=${HOME}/.log.io/harvester.conf
echo "exports.config = {" > ${confFile}
echo "  nodeName: \"application_server\"," >> ${confFile}
echo "  logStreams: {" >> ${confFile}
for i in $(ls ${HOME}/.ros/log)
do
    logFolder=${i}
    firstLine=true
    for j in $(ls ${HOME}/.ros/log/${logFolder})
    do
        logName=$(echo ${j}|sed 's/.log//')
        if [ "$firstLine" = false ]
        then
            echo "  ]," >> ${confFile}
        fi
        firstLine=false
        echo "  \"${logName}\": [" >> ${confFile}
        echo "    \"${HOME}/.ros/log/${logFolder}/${j}\"" >> ${confFile}
    done
done
echo "  ]" >> ${confFile}
echo "}," >> ${confFile}
echo "server: {" >> ${confFile}
echo "    host: '0.0.0.0'," >> ${confFile}
echo "        port: 28777" >> ${confFile}
echo "  }" >> ${confFile}
echo "}" >> ${confFile}
#cat ${confFile}
log.io-server &
log.io-harvester &
echo "To Stop log server run:"
echo "pkill -f log.io"
echo "Or kill_ros.sh also stops this."

