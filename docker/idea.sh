#!/usr/bin/env bash

if [ -d /home/dev/.IdeaIC15 ]; then
    # Ensure proper permissions
    sudo chown dev:dev -R /home/dev/.IdeaIC15
fi

exec /opt/intellij/bin/idea.sh