import { copyFileSync, mkdirSync, readFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

// The artwork is frozen at build time; the sandbox needs no renderer or network.
const repository = dirname(fileURLToPath(import.meta.url));
const asset = join(repository, 'entry.png');
const image = readFileSync(asset);
const expectedHash = '307fa23e4e283504024766ab033e870c10ceea396ea3c4fba9771bb50c58bebf';
if (createHash('sha256').update(image).digest('hex') !== expectedHash) {
  throw new Error('The committed artwork changed; review it and update its pinned SHA-256.');
}
const signature = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);
if (image.length < 33 || image.length > 1_048_576 || !image.subarray(0, 8).equals(signature)) {
  throw new Error('The committed artwork must be a PNG no larger than 1 MiB.');
}
const width = image.readUInt32BE(16);
const height = image.readUInt32BE(20);
if (width < 1 || height < 1 || width > 1024 || height > 1024) {
  throw new Error('The committed artwork exceeds the allowed dimensions.');
}
const output = process.env.MAKEFUN_OUTPUT_DIR || '/output';
mkdirSync(output, { recursive: true });
copyFileSync(asset, join(output, 'entry.png'));
