# terrenos

Landing page for Loteos Ivo (Eldorado, Misiones). Lot data and images are served by
[InsForge](https://insforge.dev).

**Live site:** https://terrenos-web-d2364bdd-c7fe-494b-9a82-4e9f7c13f9b4.fly.dev

It runs as an InsForge Compute service (`terrenos-web`, nginx) because the Vercel-backed
`deployments deploy` path is currently failing on the InsForge side with
`Failed to fetch Vercel credentials`.

## Backend

- Project: `terrenos` (`https://kwhkyv4r.us-east.insforge.app`)
- CLI link: `.insforge/project.json` (gitignored, contains the full-access admin key — never expose it)
- Schema: [`migrations/20261124203949_create-lots.sql`](migrations/20261124203949_create-lots.sql)
  creates the `public.lots` table (prices, availability, cadastral polygon, image URL/key)
  with public **read-only** access. Writing is admin-only.
- Storage: public bucket `lot-images` holds `lote-1.jpeg` and `plano.png`.
- Data: `datos.json` and `parcelas.geojson` were the original sources and are kept as an
  offline fallback if the backend is unreachable.

### Update a lot

```bash
npx -y @insforge/cli db query "UPDATE public.lots SET precio = 16000, estado = 'disponible' WHERE name = 'Lote 4'"
```

### Schema changes

```bash
npx -y @insforge/cli db migrations new <change-name>
# edit migrations/<timestamp>_<change-name>.sql
npx -y @insforge/cli db migrations up --all
```

## Runtime config

`index.html` loads `@insforge/sdk` from a CDN. `insforge-config.js` holds the project URL
and anon key (both public-safe). `.env.local` mirrors those values for tooling. If the
anon key is rotated, update both files.

## Redeploy the site

The `web/` directory is the image build context. After changing `index.html` or
`insforge-config.js`, copy them into `web/` and redeploy (requires `flyctl` on PATH,
installed with `curl -L https://fly.io/install.sh | sh`; no local Docker needed):

```bash
cp index.html insforge-config.js datos.json parcelas.geojson web/
npx -y @insforge/cli compute deploy ./web --name terrenos-web --port 80
```

Use `npx -y @insforge/cli compute list` to check status and `compute events <id>` if the
service does not come up. Vercel deployments can be retried later with
`npx -y @insforge/cli deployments deploy . --json`.
