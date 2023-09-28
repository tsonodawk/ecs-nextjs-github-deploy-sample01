# FROM node:20-alpine AS base

# # Install dependencies only when needed
# FROM base AS deps
# # Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
# RUN apk add --no-cache libc6-compat
# WORKDIR /src/app

# # Install dependencies based on the preferred package manager
# COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
# RUN \
#     if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
#     elif [ -f package-lock.json ]; then npm ci; \
#     elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
#     else echo "Lockfile not found." && exit 1; \
#     fi


# # Rebuild the source code only when needed
# FROM base AS builder
# WORKDIR /src/app
# COPY --from=deps /src/app/node_modules ./node_modules
# COPY . .

# # Next.js collects completely anonymous telemetry data about general usage.
# # Learn more here: https://nextjs.org/telemetry
# # Uncomment the following line in case you want to disable telemetry during the build.
# # ENV NEXT_TELEMETRY_DISABLED 1

# # RUN yarn build
# RUN npm run build

# # If using npm comment out above and use below instead
# # RUN npm run build

# # Production image, copy all the files and run next
# FROM base AS runner
# WORKDIR /src/app

# ENV NODE_ENV production
# # Uncomment the following line in case you want to disable telemetry during runtime.
# # ENV NEXT_TELEMETRY_DISABLED 1

# RUN addgroup --system --gid 1001 nodejs
# RUN adduser --system --uid 1001 nextjs

# COPY --from=builder /src/app/public ./public

# # Set the correct permission for prerender cache
# RUN mkdir .next
# RUN chown nextjs:nodejs .next

# # Automatically leverage output traces to reduce image size
# # https://nextjs.org/docs/advanced-features/output-file-tracing
# # COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
# COPY --from=builder --chown=nextjs:nodejs /src/app/.next/static ./.next/static

# USER nextjs

# EXPOSE 3000

# ENV PORT 3000
# # set hostname to localhost
# # ENV HOSTNAME "0.0.0.0"

# CMD ["npm", "start"]
# # CMD ["node", "server.js"]

# ==================================================
# パッケージのインストールのレイヤー
# ==================================================
FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /base

# COPY package.json package-lock.json ./
# RUN  npm ci
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
    if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
    elif [ -f package-lock.json ]; then npm ci; \
    elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
    else echo "Lockfile not found." && exit 1; \
    fi

# ==================================================
# アプリのビルドレイヤー
# ==================================================
FROM node:20-alpine AS builder
WORKDIR /build
COPY . /build
# buildは、tsからjsに変換するのでこれがないとエラーになる
COPY tsconfig.json .
# nextのbuildの設定ルール
COPY next.config.js .

COPY --from=deps /base/node_modules ./node_modules

RUN npm run build


# ==================================================
# アプリの実行レイヤー
# ==================================================
FROM node:20-alpine AS runner
#
WORKDIR /app

COPY --from=builder /build/.next ./.next
COPY --from=builder /build/node_modules ./node_modules
COPY --from=builder /build/package.json ./package.json

CMD ["npm", "start"]