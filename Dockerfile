# Base stage --------------------------------------------------------------
FROM node:20-alpine AS base

WORKDIR /app

# Copy package files first for caching
COPY package*.json ./

# ------------------------------------------------------------------------
# Development stage -------------------------------------------------------
FROM base AS development

# Install all dependencies including devDeps
RUN npm install

# Copy source code
COPY . .

# Use root for hot reload tools if needed
USER node

EXPOSE 3000
CMD ["npm", "run", "dev"]


# ------------------------------------------------------------------------
# Build stage -------------------------------------------------------------
FROM base AS build

# Install all deps including devDeps for build
RUN npm install

# Copy source code
COPY . .

# If TypeScript or build step needed:
RUN npm run build


# ------------------------------------------------------------------------
# Production stage --------------------------------------------------------
FROM node:20-alpine AS production

WORKDIR /app

# Copy only package.json again for prod deps only
COPY package*.json ./

# Install only production dependencies
RUN npm npm ci --omit=dev

# Copy built files from build stage
COPY --from=build /app/dist ./dist

# Create non-root user
RUN addgroup -S nodejs && adduser -S nodejs -G nodejs
USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res)=>{process.exit(res.statusCode===200?0:1)}).on('error',()=>process.exit(1))"

CMD ["npm", "start"]
