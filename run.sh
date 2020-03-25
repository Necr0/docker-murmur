#!/bin/bash

# Use /etc/murmur.ini as a template and interpolate variables for the environment and write them to /etc/murmur/config.ini.
# This has to be done in order to configure murmur based on environment variables because it does not support setting config option through parameters or environment variables, which is quite stupid IMO
# If /etc/murmur/config.ini already exists this step is skipped.
function interpolate_vars {
    # This function is taken from: https://stackoverflow.com/a/2916159
    line="$(cat; echo -n a)"
    end_offset=${#line}
    while [[ "${line:0:$end_offset}" =~ (.*)(\$\{([a-zA-Z_][a-zA-Z_0-9]*)\})(.*) ]] ; do
        PRE="${BASH_REMATCH[1]}"
        POST="${BASH_REMATCH[4]}${line:$end_offset:${#line}}"
        VARNAME="${BASH_REMATCH[3]}"
        eval 'VARVAL="$'$VARNAME'"'
        line="$PRE$VARVAL$POST"
        end_offset=${#PRE}
    done
    echo -n "${line:0:-1}"
}
if [[ ! -f /etc/murmur/config.ini ]]; then
    echo "No static config file was found, templating config file."
    interpolate_vars < /etc/murmur.ini > /etc/murmur/config.ini;
else
    echo "Static config file found, skipping templating."
fi;

if [[ "$MURMUR_DEBUG_LOG_CONFIG" == "true" ]]; then
    echo "############ BEGINNING OF MURMUR CONFIG ################";
    cat /etc/murmur/config.ini;
    echo "############ END OF MURMUR CONFIG ######################";
fi;

# Set the SuperUser password the environment variable is set
# To do this we have to start murmur with the -supw parameter which makes it set the password and exit, which is quite stupid IMO
if [[ ! -z "$MURMUR_SUPERUSER_PASSWORD" ]]; then
    echo "Setting SuperUser Password.";
    murmurd -fg -v -ini /etc/murmur/config.ini -supw "$MURMUR_SUPERUSER_PASSWORD"
fi;

# Start murmur in foreground mode
murmurd -fg -v -ini /etc/murmur/config.ini
