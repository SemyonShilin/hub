#!/usr/bin/env bash
MIX_ENV=prod mix ecto.migrate
MIX_ENV=prod mix phx.server
