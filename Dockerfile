# =============================================================================
# Stage 1: Builder - npm으로 의존성 설치 및 빌드
# =============================================================================
FROM docker.io/library/node:20-alpine AS builder
WORKDIR /app

RUN apk add --no-cache libc6-compat

COPY docusaurus/package.json docusaurus/package-lock.json* ./
RUN npm ci

COPY docusaurus/ .
RUN npm run build

# =============================================================================
# Stage 2: Runner - Nginx로 정적 파일 서빙
# =============================================================================
FROM zot.lumie-infra.com/platform/nginx:alpine AS runner

RUN apk add --no-cache curl

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
