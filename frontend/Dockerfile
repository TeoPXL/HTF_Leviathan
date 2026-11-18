# Step 1: Build stage
FROM oven/bun:alpine AS build

# Set working directory in the container
WORKDIR /app

# Copy package.json and bun.lockb first for better caching
COPY app/package.json app/bun.lock ./

# Install dependencies with Bun
RUN bun install --frozen-lockfile

# Copy the rest of the project files (including src, public, etc.)
COPY app/ ./

# Build the Vue.js app
RUN bun run --verbose build
# Step 2: Production stage
FROM oven/bun:alpine

WORKDIR /app

# Copy only the built files
COPY --from=build /app/dist ./dist

COPY app/health-check.js ./health-check.js

# Install serve globally
RUN bun add -g serve

# Start the app on port 81
CMD ["serve", "-s", "dist", "-l", "81"]
