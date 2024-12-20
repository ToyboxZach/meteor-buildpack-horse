#!/bin/bash

export NODE_ENV=${NODE_ENV:-production}
cp $HOME/.meteor/heroku_build/bin/node  $HOME/.heroku/node/bin
# If the metrics url is not present, this is the wrong type of dyno, or the user has opted out,
# don't include the metrics plugin
if [[ -n "$HEROKU_METRICS_URL" ]] && [[ "${DYNO}" != run\.* ]] && [[ -z "$HEROKU_SKIP_NODE_PLUGIN" ]]; then

  # Don't clobber NODE_OPTIONS if the user has set it, just add the require flag to the end
  if [[ -z "$NODEJS_PARAMS" ]]; then
      export NODEJS_PARAMS="--require $compile_dir/.heroku/metrics/metrics_collector.cjs"
  else
      export NODEJS_PARAMS="${NODEJS_PARAMS} --require $compile_dir/.meteor/heroku_build/metrics/metrics_collector.cjs"
  fi

fi

echo "RUNNING with" $NODEJS_PARAMS
 $HOME/.heroku/node/bin/node $NODEJS_PARAMS .meteor/heroku_build/app/main.js
