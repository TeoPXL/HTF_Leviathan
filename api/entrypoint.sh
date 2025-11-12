#!/bin/sh

bun add drizzle-kit

#REMOVE EXISTING
echo "Dropping all tables before migration..."
# bun run src/services/clear_database.ts

# MIGRATE
echo "Migrating..."
bun drizzle-kit push --force

echo "converting database data..."
# bun run src/services/databaseConverter.ts


# Start the application
echo "Starting application..."
bun src/index.ts
