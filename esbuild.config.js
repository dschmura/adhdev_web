#!/usr/bin/env node

// Esbuild is configured with 3 modes:
//
// `yarn build` - Build JavaScript and exit
// `yarn build --watch` - Rebuild JavaScript on change
// `yarn build --reload` - Reloads page when views, JavaScript, or stylesheets change
//
// Minify is enabled when "RAILS_ENV=production"
// Sourcemaps are enabled in non-production environments

const esbuild = require('esbuild')
const path = require('path')
const rails = require('esbuild-rails')

const clients = []
const entryPoints = [
  "application.js",
  "administrate.js"
]
const watchDirectories = [
  "./app/javascript/**/*.js",
  "./app/views/**/*.html.erb",
  "./app/assets/builds/**/*.css", // Wait for cssbundling changes
]
const config = {
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  bundle: true,
  entryPoints: entryPoints,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  plugins: [rails()],
  sourcemap: process.env.RAILS_ENV != "production"
}

async function buildAndReload() {
  const chokidar = require('chokidar')
  const http = require('http')

  // Foreman & Overmind assign a separate PORT for each process
  const port = parseInt(process.env.PORT)

  // Reload uses an HTTP server as an even stream to reload the browser
  http.createServer((req, res) => {
    return clients.push(
      res.writeHead(200, {
        "Content-Type": "text/event-stream",
        "Cache-Control": "no-cache",
        "Access-Control-Allow-Origin": "*",
        Connection: "keep-alive",
      }),
    );
  }).listen(port);

  let result = await esbuild.build({
    ...config,
    incremental: true,
    banner: {
      js: ` (() => new EventSource("http://localhost:${port}").onmessage = () => location.reload())();`,
    },
  })

  chokidar.watch(watchDirectories).on('all', (event, path) => {
    if (path.includes("javascript")) {
      result.rebuild()
    }
    clients.forEach((res) => res.write('data: update\n\n'))
    clients.length = 0
  });
}

if (process.argv.includes("--reload")) {
  buildAndReload()

} else if (process.argv.includes("--watch")) {
  // Watch uses esbuild's watch option
  const watch = process.argv.includes("--watch") && {
    onRebuild(error) {
      if (error) console.error("[watch] build failed", error);
      else console.log("[watch] build finished");
    },
  };

  esbuild.build({
    ...config,
    watch: watch,
  }).catch(() => process.exit(1));

} else {
  // Standard esbuild
  esbuild.build({
    ...config,
    minify: process.env.RAILS_ENV == "production",
  }).catch(() => process.exit(1));
}
