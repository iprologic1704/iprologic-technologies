# Stage 1: Build
FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

# Stage 2: Production
FROM node:22-alpine AS production

WORKDIR /app

# Only copy what's necessary
COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/public ./public
COPY --from=build /app/.next ./.next
COPY --from=build /app/next.config.mjs ./next.config.mjs

# Set production environment
ENV NODE_ENV=production

# No need to expose the port
# EXPOSE 80 ← remove this

# Start the app — Next.js will read PORT from the environment (.env)
CMD ["npm", "run", "start"]
