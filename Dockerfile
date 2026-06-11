# Build Stage
FROM node:16.17.0-alpine AS builder

WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn install

COPY . .

# Build Argument
ARG TMDB_V3_API_KEY

# Pass value only during build
RUN VITE_APP_TMDB_V3_API_KEY=$TMDB_V3_API_KEY \
    VITE_APP_API_ENDPOINT_URL=https://api.themoviedb.org/3 \
    yarn build

# Production Stage
FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=builder /app/dist .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
