// Public runtime config for the static site.
// The URL and anon key are safe to expose in the browser; the full-access
// admin API key from .insforge/project.json must never be placed here.
window.INSFORGE_URL = 'https://kwhkyv4r.us-east.insforge.app';
window.INSFORGE_ANON_KEY = 'anon_78999312d4f35fd26f7603ffa66d9fb4900185e140ad93eff42d2762515ce0bf';

// Images are served from InsForge Storage so the deployable site stays small.
window.INSFORGE_IMAGES = {
  'Lote 1': 'https://kwhkyv4r.us-east.insforge.app/api/storage/buckets/lot-images/objects/lote-1.jpeg?v=9f4d55477a06a37d8f09a1c60ac7d97a',
  fallback: 'https://kwhkyv4r.us-east.insforge.app/api/storage/buckets/lot-images/objects/plano.png?v=70449562476ad9a69463b7a8c85b5d2f'
};
