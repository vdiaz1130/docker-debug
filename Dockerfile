# Development Image
FROM node:20-alpine AS development

# Set the working directory
WORKDIR /usr/src/app

# Copy the package.json and pnpm-lock.yaml files
COPY package.json ./
COPY pnpm-lock.yaml ./

# Install the dependencies
RUN npm install -g pnpm
RUN pnpm install

# Copy the source code directories
COPY apps/auth-gateway ./apps/auth-gateway
# COPY libs ./libs

# Copy the source files
COPY .eslintignore ./
COPY .eslintrc.json ./
COPY jest.config.ts ./
COPY jest.preset.js ./
COPY nx.json ./
COPY tsconfig.base.json ./

ARG service
RUN pnpm nx reset
RUN pnpm nx build auth-gateway

FROM node:20-alpine AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

# Copy the source files
COPY package.json ./
COPY pnpm-lock.yaml ./
COPY .eslintignore ./
COPY .eslintrc.json ./
COPY jest.config.ts ./
COPY jest.preset.js ./
COPY nx.json ./
COPY tsconfig.base.json ./

# Install the dependencies
RUN npm install -g pnpm
RUN pnpm install --prod

COPY --from=development /usr/src/app/dist/apps/auth-gateway ./dist

EXPOSE 8080

# Run the service
CMD ["node", "dist/main"]
