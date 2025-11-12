FROM oven/bun

WORKDIR /app

COPY app/package.json app/bun.lock app/health-check.js app/drizzle.config.ts ./

RUN bun install --production

COPY app/src src
COPY entrypoint.sh .
COPY app/tsconfig.json .
# COPY public public

ENV NODE_ENV production
CMD ["./entrypoint.sh"]
# EXPOSE 3000