#!/bin/bash

set -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)

file_env() {
        local var="$1"
        local fileVar="${var}_FILE"
        local def="${2:-}"
        if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
                echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
                exit 1
        fi
        local val="$def"
        if [ "${!var:-}" ]; then
                val="${!var}"
        elif [ "${!fileVar:-}" ]; then
                val="$(< "${!fileVar}")"
        fi
        export "$var"="$val"
        unset "$fileVar"
}

file_env "DB_PASSWORD"

#bash start.sh -c prepare -a postgres -u postgresql://postgres:postgres@localhost:5432/konga

if [ $# -eq 0 ]
  then
    # If no args are set, start the app as usual
    node --harmony app.js
  else
    while getopts "c:a:u:" option
    do
        case "${option}"
            in
            c) COMMAND=${OPTARG};;
            a) ADAPTER=${OPTARG};;
            u) URI=${OPTARG};;
        esac
    done
    if [ $OPTIND -eq 1 ]
            If expected argument omitted try to execute the command:
            then exec "$@"

#    echo $COMMAND
#    echo $ADAPTER
#    echo $URI
#    echo $PORT

    elif [ "$COMMAND" == "prepare_docker_env" ]
        then
           if [ "$DB_ADAPTER" == "postgres" ]
              then
                URI="postgresql://"
                URI+=$DB_USER
                URI+=":"$DB_PASSWORD
                URI+="@"$DB_HOST
                URI+=":"$DB_PORT
                URI+="/"$DB_DATABASE
                # based on connection string postgresql://user:password@host:5432/konga?ssl=truelocalhost:5432/konga
                echo $URI
                node ./bin/konga.js prepare --adapter $ADAPTER --uri $URI
              else
                echo "This adapter is not yet suppoted"
                exit
           fi
    elif [ "$COMMAND" == "prepare" ]
        then
            node ./bin/konga.js $COMMAND --adapter $ADAPTER --uri $URI
        else
            echo "Invalid command: $COMMAND"
            exit
    fi
fi
