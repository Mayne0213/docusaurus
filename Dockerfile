# =============================================================================
# Stage 1: Base - Node.js 기반 이미지
# =============================================================================
FROM node:20-alpine AS base

# =============================================================================
# Stage 2: Dependencies - 의존성 설치
# =============================================================================
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY docusaurus/package.json docusaurus/package-lock.json* ./
RUN npm ci

# =============================================================================
# Stage 3: Builder - 정적 사이트 빌드
# =============================================================================
FROM base AS builder
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY docusaurus/ .

RUN npm run build

# =============================================================================
# Stage 4: Runner - Nginx로 정적 파일 서빙
# =============================================================================
FROM docker.io/library/nginx:alpine AS runner

RUN apk add --no-cache curl

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
