import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { mkdirSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { inflateSync } from 'node:zlib';

const root = dirname(fileURLToPath(import.meta.url));
const local = join(root, '.local');
mkdirSync(local, { recursive: true });
const sha256 = bytes => createHash('sha256').update(bytes).digest('hex');

function crc32(bytes) {
  let crc = 0xffffffff;
  for (const byte of bytes) {
    crc ^= byte;
    for (let bit = 0; bit < 8; bit++) {
      crc = (crc >>> 1) ^ ((crc & 1) ? 0xedb88320 : 0);
    }
  }
  return (crc ^ 0xffffffff) >>> 0;
}

function validatePng(bytes) {
  assert(bytes.length <= 1_048_576, 'Image exceeds 1 MiB');
  assert(bytes.subarray(0, 8).equals(Buffer.from([137,80,78,71,13,10,26,10])), 'PNG signature');
  let offset = 8;
  let header;
  let ended = false;
  const chunks = [];
  const idat = [];
  while (offset < bytes.length) {
    assert(offset + 12 <= bytes.length, 'Truncated chunk');
    const length = bytes.readUInt32BE(offset);
    const end = offset + 12 + length;
    assert(end <= bytes.length, 'Truncated chunk payload');
    const type = bytes.toString('ascii', offset + 4, offset + 8);
    const data = bytes.subarray(offset + 8, end - 4);
    assert.equal(crc32(bytes.subarray(offset + 4, end - 4)), bytes.readUInt32BE(end - 4), `${type} checksum`);
    if (chunks.length === 0) assert.equal(type, 'IHDR');
    if (type === 'IHDR') {
      assert.equal(header, undefined, 'Duplicate IHDR');
      assert.equal(length, 13);
      header = data;
    }
    if (type === 'IDAT') idat.push(data);
    chunks.push(type);
    offset = end;
    if (type === 'IEND') {
      assert.equal(length, 0);
      ended = true;
      break;
    }
  }
  assert(ended && offset === bytes.length, 'Missing IEND or trailing bytes');
  assert(idat.length > 0, 'Missing image data');
  const width = header.readUInt32BE(0);
  const height = header.readUInt32BE(4);
  assert(width > 0 && width <= 1024 && height > 0 && height <= 1024);
  assert.equal(header[8], 8, 'Expected 8-bit pixels');
  assert.equal(header[9], 6, 'Expected RGBA');
  assert.equal(header[10], 0, 'PNG compression method');
  assert.equal(header[11], 0, 'PNG filter method');
  assert.equal(header[12], 0, 'Expected non-interlaced image');
  const decoded = inflateSync(Buffer.concat(idat), { maxOutputLength: 5 * 1024 * 1024 });
  const stride = width * 4 + 1;
  assert.equal(decoded.length, stride * height, 'Wrong decompressed image size');
  for (let y = 0; y < height; y++) assert(decoded[y * stride] <= 4, 'Invalid PNG row filter');
  return { format: 'PNG', width, height, bytes: bytes.length, sha256: sha256(bytes), chunks };
}

const outputs = [];
for (const name of ['run-a', 'run-b']) {
  const directory = join(local, name);
  mkdirSync(directory, { recursive: true });
  // Different working directories also check module-relative asset resolution.
  const child = spawnSync(process.execPath, [join(root, 'main.ts')], {
    cwd: directory,
    env: { ...process.env, MAKEFUN_OUTPUT_DIR: directory },
    encoding: 'utf8',
    timeout: 60_000,
  });
  assert.equal(child.status, 0, child.error?.message || child.stderr);
  assert.deepEqual(readdirSync(directory), ['entry.png'], 'Exactly one output file');
  outputs.push(readFileSync(join(directory, 'entry.png')));
}
assert(outputs[0].equals(outputs[1]), 'Independent runs differ');
assert(outputs[0].equals(readFileSync(join(root, 'entry.png'))), 'Output differs from committed asset');
const report = {
  ...validatePng(outputs[0]),
  independentRuns: 2,
  deterministic: true,
  onlyOutput: 'entry.png',
  node: process.version,
  noRuntimeDependencies: true,
};
writeFileSync(join(local, 'image-validation.json'), JSON.stringify(report, null, 2) + '\n');
console.log(JSON.stringify(report, null, 2));
