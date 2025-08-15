# fe-erp-migrate

This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VSCode](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Type Support for `.vue` Imports in TS

TypeScript cannot handle type information for `.vue` imports by default, so we replace the `tsc` CLI with `vue-tsc` for type checking. In editors, we need [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) to make the TypeScript language service aware of `.vue` types.

## Customize configuration

See [Vite Configuration Reference](https://vite.dev/config/).

## Environment Configuration

This project uses environment variables for configuration. Copy the example environment file and update it with your settings:

```sh
cp env.example .env
```

### Available Environment Variables

- `VITE_API_BASE_URL`: The base URL for the backend API (default: http://0.0.0.0:8001)

**Note**: Only environment variables prefixed with `VITE_` are exposed to the client-side code.

## Project Setup

```sh
npm install
```

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Type-Check, Compile and Minify for Production

```sh
npm run build
```

### Lint with [ESLint](https://eslint.org/)

```sh
npm run lint
```

## Run using docker

```sh
docker-compose up
```

### Build command

```sh
docker-compose up --build
```

### If you need to open a shell inside the container:

```sh
docker-compose exec vueapp sh
```

Then you can run commands like:

```sh
npm install axios
npm run build
```
